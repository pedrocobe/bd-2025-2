-- =====================================================
-- TRIGGERS - E-COMMERCE EXAM
-- =====================================================
-- Este archivo contiene todos los triggers necesarios para automatizar
-- acciones en la base de datos del sistema de e-commerce
-- =====================================================

-- =====================================================
-- TRIGGER 1: Actualizar totales de pedido automáticamente
-- =====================================================
-- Descripción: Cuando se inserta, actualiza o elimina un order_item,
-- recalcula automáticamente el subtotal, tax y total del pedido
SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION update_order_totals()
RETURNS TRIGGER AS $$
DECLARE
    v_subtotal DECIMAL(10,2);
    v_tax DECIMAL(10,2);
    v_shipping DECIMAL(10,2);
    v_total DECIMAL(10,2);
BEGIN
    -- Obtener el order_id (puede venir de NEW o OLD dependiendo de la operación)
    DECLARE
        v_order_id INTEGER;
    BEGIN
        IF TG_OP = 'DELETE' THEN
            v_order_id := OLD.order_id;
        ELSE
            v_order_id := NEW.order_id;
        END IF;

        -- Calcular subtotal de todos los items del pedido
        SELECT COALESCE(SUM(subtotal), 0)
        INTO v_subtotal
        FROM order_items
        WHERE order_id = v_order_id;

        -- Obtener el shipping_cost del pedido
        SELECT shipping_cost
        INTO v_shipping
        FROM orders
        WHERE id = v_order_id;

        -- Calcular tax (12% del subtotal - ejemplo para Ecuador)
        v_tax := ROUND(v_subtotal * 0.12, 2);

        -- Calcular total
        v_total := v_subtotal + v_tax + v_shipping;

        -- Actualizar el pedido
        UPDATE orders
        SET 
            subtotal = v_subtotal,
            tax = v_tax,
            total = v_total,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = v_order_id;
    END;

    RETURN NULL; -- Para triggers AFTER
END;
$$ LANGUAGE plpgsql;

-- Aplicar el trigger a order_items
CREATE TRIGGER trg_order_items_update_totals
    AFTER INSERT OR UPDATE OR DELETE ON order_items
    FOR EACH ROW
    EXECUTE FUNCTION update_order_totals();

COMMENT ON TRIGGER trg_order_items_update_totals ON order_items IS 
'Actualiza automáticamente los totales del pedido cuando se modifican los items';


-- =====================================================
-- TRIGGER 2: Actualizar estadísticas de clientes
-- =====================================================
-- Descripción: Cuando un pedido cambia de estado, actualiza
-- total_spent y order_count del cliente

CREATE OR REPLACE FUNCTION update_customer_statistics()
RETURNS TRIGGER AS $$
BEGIN
    -- Solo actualizar si el pedido NO está cancelado
    UPDATE customers
    SET 
        total_spent = (
            SELECT COALESCE(SUM(total), 0)
            FROM orders
            WHERE customer_id = NEW.customer_id 
            AND status != 'cancelled'
        ),
        order_count = (
            SELECT COUNT(*)
            FROM orders
            WHERE customer_id = NEW.customer_id 
            AND status != 'cancelled'
        ),
        updated_at = CURRENT_TIMESTAMP
    WHERE id = NEW.customer_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar el trigger a orders cuando se actualiza el status
CREATE TRIGGER trg_orders_update_customer_stats
    AFTER INSERT OR UPDATE OF status ON orders
    FOR EACH ROW
    EXECUTE FUNCTION update_customer_statistics();

COMMENT ON TRIGGER trg_orders_update_customer_stats ON orders IS 
'Actualiza las estadísticas del cliente cuando cambia el estado del pedido';


-- =====================================================
-- TRIGGER 3: Validar stock antes de crear order_item
-- =====================================================
-- Descripción: Verifica que haya suficiente stock antes de
-- agregar un producto a un pedido

CREATE OR REPLACE FUNCTION validate_stock_before_order()
RETURNS TRIGGER AS $$
DECLARE
    v_available_stock INTEGER;
    v_product_name VARCHAR(200);
BEGIN
    -- Obtener el stock disponible del producto
    SELECT stock_quantity, name
    INTO v_available_stock, v_product_name
    FROM products
    WHERE id = NEW.product_id;

    -- Validar que hay suficiente stock
    IF v_available_stock < NEW.quantity THEN
        RAISE EXCEPTION 'Stock insuficiente para el producto "%". Disponible: %, Solicitado: %',
            v_product_name, v_available_stock, NEW.quantity;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar el trigger BEFORE INSERT en order_items
CREATE TRIGGER trg_order_items_validate_stock
    BEFORE INSERT ON order_items
    FOR EACH ROW
    EXECUTE FUNCTION validate_stock_before_order();

COMMENT ON TRIGGER trg_order_items_validate_stock ON order_items IS 
'Valida que haya stock suficiente antes de agregar un item al pedido';


-- =====================================================
-- TRIGGER 4: Reducir stock al confirmar pedido
-- =====================================================
-- Descripción: Cuando un pedido pasa a 'processing', reduce
-- el stock de los productos

CREATE OR REPLACE FUNCTION reduce_stock_on_processing()
RETURNS TRIGGER AS $$
BEGIN
    -- Solo ejecutar si el status cambió a 'processing'
    IF NEW.status = 'processing' AND (OLD.status IS NULL OR OLD.status != 'processing') THEN
        
        -- Reducir el stock de todos los productos del pedido
        UPDATE products p
        SET stock_quantity = stock_quantity - oi.quantity
        FROM order_items oi
        WHERE oi.order_id = NEW.id
        AND p.id = oi.product_id;
        
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar el trigger a orders
CREATE TRIGGER trg_orders_reduce_stock
    AFTER UPDATE OF status ON orders
    FOR EACH ROW
    EXECUTE FUNCTION reduce_stock_on_processing();

COMMENT ON TRIGGER trg_orders_reduce_stock ON orders IS 
'Reduce el stock de productos cuando el pedido pasa a estado processing';


-- =====================================================
-- TRIGGER 5: Restaurar stock al cancelar pedido
-- =====================================================
-- Descripción: Cuando un pedido se cancela, devuelve el stock
-- de los productos al inventario

CREATE OR REPLACE FUNCTION restore_stock_on_cancel()
RETURNS TRIGGER AS $$
BEGIN
    -- Solo ejecutar si el status cambió a 'cancelled' y antes estaba en 'processing'
    IF NEW.status = 'cancelled' AND OLD.status = 'processing' THEN
        
        -- Restaurar el stock de todos los productos del pedido
        UPDATE products p
        SET stock_quantity = stock_quantity + oi.quantity
        FROM order_items oi
        WHERE oi.order_id = NEW.id
        AND p.id = oi.product_id;
        
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar el trigger a orders
CREATE TRIGGER trg_orders_restore_stock
    AFTER UPDATE OF status ON orders
    FOR EACH ROW
    EXECUTE FUNCTION restore_stock_on_cancel();

COMMENT ON TRIGGER trg_orders_restore_stock ON orders IS 
'Restaura el stock cuando un pedido se cancela';


-- =====================================================
-- TRIGGER 6: Auditoría automática de cambios en productos
-- =====================================================
-- Descripción: Registra en audit_log los cambios en productos

CREATE OR REPLACE FUNCTION audit_product_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log (table_name, record_id, action, new_data, changed_at)
        VALUES ('products', NEW.id, 'INSERT', row_to_json(NEW), CURRENT_TIMESTAMP);
        
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_log (table_name, record_id, action, old_data, new_data, changed_by, changed_at)
        VALUES ('products', NEW.id, 'UPDATE', row_to_json(OLD), row_to_json(NEW), NEW.created_by, CURRENT_TIMESTAMP);
        
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log (table_name, record_id, action, old_data, changed_at)
        VALUES ('products', OLD.id, 'DELETE', row_to_json(OLD), CURRENT_TIMESTAMP);
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Aplicar el trigger a products
CREATE TRIGGER trg_products_audit
    AFTER INSERT OR UPDATE OR DELETE ON products
    FOR EACH ROW
    EXECUTE FUNCTION audit_product_changes();

COMMENT ON TRIGGER trg_products_audit ON products IS 
'Registra todos los cambios en productos en la tabla de auditoría';


-- =====================================================
-- TRIGGER 7: Calcular subtotal automáticamente en order_items
-- =====================================================
-- Descripción: Calcula el subtotal del item antes de insertar

CREATE OR REPLACE FUNCTION calculate_order_item_subtotal()
RETURNS TRIGGER AS $$
BEGIN
    -- Calcular subtotal = quantity * unit_price
    NEW.subtotal := NEW.quantity * NEW.unit_price;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar el trigger BEFORE INSERT/UPDATE en order_items
CREATE TRIGGER trg_order_items_calculate_subtotal
    BEFORE INSERT OR UPDATE ON order_items
    FOR EACH ROW
    EXECUTE FUNCTION calculate_order_item_subtotal();

COMMENT ON TRIGGER trg_order_items_calculate_subtotal ON order_items IS 
'Calcula automáticamente el subtotal del item';


-- =====================================================
-- TRIGGER 8: Prevenir eliminación de categorías con productos
-- =====================================================
-- Descripción: No permite eliminar una categoría si tiene productos asociados

CREATE OR REPLACE FUNCTION prevent_category_delete_with_products()
RETURNS TRIGGER AS $$
DECLARE
    v_product_count INTEGER;
BEGIN
    -- Contar productos en esta categoría
    SELECT COUNT(*)
    INTO v_product_count
    FROM products
    WHERE category_id = OLD.id;

    IF v_product_count > 0 THEN
        RAISE EXCEPTION 'No se puede eliminar la categoría "%". Tiene % producto(s) asociado(s)',
            OLD.name, v_product_count;
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Aplicar el trigger BEFORE DELETE en categories
CREATE TRIGGER trg_categories_prevent_delete
    BEFORE DELETE ON categories
    FOR EACH ROW
    EXECUTE FUNCTION prevent_category_delete_with_products();

COMMENT ON TRIGGER trg_categories_prevent_delete ON categories IS 
'Previene la eliminación de categorías que tienen productos asociados';


-- =====================================================
-- TRIGGER 9: Generar número de orden automáticamente
-- =====================================================
-- Descripción: Genera un número de orden único al crear un pedido

CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS TRIGGER AS $$
BEGIN
    -- Si no viene order_number, generarlo
    IF NEW.order_number IS NULL OR NEW.order_number = '' THEN
        NEW.order_number := 'ORD-' || 
                           TO_CHAR(CURRENT_DATE, 'YYYYMMDD') || '-' || 
                           LPAD(nextval('orders_id_seq')::TEXT, 6, '0');
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar el trigger BEFORE INSERT en orders
CREATE TRIGGER trg_orders_generate_number
    BEFORE INSERT ON orders
    FOR EACH ROW
    EXECUTE FUNCTION generate_order_number();

COMMENT ON TRIGGER trg_orders_generate_number ON orders IS 
'Genera automáticamente un número de orden único';


-- =====================================================
-- TRIGGER 10: Validar email único para clientes
-- =====================================================
-- Descripción: Previene duplicados de email en clientes

CREATE OR REPLACE FUNCTION validate_customer_email_unique()
RETURNS TRIGGER AS $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM customers
    WHERE email = NEW.email
    AND id != COALESCE(NEW.id, 0);

    IF v_count > 0 THEN
        RAISE EXCEPTION 'El email "%" ya está registrado para otro cliente', NEW.email;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar el trigger BEFORE INSERT/UPDATE en customers
CREATE TRIGGER trg_customers_validate_email
    BEFORE INSERT OR UPDATE ON customers
    FOR EACH ROW
    EXECUTE FUNCTION validate_customer_email_unique();

COMMENT ON TRIGGER trg_customers_validate_email ON customers IS 
'Valida que el email del cliente sea único';


-- =====================================================
-- FIN DE TRIGGERS
-- =====================================================

-- Verificación: Listar todos los triggers creados
SELECT 
    trigger_name,
    event_object_table AS table_name,
    action_timing,
    event_manipulation AS event
FROM information_schema.triggers
WHERE trigger_schema = 'public'
ORDER BY event_object_table, trigger_name;

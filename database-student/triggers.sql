-- =====================================================
-- TRIGGERS - E-COMMERCE EXAM
-- =====================================================
-- INSTRUCCIONES:
-- 1. Crea 9 triggers con sus funciones asociadas
-- 2. Cada trigger automatiza una operación específica
-- 3. Usa CREATE OR REPLACE FUNCTION para la función
-- 4. Usa CREATE TRIGGER para el trigger
-- 5. Especifica el momento: BEFORE o AFTER
-- 6. Especifica la operación: INSERT, UPDATE, DELETE
-- 7. Usa FOR EACH ROW para triggers a nivel de fila
-- =====================================================

-- TRIGGER 1: update_updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

-- Triggers para las 5 tablas principales
-- Elimina el trigger si ya existe para evitar errores al volver a ejecutar el script
DROP TRIGGER IF EXISTS trg_users_updated_at ON users;
-- Crea el trigger que actualiza automáticamente el campo updated_at en la tabla users
CREATE TRIGGER trg_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
-- Elimina el trigger anterior en caso de que ya exista en la tabla categories
DROP TRIGGER IF EXISTS trg_categories_updated_at ON categories;
-- Crea el trigger que actualiza el campo updated_at cuando se modifica una categoría
CREATE TRIGGER trg_categories_updated_at
BEFORE UPDATE ON categories
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
-- Elimina el trigger existente para evitar duplicados al ejecutar el script
DROP TRIGGER IF EXISTS trg_products_updated_at ON products;
-- Crea el trigger que actualiza updated_at cada vez que se modifica un producto
CREATE TRIGGER trg_products_updated_at
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
-- Borra el trigger si ya existe en la tabla customers
DROP TRIGGER IF EXISTS trg_customers_updated_at ON customers;
-- Crea el trigger que actualiza la fecha de modificación del cliente
CREATE TRIGGER trg_customers_updated_at
BEFORE UPDATE ON customers
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
-- Elimina el trigger anterior si existe en la tabla orders
DROP TRIGGER IF EXISTS trg_orders_updated_at ON orders;
-- Crea el trigger que actualiza el campo updated_at cuando se modifica un pedido
CREATE TRIGGER trg_orders_updated_at
BEFORE UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- TRIGGER 2: validate_product_stock
CREATE OR REPLACE FUNCTION validate_product_stock()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_available_stock INTEGER;
BEGIN
    SELECT stock_quantity
    INTO v_available_stock
    FROM products
    WHERE id = NEW.product_id;
    IF v_available_stock < NEW.quantity THEN
        RAISE EXCEPTION 'Stock insuficiente para el producto %', NEW.product_id;
    END IF;
    RETURN NEW;
END;
$$;
-- Elimina el trigger de validación de stock si ya existe
DROP TRIGGER IF EXISTS check_product_stock ON order_items;
CREATE TRIGGER check_product_stock
BEFORE INSERT ON order_items
FOR EACH ROW
EXECUTE FUNCTION validate_product_stock();

-- TRIGGER 3: update_product_stock
CREATE OR REPLACE FUNCTION update_product_stock()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE products
        SET stock_quantity = stock_quantity - NEW.quantity
        WHERE id = NEW.product_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE products
        SET stock_quantity = stock_quantity + OLD.quantity
        WHERE id = OLD.product_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$;
-- Elimina el trigger de actualización de inventario si existe
DROP TRIGGER IF EXISTS update_stock_on_order_item ON order_items;
CREATE TRIGGER update_stock_on_order_item
AFTER INSERT OR DELETE ON order_items
FOR EACH ROW
EXECUTE FUNCTION update_product_stock();

-- TRIGGER 4: calculate_order_item_subtotal
CREATE OR REPLACE FUNCTION calculate_order_item_subtotal()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.subtotal = NEW.quantity * NEW.unit_price;
    RETURN NEW;
END;
$$;
-- Elimina el trigger de cálculo de subtotal si ya fue creado
DROP TRIGGER IF EXISTS set_order_item_subtotal ON order_items;
CREATE TRIGGER set_order_item_subtotal
BEFORE INSERT ON order_items
FOR EACH ROW
EXECUTE FUNCTION calculate_order_item_subtotal();

-- TRIGGER 5: update_order_totals
CREATE OR REPLACE FUNCTION update_order_totals()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_order_id INTEGER;
    v_subtotal DECIMAL(12,2);
    v_tax DECIMAL(12,2);
    v_shipping DECIMAL(12,2);
    v_total DECIMAL(12,2);
BEGIN
-- Determinar ID del pedido
    IF TG_OP = 'INSERT' THEN
        v_order_id = NEW.order_id;
    ELSE
        v_order_id = OLD.order_id;
    END IF;
-- Calcular nuevo subtotal
    SELECT COALESCE(SUM(subtotal), 0)
    INTO v_subtotal
    FROM order_items
    WHERE order_id = v_order_id;
-- Calcular impuesto (16%)
    v_tax = v_subtotal * 0.16;
-- Obtener costo de envío 
    SELECT shipping_cost
    INTO v_shipping
    FROM orders
    WHERE id = v_order_id;
-- Calcular total 
    v_total = v_subtotal + v_tax + COALESCE(v_shipping, 0);
-- Actualizar pedido
    UPDATE orders
    SET subtotal = v_subtotal,
        tax = v_tax,
        total = v_total
    WHERE id = v_order_id;
    IF TG_OP = 'INSERT' THEN
        RETURN NEW;
    ELSE
        RETURN OLD;
    END IF;
END;
$$;
-- Elimina el trigger de actualización de totales del pedido si existe
DROP TRIGGER IF EXISTS update_order_totals_trigger ON order_items;
CREATE TRIGGER update_order_totals_trigger
AFTER INSERT OR DELETE ON order_items
FOR EACH ROW
EXECUTE FUNCTION update_order_totals();

-- TRIGGER 6: audit_product_changes
CREATE OR REPLACE FUNCTION audit_product_changes()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log(table_name, record_id, action, old_values, changed_at)
        VALUES ('products', OLD.id, 'DELETE', row_to_json(OLD), CURRENT_TIMESTAMP);
        RETURN OLD;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_log(table_name, record_id, action, old_values, new_values, changed_at)
        VALUES ('products', NEW.id, 'UPDATE', row_to_json(OLD), row_to_json(NEW), CURRENT_TIMESTAMP);
        RETURN NEW;
    ELSIF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log(table_name, record_id, action, new_values, changed_at)
        VALUES ('products', NEW.id, 'INSERT', row_to_json(NEW), CURRENT_TIMESTAMP);
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$;
-- Elimina el trigger de auditoría de productos si existe
DROP TRIGGER IF EXISTS audit_products ON products;
CREATE TRIGGER audit_products
AFTER INSERT OR UPDATE OR DELETE ON products
FOR EACH ROW
EXECUTE FUNCTION audit_product_changes();

-- TRIGGER 7: prevent_negative_price
CREATE OR REPLACE FUNCTION prevent_negative_price()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.price <= 0 OR NEW.cost <= 0 THEN
        RAISE EXCEPTION 'El precio y el costo deben ser mayores a cero';
    END IF;
    RETURN NEW;
END;
$$;
-- Elimina el trigger de validación de precios si ya existe
DROP TRIGGER IF EXISTS check_product_price ON products;
CREATE TRIGGER check_product_price
BEFORE INSERT OR UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION prevent_negative_price();

-- TRIGGER 8: update_customer_stats_on_order
CREATE OR REPLACE FUNCTION update_customer_stats_on_order()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        PERFORM update_customer_statistics(NEW.customer_id);
    ELSIF TG_OP = 'UPDATE' AND OLD.status != NEW.status THEN
        PERFORM update_customer_statistics(NEW.customer_id);
    END IF;
    RETURN NEW;
END;
$$;
-- Elimina el trigger de actualización de estadísticas del cliente si existe
DROP TRIGGER IF EXISTS update_customer_stats ON orders;
CREATE TRIGGER update_customer_stats
AFTER INSERT OR UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION update_customer_stats_on_order();

-- TRIGGER 9: set_order_number
CREATE OR REPLACE FUNCTION set_order_number()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_year VARCHAR;
    v_sequence INTEGER;
    v_order_number VARCHAR;
BEGIN
    IF NEW.order_number IS NULL OR NEW.order_number = '' THEN
        v_year = EXTRACT(YEAR FROM CURRENT_DATE)::VARCHAR;
        SELECT COUNT(*) + 1
        INTO v_sequence
        FROM orders
        WHERE EXTRACT(YEAR FROM created_at) = EXTRACT(YEAR FROM CURRENT_DATE);
        v_order_number = 'ORD-' || v_year || '-' || LPAD(v_sequence::VARCHAR, 4, '0');
        NEW.order_number = v_order_number;
    END IF;
    RETURN NEW;
END;
$$;
-- Elimina el trigger de generación automática del número de pedido si existe
DROP TRIGGER IF EXISTS generate_order_number ON orders;
CREATE TRIGGER generate_order_number
BEFORE INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION set_order_number();

-- =====================================================
-- VERIFICACIÓN (opcional)
-- =====================================================
-- Después de crear tus triggers, puedes verificar que existen con:
-- SELECT trigger_name, event_manipulation, event_object_table 
-- FROM information_schema.triggers 
-- WHERE trigger_schema = 'public';
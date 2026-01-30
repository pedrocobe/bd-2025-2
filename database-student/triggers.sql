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
-- Descripción: Actualiza automáticamente el campo updated_at cuando se modifica un registro
-- Aplica a: users, categories, products, customers, orders
-- Momento: BEFORE UPDATE
--
-- Función:
-- - Crea una función update_updated_at_column()
-- - RETURNS TRIGGER
-- - Asigna NEW.updated_at = CURRENT_TIMESTAMP
-- - Retorna NEW
--
-- Trigger:
-- - Crea un trigger para cada tabla mencionada
-- - Usa DROP TRIGGER IF EXISTS antes de crear
-- - BEFORE UPDATE ON [tabla]
-- - FOR EACH ROW EXECUTE FUNCTION update_updated_at_column()
--
-- TODO: Escribe la función y los 5 triggers aquí
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para users
DROP TRIGGER IF EXISTS update_updated_at_users ON users;
CREATE TRIGGER update_updated_at_users
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Trigger para categories
DROP TRIGGER IF EXISTS update_updated_at_categories ON categories;
CREATE TRIGGER update_updated_at_categories
BEFORE UPDATE ON categories
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Trigger para products
DROP TRIGGER IF EXISTS update_updated_at_products ON products;
CREATE TRIGGER update_updated_at_products
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Trigger para customers
DROP TRIGGER IF EXISTS update_updated_at_customers ON customers;
CREATE TRIGGER update_updated_at_customers
BEFORE UPDATE ON customers
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Trigger para orders
DROP TRIGGER IF EXISTS update_updated_at_orders ON orders;
CREATE TRIGGER update_updated_at_orders
BEFORE UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- TRIGGER 2: validate_product_stock
-- Descripción: Valida que hay stock suficiente ANTES de insertar un order_item
-- Aplica a: order_items
-- Momento: BEFORE INSERT
--
-- Función validate_product_stock():
-- - Declara variable v_available_stock INTEGER
-- - SELECT stock_quantity INTO v_available_stock FROM products WHERE id = NEW.product_id
-- - IF v_available_stock < NEW.quantity THEN
--     RAISE EXCEPTION 'Stock insuficiente...'
-- - Retorna NEW
--
-- Trigger check_product_stock:
-- - BEFORE INSERT ON order_items
-- - FOR EACH ROW
--
-- TODO: Escribe la función y el trigger aquí
CREATE OR REPLACE FUNCTION validate_product_stock()
RETURNS TRIGGER AS $$
DECLARE
    v_available_stock INTEGER;
BEGIN
    -- Obtener stock disponible del producto
    SELECT stock_quantity INTO v_available_stock
    FROM products 
    WHERE id = NEW.product_id;
    
    -- Verificar si el producto existe
    IF v_available_stock IS NULL THEN
        RAISE EXCEPTION 'Producto con ID % no existe', NEW.product_id;
    END IF;
    
    -- Verificar stock suficiente
    IF v_available_stock < NEW.quantity THEN
        RAISE EXCEPTION 'Stock insuficiente para producto ID %. Disponible: %, Solicitado: %', 
                        NEW.product_id, v_available_stock, NEW.quantity;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS check_product_stock ON order_items;
CREATE TRIGGER check_product_stock
BEFORE INSERT ON order_items
FOR EACH ROW
EXECUTE FUNCTION validate_product_stock();

-- TRIGGER 3: update_product_stock
-- Descripción: Actualiza el inventario cuando se insertan o eliminan order_items
-- Aplica a: order_items
-- Momento: AFTER INSERT OR DELETE
--
-- Función update_product_stock():
-- - IF TG_OP = 'INSERT' THEN
--     UPDATE products SET stock_quantity = stock_quantity - NEW.quantity WHERE id = NEW.product_id
--     RETURN NEW
-- - ELSIF TG_OP = 'DELETE' THEN
--     UPDATE products SET stock_quantity = stock_quantity + OLD.quantity WHERE id = OLD.product_id
--     RETURN OLD
-- - Retorna NULL si no es ninguno
--
-- Trigger update_stock_on_order_item:
-- - AFTER INSERT OR DELETE ON order_items
-- - FOR EACH ROW
--
-- TODO: Escribe la función y el trigger aquí
CREATE OR REPLACE FUNCTION update_product_stock()
RETURNS TRIGGER AS $$
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
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_stock_on_order_item ON order_items;
CREATE TRIGGER update_stock_on_order_item
AFTER INSERT OR DELETE ON order_items
FOR EACH ROW
EXECUTE FUNCTION update_product_stock();

-- TRIGGER 4: calculate_order_item_subtotal
-- Descripción: Calcula automáticamente el subtotal de un order_item (quantity * unit_price)
-- Aplica a: order_items
-- Momento: BEFORE INSERT
--
-- Función calculate_order_item_subtotal():
-- - NEW.subtotal := NEW.quantity * NEW.unit_price
-- - Retorna NEW
--
-- Trigger set_order_item_subtotal:
-- - BEFORE INSERT ON order_items
-- - FOR EACH ROW
--
-- TODO: Escribe la función y el trigger aquí
-- NOTA: En tu schema, order_items ya tiene un campo total_price GENERATED ALWAYS
-- Así que este trigger es para propósitos educativos
CREATE OR REPLACE FUNCTION calculate_order_item_subtotal()
RETURNS TRIGGER AS $$
BEGIN
    -- El campo total_price ya es calculado automáticamente en tu schema
    -- Pero si necesitáramos calcularlo manualmente:
    -- NEW.total_price := (NEW.unit_price - NEW.discount) * NEW.quantity;
    
    -- Para este ejercicio, podemos verificar que el cálculo sea correcto
    IF NEW.unit_price <= 0 THEN
        RAISE EXCEPTION 'El precio unitario debe ser mayor a 0';
    END IF;
    
    IF NEW.quantity <= 0 THEN
        RAISE EXCEPTION 'La cantidad debe ser mayor a 0';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_order_item_subtotal ON order_items;
CREATE TRIGGER set_order_item_subtotal
BEFORE INSERT ON order_items
FOR EACH ROW
EXECUTE FUNCTION calculate_order_item_subtotal();

-- TRIGGER 5: update_order_totals
-- Descripción: Recalcula subtotal, tax y total de un pedido cuando se agregan/eliminan items
-- Aplica a: order_items
-- Momento: AFTER INSERT OR DELETE
--
-- Función update_order_totals():
-- - Declara variables: v_order_id, v_subtotal, v_tax, v_shipping, v_total
-- - Determina v_order_id según TG_OP (NEW.order_id o OLD.order_id)
-- - SELECT SUM(subtotal) INTO v_subtotal FROM order_items WHERE order_id = v_order_id
-- - Calcula v_tax = v_subtotal * 0.16 (16% de impuesto)
-- - SELECT shipping_cost INTO v_shipping FROM orders WHERE id = v_order_id
-- - Calcula v_total = v_subtotal + v_tax + v_shipping
-- - UPDATE orders SET subtotal=..., tax=..., total=... WHERE id = v_order_id
-- - Retorna OLD o NEW según TG_OP
--
-- Trigger update_order_totals_trigger:
-- - AFTER INSERT OR DELETE ON order_items
-- - FOR EACH ROW
--
-- TODO: Escribe la función y el trigger aquí
CREATE OR REPLACE FUNCTION update_order_totals()
RETURNS TRIGGER AS $$
DECLARE
    v_order_id INTEGER;
    v_subtotal DECIMAL(10,2);
    v_tax DECIMAL(10,2);
    v_shipping DECIMAL(10,2);
    v_total DECIMAL(10,2);
BEGIN
    -- Determinar el ID del pedido según la operación
    IF TG_OP = 'INSERT' THEN
        v_order_id := NEW.order_id;
    ELSIF TG_OP = 'DELETE' THEN
        v_order_id := OLD.order_id;
    ELSE
        RETURN COALESCE(NEW, OLD);
    END IF;
    
    -- Calcular nuevo subtotal sumando todos los items del pedido
    SELECT COALESCE(SUM(total_price), 0)
    INTO v_subtotal
    FROM order_items
    WHERE order_id = v_order_id;
    
    -- Obtener costo de envío del pedido
    SELECT COALESCE(shipping_amount, 0)
    INTO v_shipping
    FROM orders
    WHERE id = v_order_id;
    
    -- Calcular impuestos (16%)
    v_tax := v_subtotal * 0.16;
    
    -- Calcular total
    v_total := v_subtotal + v_tax + v_shipping;
    
    -- Actualizar el pedido
    UPDATE orders
    SET 
        subtotal = v_subtotal,
        tax_amount = v_tax,
        total_amount = v_total,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = v_order_id;
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_order_totals_trigger ON order_items;
CREATE TRIGGER update_order_totals_trigger
AFTER INSERT OR DELETE ON order_items
FOR EACH ROW
EXECUTE FUNCTION update_order_totals();

-- TRIGGER 6: audit_product_changes
-- Descripción: Registra en audit_log todos los cambios (INSERT/UPDATE/DELETE) en productos
-- Aplica a: products
-- Momento: AFTER INSERT OR UPDATE OR DELETE
--
-- Función audit_product_changes():
-- - IF TG_OP = 'DELETE' THEN
--     INSERT INTO audit_log (table_name, record_id, action, old_values, changed_at)
--     VALUES ('products', OLD.id, 'DELETE', row_to_json(OLD), CURRENT_TIMESTAMP)
--     RETURN OLD
-- - ELSIF TG_OP = 'UPDATE' THEN
--     INSERT INTO audit_log (table_name, record_id, action, old_values, new_values, changed_at)
--     VALUES ('products', NEW.id, 'UPDATE', row_to_json(OLD), row_to_json(NEW), CURRENT_TIMESTAMP)
--     RETURN NEW
-- - ELSIF TG_OP = 'INSERT' THEN
--     INSERT INTO audit_log (table_name, record_id, action, new_values, changed_at)
--     VALUES ('products', NEW.id, 'INSERT', row_to_json(NEW), CURRENT_TIMESTAMP)
--     RETURN NEW
-- - Retorna NULL si no aplica
--
-- NOTA: Asegúrate que la tabla audit_log existe en tu schema.sql
--
-- Trigger audit_products:
-- - AFTER INSERT OR UPDATE OR DELETE ON products
-- - FOR EACH ROW
--
-- TODO: Escribe la función y el trigger aquí
CREATE OR REPLACE FUNCTION audit_product_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log (
            table_name, 
            record_id, 
            operation, 
            old_values, 
            changed_at
        ) VALUES (
            'products', 
            OLD.id, 
            'DELETE', 
            to_jsonb(OLD), 
            CURRENT_TIMESTAMP
        );
        RETURN OLD;
        
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_log (
            table_name, 
            record_id, 
            operation, 
            old_values, 
            new_values, 
            changed_at
        ) VALUES (
            'products', 
            NEW.id, 
            'UPDATE', 
            to_jsonb(OLD), 
            to_jsonb(NEW), 
            CURRENT_TIMESTAMP
        );
        RETURN NEW;
        
    ELSIF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log (
            table_name, 
            record_id, 
            operation, 
            new_values, 
            changed_at
        ) VALUES (
            'products', 
            NEW.id, 
            'INSERT', 
            to_jsonb(NEW), 
            CURRENT_TIMESTAMP
        );
        RETURN NEW;
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS audit_products ON products;
CREATE TRIGGER audit_products
AFTER INSERT OR UPDATE OR DELETE ON products
FOR EACH ROW
EXECUTE FUNCTION audit_product_changes();

-- TRIGGER 7: prevent_negative_price
-- Descripción: Valida que price y cost sean mayores a cero
-- Aplica a: products
-- Momento: BEFORE INSERT OR UPDATE
--
-- Función prevent_negative_price():
-- - IF NEW.price <= 0 OR NEW.cost <= 0 THEN
--     RAISE EXCEPTION 'El precio y el costo deben ser mayores a cero'
-- - Retorna NEW
--
-- Trigger check_product_price:
-- - BEFORE INSERT OR UPDATE ON products
-- - FOR EACH ROW
--
-- TODO: Escribe la función y el trigger aquí
CREATE OR REPLACE FUNCTION prevent_negative_price()
RETURNS TRIGGER AS $$
BEGIN
    -- Validar precio
    IF NEW.price <= 0 THEN
        RAISE EXCEPTION 'El precio debe ser mayor a cero. Valor recibido: %', NEW.price;
    END IF;
    
    -- Validar costo (puede ser NULL o 0, pero si se especifica debe ser positivo)
    IF NEW.cost IS NOT NULL AND NEW.cost < 0 THEN
        RAISE EXCEPTION 'El costo no puede ser negativo. Valor recibido: %', NEW.cost;
    END IF;
    
    -- Validar stock
    IF NEW.stock_quantity < 0 THEN
        RAISE EXCEPTION 'El stock no puede ser negativo. Valor recibido: %', NEW.stock_quantity;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS check_product_price ON products;
CREATE TRIGGER check_product_price
BEFORE INSERT OR UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION prevent_negative_price();

-- TRIGGER 8: update_customer_stats_on_order
-- Descripción: Actualiza estadísticas del cliente cuando se crea o cambia estado de un pedido
-- Aplica a: orders
-- Momento: AFTER INSERT OR UPDATE
--
-- Función update_customer_stats_on_order():
-- - IF TG_OP = 'UPDATE' AND OLD.status != NEW.status THEN
--     PERFORM update_customer_statistics(NEW.customer_id)
-- - ELSIF TG_OP = 'INSERT' THEN
--     PERFORM update_customer_statistics(NEW.customer_id)
-- - Retorna NEW
--
-- NOTA: Usa PERFORM en lugar de SELECT cuando llamas a una función sin capturar resultado
-- NOTA: Esta función requiere que hayas creado update_customer_statistics() en functions.sql
--
-- Trigger update_customer_stats:
-- - AFTER INSERT OR UPDATE ON orders
-- - FOR EACH ROW
--
-- TODO: Escribe la función y el trigger aquí
CREATE OR REPLACE FUNCTION update_customer_stats_on_order()
RETURNS TRIGGER AS $$
BEGIN
    -- Si es una inserción (nuevo pedido) o el estado cambió
    IF TG_OP = 'UPDATE' AND OLD.status != NEW.status THEN
        PERFORM update_customer_statistics(NEW.customer_id);
    ELSIF TG_OP = 'INSERT' THEN
        PERFORM update_customer_statistics(NEW.customer_id);
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_customer_stats ON orders;
CREATE TRIGGER update_customer_stats
AFTER INSERT OR UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION update_customer_stats_on_order();

-- TRIGGER 9: set_order_number
-- Descripción: Genera automáticamente un número de pedido único (ej: ORD-2025-0001)
-- Aplica a: orders
-- Momento: BEFORE INSERT
--
-- Función set_order_number():
-- - Declara variables: v_year, v_sequence, v_order_number
-- - IF NEW.order_number IS NULL OR NEW.order_number = '' THEN
--     v_year := EXTRACT(YEAR FROM CURRENT_DATE)::VARCHAR
--     SELECT COUNT(*) + 1 INTO v_sequence FROM orders WHERE EXTRACT(YEAR FROM created_at) = EXTRACT(YEAR FROM CURRENT_DATE)
--     v_order_number := 'ORD-' || v_year || '-' || LPAD(v_sequence::VARCHAR, 4, '0')
--     NEW.order_number := v_order_number
-- - Retorna NEW
--
-- NOTA: LPAD(v_sequence::VARCHAR, 4, '0') rellena con ceros a la izquierda (ej: 0001, 0042, 1234)
--
-- Trigger generate_order_number:
-- - BEFORE INSERT ON orders
-- - FOR EACH ROW
--
-- TODO: Escribe la función y el trigger aquí
CREATE OR REPLACE FUNCTION set_order_number()
RETURNS TRIGGER AS $$
DECLARE
    v_year VARCHAR(4);
    v_sequence INTEGER;
    v_order_number VARCHAR(50);
BEGIN
    -- Solo generar número si no se proporcionó uno
    IF NEW.order_number IS NULL OR TRIM(NEW.order_number) = '' THEN
        -- Obtener año actual
        v_year := EXTRACT(YEAR FROM CURRENT_DATE)::VARCHAR;
        
        -- Contar pedidos del año actual y sumar 1
        SELECT COALESCE(COUNT(*), 0) + 1
        INTO v_sequence
        FROM orders 
        WHERE EXTRACT(YEAR FROM created_at) = EXTRACT(YEAR FROM CURRENT_DATE);
        
        -- Formatear número de pedido: ORD-2025-0001
        v_order_number := 'ORD-' || v_year || '-' || LPAD(v_sequence::VARCHAR, 4, '0');
        
        -- Asignar al nuevo pedido
        NEW.order_number := v_order_number;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

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

DO $$
BEGIN
    RAISE NOTICE '✅ 9 triggers creados correctamente:';
    RAISE NOTICE '   1. update_updated_at (5 tablas)';
    RAISE NOTICE '   2. validate_product_stock';
    RAISE NOTICE '   3. update_product_stock';
    RAISE NOTICE '   4. calculate_order_item_subtotal';
    RAISE NOTICE '   5. update_order_totals';
    RAISE NOTICE '   6. audit_product_changes';
    RAISE NOTICE '   7. prevent_negative_price';
    RAISE NOTICE '   8. update_customer_stats_on_order';
    RAISE NOTICE '   9. set_order_number';
END $$;
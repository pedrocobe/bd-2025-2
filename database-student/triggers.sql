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



-- =====================================================
-- VERIFICACIÓN (opcional)
-- =====================================================
-- Después de crear tus triggers, puedes verificar que existen con:
-- SELECT trigger_name, event_manipulation, event_object_table 
-- FROM information_schema.triggers 
-- WHERE trigger_schema = 'public';

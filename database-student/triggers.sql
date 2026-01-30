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
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar a las 5 tablas mencionadas
DROP TRIGGER IF EXISTS tr_users_updated_at ON users;
CREATE TRIGGER tr_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS tr_categories_updated_at ON categories;
CREATE TRIGGER tr_categories_updated_at BEFORE UPDATE ON categories FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS tr_products_updated_at ON products;
CREATE TRIGGER tr_products_updated_at BEFORE UPDATE ON products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS tr_customers_updated_at ON customers;
CREATE TRIGGER tr_customers_updated_at BEFORE UPDATE ON customers FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS tr_orders_updated_at ON orders;
CREATE TRIGGER tr_orders_updated_at BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();


-- TRIGGER 2: validate_product_stock
CREATE OR REPLACE FUNCTION validate_product_stock()
RETURNS TRIGGER AS $$
DECLARE
    v_available_stock INTEGER;
BEGIN
    SELECT stock_quantity INTO v_available_stock FROM products WHERE id = NEW.product_id;
    
    IF v_available_stock < NEW.quantity THEN
        RAISE EXCEPTION 'Stock insuficiente para el producto ID % (Disponible: %, Solicitado: %)', NEW.product_id, v_available_stock, NEW.quantity;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_product_stock BEFORE INSERT ON order_items
FOR EACH ROW EXECUTE FUNCTION validate_product_stock();


-- TRIGGER 3: update_product_stock
CREATE OR REPLACE FUNCTION update_product_stock()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE products SET stock_quantity = stock_quantity - NEW.quantity WHERE id = NEW.product_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE products SET stock_quantity = stock_quantity + OLD.quantity WHERE id = OLD.product_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_stock_on_order_item AFTER INSERT OR DELETE ON order_items
FOR EACH ROW EXECUTE FUNCTION update_product_stock();


-- TRIGGER 4: calculate_order_item_subtotal
CREATE OR REPLACE FUNCTION calculate_order_item_subtotal()
RETURNS TRIGGER AS $$
BEGIN
    NEW.subtotal := NEW.quantity * NEW.unit_price;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_order_item_subtotal BEFORE INSERT ON order_items
FOR EACH ROW EXECUTE FUNCTION calculate_order_item_subtotal();


-- TRIGGER 5: update_order_totals
CREATE OR REPLACE FUNCTION update_order_totals()
RETURNS TRIGGER AS $$
DECLARE
    v_order_id INTEGER;
    v_subtotal DECIMAL(10,2);
    v_tax DECIMAL(10,2);
    v_shipping DECIMAL(10,2);
    v_total DECIMAL(10,2);
BEGIN
    -- Determinar el ID según la operación
    v_order_id := COALESCE(NEW.order_id, OLD.order_id);
    
    -- Calcular subtotal sumando items
    SELECT COALESCE(SUM(subtotal), 0) INTO v_subtotal FROM order_items WHERE order_id = v_order_id;
    
    -- Impuesto 16%
    v_tax := ROUND(v_subtotal * 0.16, 2);
    
    -- Obtener shipping_cost de la orden (usar 0 si es nulo)
    SELECT COALESCE(shipping_cost, 0) INTO v_shipping FROM orders WHERE id = v_order_id;
    
    -- Total final
    v_total := v_subtotal + v_tax + v_shipping;
    
    -- Actualizar orden (Asegúrate que estas columnas existen en tu tabla orders)
    UPDATE orders 
    SET subtotal = v_subtotal, 
        tax = v_tax, 
        total = v_total 
    WHERE id = v_order_id;

    IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_order_totals_trigger AFTER INSERT OR DELETE ON order_items
FOR EACH ROW EXECUTE FUNCTION update_order_totals();


-- TRIGGER 6: audit_product_changes
CREATE OR REPLACE FUNCTION audit_product_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log (table_name, record_id, action, old_data, changed_at)
        VALUES ('products', OLD.id, 'DELETE', row_to_json(OLD)::jsonb, CURRENT_TIMESTAMP);
        RETURN OLD;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_log (table_name, record_id, action, old_data, new_data, changed_at)
        VALUES ('products', NEW.id, 'UPDATE', row_to_json(OLD)::jsonb, row_to_json(NEW)::jsonb, CURRENT_TIMESTAMP);
        RETURN NEW;
    ELSIF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log (table_name, record_id, action, new_data, changed_at)
        VALUES ('products', NEW.id, 'INSERT', row_to_json(NEW)::jsonb, CURRENT_TIMESTAMP);
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER audit_products AFTER INSERT OR UPDATE OR DELETE ON products
FOR EACH ROW EXECUTE FUNCTION audit_product_changes();


-- TRIGGER 7: prevent_negative_price
CREATE OR REPLACE FUNCTION prevent_negative_price()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.price <= 0 OR NEW.cost <= 0 THEN
        RAISE EXCEPTION 'El precio y el costo deben ser mayores a cero';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_product_price BEFORE INSERT OR UPDATE ON products
FOR EACH ROW EXECUTE FUNCTION prevent_negative_price();


-- TRIGGER 8: update_customer_stats_on_order
CREATE OR REPLACE FUNCTION update_customer_stats_on_order()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' AND OLD.status != NEW.status THEN
        PERFORM update_customer_statistics(NEW.customer_id);
    ELSIF TG_OP = 'INSERT' THEN
        PERFORM update_customer_statistics(NEW.customer_id);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_customer_stats AFTER INSERT OR UPDATE ON orders
FOR EACH ROW EXECUTE FUNCTION update_customer_stats_on_order();


-- TRIGGER 9: set_order_number
CREATE OR REPLACE FUNCTION set_order_number()
RETURNS TRIGGER AS $$
DECLARE
    v_year VARCHAR;
    v_sequence INTEGER;
    v_order_number VARCHAR;
BEGIN
    IF NEW.order_number IS NULL OR NEW.order_number = '' THEN
        v_year := EXTRACT(YEAR FROM CURRENT_DATE)::VARCHAR;
        
        -- Contar pedidos del año actual para la secuencia
        -- Usamos created_at (o order_date según tu esquema)
        SELECT COUNT(*) + 1 INTO v_sequence 
        FROM orders 
        WHERE EXTRACT(YEAR FROM created_at) = EXTRACT(YEAR FROM CURRENT_DATE);
        
        v_order_number := 'ORD-' || v_year || '-' || LPAD(v_sequence::VARCHAR, 4, '0');
        NEW.order_number := v_order_number;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER generate_order_number BEFORE INSERT ON orders
FOR EACH ROW EXECUTE FUNCTION set_order_number();
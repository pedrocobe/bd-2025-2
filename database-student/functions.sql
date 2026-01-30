-- =====================================================
-- FUNCIONES SQL - E-COMMERCE EXAM
-- =====================================================
-- INSTRUCCIONES:
-- 1. Crea 8 funciones usando PL/pgSQL
-- 2. Cada función debe resolver un problema específico
-- 3. Usa CREATE OR REPLACE FUNCTION
-- 4. Define parámetros de entrada y tipo de retorno
-- 5. Usa bloques DECLARE, BEGIN, END
-- 6. Maneja casos NULL con COALESCE
-- =====================================================

-- FUNCIÓN 1: calculate_order_subtotal
CREATE OR REPLACE FUNCTION calculate_order_subtotal(p_order_id INTEGER)
RETURNS DECIMAL(10,2) AS $$
DECLARE
    v_subtotal DECIMAL(10,2);
BEGIN
    SELECT COALESCE(SUM(subtotal), 0) INTO v_subtotal
    FROM order_items
    WHERE order_id = p_order_id;
    
    RETURN v_subtotal;
END;
$$ LANGUAGE plpgsql;


-- FUNCIÓN 2: apply_discount
CREATE OR REPLACE FUNCTION apply_discount(p_price DECIMAL(10,2), p_discount_percent DECIMAL(5,2))
RETURNS DECIMAL(10,2) AS $$
DECLARE
    v_final_price DECIMAL(10,2);
BEGIN
    v_final_price := p_price - (p_price * p_discount_percent / 100);
    RETURN ROUND(v_final_price, 2);
END;
$$ LANGUAGE plpgsql;


-- FUNCIÓN 3: calculate_tax
CREATE OR REPLACE FUNCTION calculate_tax(p_subtotal DECIMAL(10,2))
RETURNS DECIMAL(10,2) AS $$
BEGIN
    RETURN ROUND(p_subtotal * 0.16, 2);
END;
$$ LANGUAGE plpgsql;


-- FUNCIÓN 4: update_customer_statistics
-- NOTA: Esta función asume que las columnas total_spent y order_count existen en customers.
CREATE OR REPLACE FUNCTION update_customer_statistics(p_customer_id INTEGER)
RETURNS BOOLEAN AS $$
BEGIN
    UPDATE customers SET
        total_spent = (SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE customer_id = p_customer_id AND status != 'cancelled'),
        order_count = (SELECT COUNT(*) FROM orders WHERE customer_id = p_customer_id AND status != 'cancelled')
    WHERE id = p_customer_id;
    
    RETURN FOUND; -- Retorna true si el UPDATE afectó alguna fila
END;
$$ LANGUAGE plpgsql;


-- FUNCIÓN 5: check_product_availability
CREATE OR REPLACE FUNCTION check_product_availability(p_product_id INTEGER, p_quantity INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
    v_stock INTEGER;
BEGIN
    SELECT stock_quantity INTO v_stock FROM products WHERE id = p_product_id;
    RETURN COALESCE(v_stock, 0) >= p_quantity;
END;
$$ LANGUAGE plpgsql;


-- FUNCIÓN 6: calculate_profit_margin
CREATE OR REPLACE FUNCTION calculate_profit_margin(p_product_id INTEGER)
RETURNS DECIMAL(5,2) AS $$
DECLARE
    v_price DECIMAL(10,2);
    v_cost DECIMAL(10,2);
BEGIN
    SELECT price, cost INTO v_price, v_cost FROM products WHERE id = p_product_id;
    
    IF v_price IS NULL OR v_price = 0 THEN
        RETURN 0;
    END IF;
    
    RETURN ROUND(((v_price - v_cost) / v_price) * 100, 2);
END;
$$ LANGUAGE plpgsql;


-- FUNCIÓN 7: days_since_last_order
CREATE OR REPLACE FUNCTION days_since_last_order(p_customer_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
    v_last_order TIMESTAMP;
BEGIN
    SELECT MAX(order_date) INTO v_last_order FROM orders WHERE customer_id = p_customer_id;
    
    IF v_last_order IS NULL THEN
        RETURN NULL;
    END IF;
    
    RETURN CURRENT_DATE - v_last_order::date;
END;
$$ LANGUAGE plpgsql;


-- FUNCIÓN 8: get_inventory_value
CREATE OR REPLACE FUNCTION get_inventory_value()
RETURNS DECIMAL(12,2) AS $$
DECLARE
    v_total_value DECIMAL(12,2);
BEGIN
    SELECT SUM(stock_quantity * cost) INTO v_total_value 
    FROM products 
    WHERE is_active = true;
    
    RETURN COALESCE(v_total_value, 0);
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- VERIFICACIÓN (opcional)
-- =====================================================
-- Después de crear tus funciones, puedes probarlas con:
-- SELECT calculate_order_subtotal(1);
-- SELECT apply_discount(100, 10);
-- SELECT calculate_tax(1000);
-- etc.

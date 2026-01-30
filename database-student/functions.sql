
CREATE OR REPLACE FUNCTION calculate_order_subtotal(p_order_id INTEGER)
RETURNS DECIMAL(10,2) AS $$
DECLARE
    v_total DECIMAL(10,2);
BEGIN
    SELECT COALESCE(SUM(subtotal), 0)
    INTO v_total
    FROM order_items
    WHERE order_id = p_order_id;
    
    RETURN v_total;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION apply_discount(p_price DECIMAL(10,2), p_discount_percent DECIMAL(5,2))
RETURNS DECIMAL(10,2) AS $$
BEGIN
    RETURN ROUND(p_price - (p_price * p_discount_percent / 100), 2);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION calculate_tax(p_subtotal DECIMAL(10,2))
RETURNS DECIMAL(10,2) AS $$
BEGIN
    RETURN ROUND(p_subtotal * 0.16, 2);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_customer_statistics(p_customer_id INTEGER)
RETURNS BOOLEAN AS $$
BEGIN
    UPDATE customers
    SET 
        total_spent = (
            SELECT COALESCE(SUM(total), 0) 
            FROM orders 
            WHERE customer_id = p_customer_id AND status != 'cancelled'
        ),
        order_count = (
            SELECT COUNT(*) 
            FROM orders 
            WHERE customer_id = p_customer_id AND status != 'cancelled'
        )
    WHERE id = p_customer_id;
    
    RETURN found; -- Retorna true si se actualizó una fila
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION check_product_availability(p_product_id INTEGER, p_quantity INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
    v_stock INTEGER;
BEGIN
    SELECT stock_quantity INTO v_stock
    FROM products
    WHERE id = p_product_id;
    
    IF v_stock IS NULL THEN
        RETURN FALSE;
    END IF;
    
    RETURN v_stock >= p_quantity;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION calculate_profit_margin(p_product_id INTEGER)
RETURNS DECIMAL(5,2) AS $$
DECLARE
    v_price DECIMAL(10,2);
    v_cost DECIMAL(10,2);
BEGIN
    SELECT price, cost INTO v_price, v_cost
    FROM products
    WHERE id = p_product_id;
    
    IF v_price IS NULL OR v_price = 0 THEN
        RETURN 0;
    END IF;
    
    RETURN ROUND(((v_price - v_cost) / v_price) * 100, 2);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION days_since_last_order(p_customer_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
    v_last_order DATE;
BEGIN
    SELECT MAX(created_at)::DATE INTO v_last_order
    FROM orders
    WHERE customer_id = p_customer_id;
    
    IF v_last_order IS NULL THEN
        RETURN NULL;
    END IF;
    
    RETURN CURRENT_DATE - v_last_order;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_inventory_value()
RETURNS DECIMAL(12,2) AS $$
DECLARE
    v_total_value DECIMAL(12,2);
BEGIN
    SELECT COALESCE(SUM(stock_quantity * cost), 0) INTO v_total_value
    FROM products
    WHERE is_active = true;
    
    RETURN v_total_value;
END;
$$ LANGUAGE plpgsql;

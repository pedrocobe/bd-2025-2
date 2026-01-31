-- =====================================================
-- FUNCIONES SQL - E-COMMERCE EXAM
-- =====================================================

-- FUNCIÓN 1: calculate_order_subtotal
CREATE OR REPLACE FUNCTION calculate_order_subtotal(p_order_id INTEGER)
RETURNS DECIMAL(10,2) AS $$
DECLARE
    v_subtotal DECIMAL(10,2);
BEGIN
    SELECT COALESCE(SUM(subtotal), 0)
    INTO v_subtotal
    FROM order_items
    WHERE order_id = p_order_id;
    
    RETURN v_subtotal;
END;
$$ LANGUAGE plpgsql;

-- FUNCIÓN 2: apply_discount
CREATE OR REPLACE FUNCTION apply_discount(p_price DECIMAL(10,2), p_discount_percent DECIMAL(5,2))
RETURNS DECIMAL(10,2) AS $$
DECLARE
    v_discounted_price DECIMAL(10,2);
BEGIN
    v_discounted_price := p_price - (p_price * p_discount_percent / 100);
    RETURN ROUND(v_discounted_price, 2);
END;
$$ LANGUAGE plpgsql;

-- FUNCIÓN 3: calculate_tax
CREATE OR REPLACE FUNCTION calculate_tax(p_subtotal DECIMAL(10,2))
RETURNS DECIMAL(10,2) AS $$
DECLARE
    v_tax DECIMAL(10,2);
BEGIN
    v_tax := p_subtotal * 0.16;
    RETURN ROUND(v_tax, 2);
END;
$$ LANGUAGE plpgsql;

-- FUNCIÓN 4: update_customer_statistics
CREATE OR REPLACE FUNCTION update_customer_statistics(p_customer_id INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
    v_total_spent DECIMAL(12,2);
    v_order_count INTEGER;
BEGIN
    -- Calcular total gastado (solo pedidos no cancelados)
    SELECT COALESCE(SUM(total), 0)
    INTO v_total_spent
    FROM orders
    WHERE customer_id = p_customer_id AND status != 'cancelled';
    
    -- Contar pedidos (solo no cancelados)
    SELECT COUNT(*)
    INTO v_order_count
    FROM orders
    WHERE customer_id = p_customer_id AND status != 'cancelled';
    
    -- Actualizar estadísticas del cliente
    UPDATE customers
    SET total_spent = v_total_spent,
        order_count = v_order_count
    WHERE id = p_customer_id;
    
    RETURN true;
END;
$$ LANGUAGE plpgsql;

-- FUNCIÓN 5: check_product_availability
CREATE OR REPLACE FUNCTION check_product_availability(p_product_id INTEGER, p_quantity INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
    v_available_stock INTEGER;
BEGIN
    SELECT stock_quantity
    INTO v_available_stock
    FROM products
    WHERE id = p_product_id;
    
    -- Si el producto no existe, retornar false
    IF v_available_stock IS NULL THEN
        RETURN false;
    END IF;
    
    -- Verificar si hay stock suficiente
    RETURN v_available_stock >= p_quantity;
END;
$$ LANGUAGE plpgsql;

-- FUNCIÓN 6: calculate_profit_margin
CREATE OR REPLACE FUNCTION calculate_profit_margin(p_product_id INTEGER)
RETURNS DECIMAL(5,2) AS $$
DECLARE
    v_price DECIMAL(10,2);
    v_cost DECIMAL(10,2);
    v_margin DECIMAL(5,2);
BEGIN
    SELECT price, cost
    INTO v_price, v_cost
    FROM products
    WHERE id = p_product_id;
    
    -- Si el producto no existe o el precio es 0, retornar 0
    IF v_price IS NULL OR v_price = 0 THEN
        RETURN 0;
    END IF;
    
    -- Calcular margen: ((precio - costo) / precio) * 100
    v_margin := ((v_price - v_cost) / v_price) * 100;
    
    RETURN ROUND(v_margin, 2);
END;
$$ LANGUAGE plpgsql;

-- FUNCIÓN 7: days_since_last_order
CREATE OR REPLACE FUNCTION days_since_last_order(p_customer_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
    v_last_order_date DATE;
    v_days INTEGER;
BEGIN
    SELECT MAX(created_at)::DATE
    INTO v_last_order_date
    FROM orders
    WHERE customer_id = p_customer_id;
    
    -- Si el cliente nunca ha comprado, retornar NULL
    IF v_last_order_date IS NULL THEN
        RETURN NULL;
    END IF;
    
    -- Calcular días transcurridos
    v_days := CURRENT_DATE - v_last_order_date;
    
    RETURN v_days;
END;
$$ LANGUAGE plpgsql;

-- FUNCIÓN 8: get_inventory_value
CREATE OR REPLACE FUNCTION get_inventory_value()
RETURNS DECIMAL(12,2) AS $$
DECLARE
    v_total_value DECIMAL(12,2);
BEGIN
    SELECT COALESCE(SUM(stock_quantity * cost), 0)
    INTO v_total_value
    FROM products
    WHERE is_active = true;
    
    RETURN v_total_value;
END;
$$ LANGUAGE plpgsql;

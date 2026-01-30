-- =====================================================
-- FUNCIONES SQL - E-COMMERCE EXAM
-- =====================================================

-- FUNCIÓN 1: calculate_order_subtotal
CREATE OR REPLACE FUNCTION calculate_order_subtotal(p_order_id INTEGER)
RETURNS DECIMAL(10,2) AS $$
DECLARE
    v_subtotal DECIMAL(10,2);
BEGIN
    -- Suma los subtotales de los items del pedido
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
BEGIN
    -- Calcula el precio con descuento
    RETURN ROUND(p_price - (p_price * p_discount_percent / 100.0), 2);
END;
$$ LANGUAGE plpgsql;


-- FUNCIÓN 3: calculate_tax
CREATE OR REPLACE FUNCTION calculate_tax(p_subtotal DECIMAL(10,2))
RETURNS DECIMAL(10,2) AS $$
BEGIN
    -- Calcula el 16% de impuesto
    RETURN ROUND(p_subtotal * 0.16, 2);
END;
$$ LANGUAGE plpgsql;


-- FUNCIÓN 4: update_customer_statistics
CREATE OR REPLACE FUNCTION update_customer_statistics(p_customer_id INTEGER)
RETURNS BOOLEAN AS $$
BEGIN
    -- Actualiza total gastado y cantidad de pedidos válidos
    UPDATE customers
    SET 
        total_spent = COALESCE((
            SELECT SUM(total) 
            FROM orders 
            WHERE customer_id = p_customer_id AND status != 'cancelled'
        ), 0),
        order_count = (
            SELECT COUNT(*) 
            FROM orders 
            WHERE customer_id = p_customer_id AND status != 'cancelled'
        ),
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_customer_id;
    
    -- Retorna true si se ejecutó (aunque no haya cambiado valores)
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;


-- FUNCIÓN 5: check_product_availability
CREATE OR REPLACE FUNCTION check_product_availability(p_product_id INTEGER, p_quantity INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
    v_stock INTEGER;
BEGIN
    -- Obtiene el stock actual
    SELECT stock_quantity INTO v_stock
    FROM products
    WHERE id = p_product_id;
    
    -- Si no existe el producto, retorna falso
    IF v_stock IS NULL THEN
        RETURN FALSE;
    END IF;
    
    -- Retorna true si hay suficiente stock
    RETURN v_stock >= p_quantity;
END;
$$ LANGUAGE plpgsql;


-- FUNCIÓN 6: calculate_profit_margin
CREATE OR REPLACE FUNCTION calculate_profit_margin(p_product_id INTEGER)
RETURNS DECIMAL(5,2) AS $$
DECLARE
    v_price DECIMAL(10,2);
    v_cost DECIMAL(10,2);
BEGIN
    -- Obtiene precio y costo
    SELECT price, cost INTO v_price, v_cost
    FROM products
    WHERE id = p_product_id;
    
    -- Evita división por cero
    IF v_price IS NULL OR v_price = 0 THEN
        RETURN 0.00;
    END IF;
    
    -- Fórmula: ((Precio - Costo) / Precio) * 100
    RETURN ROUND(((v_price - v_cost) / v_price) * 100, 2);
END;
$$ LANGUAGE plpgsql;


-- FUNCIÓN 7: days_since_last_order
CREATE OR REPLACE FUNCTION days_since_last_order(p_customer_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
    v_last_order_date TIMESTAMP;
BEGIN
    -- Obtiene la fecha del último pedido
    SELECT MAX(created_at) INTO v_last_order_date
    FROM orders
    WHERE customer_id = p_customer_id;
    
    -- Si nunca ha comprado, retorna NULL
    IF v_last_order_date IS NULL THEN
        RETURN NULL;
    END IF;
    
    -- Calcula diferencia en días
    RETURN DATE_PART('day', CURRENT_TIMESTAMP - v_last_order_date)::INTEGER;
END;
$$ LANGUAGE plpgsql;


-- FUNCIÓN 8: get_inventory_value
CREATE OR REPLACE FUNCTION get_inventory_value()
RETURNS DECIMAL(12,2) AS $$
DECLARE
    v_total_value DECIMAL(12,2);
BEGIN
    -- Suma (stock * costo) de productos activos
    SELECT COALESCE(SUM(stock_quantity * cost), 0)
    INTO v_total_value
    FROM products
    WHERE is_active = true;
    
    RETURN v_total_value;
END;
$$ LANGUAGE plpgsql;
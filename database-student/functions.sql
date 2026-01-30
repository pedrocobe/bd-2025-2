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


-- FUNCIÓN 1: Calcula el subtotal de un pedido (calculate_order_subtotal)
CREATE OR REPLACE FUNCTION calculate_order_subtotal(p_order_id INTEGER)
RETURNS DECIMAL(12,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_subtotal DECIMAL(12,2);
BEGIN
    SELECT COALESCE(SUM(subtotal), 0.00)
    INTO v_subtotal
    FROM order_items
    WHERE order_id = p_order_id;
    RETURN v_subtotal;
END;
$$;

-- FUNCIÓN 2: Aplica descuento a un precio (apply_discount)
CREATE OR REPLACE FUNCTION apply_discount(p_price DECIMAL(10,2), p_discount_percent DECIMAL(5,2))
RETURNS DECIMAL(10,2)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN ROUND(p_price - (p_price * p_discount_percent / 100), 2);
END;
$$;

-- FUNCIÓN 3: Calcula impuesto del 16% (calculate_tax)
CREATE OR REPLACE FUNCTION calculate_tax(p_subtotal DECIMAL(10,2))
RETURNS DECIMAL(10,2)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN ROUND(p_subtotal * 0.16, 2);
END;
$$;

-- FUNCIÓN 4: Actualiza estadísticas del cliente (update_customer_statistics)
CREATE OR REPLACE FUNCTION update_customer_statistics(p_customer_id INTEGER)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE customers
    SET
        total_spent = COALESCE((
            SELECT SUM(total)
            FROM orders
            WHERE customer_id = p_customer_id AND status != 'cancelled'), 0.00),
        order_count = (
            SELECT COUNT(*)
            FROM orders
            WHERE customer_id = p_customer_id AND status != 'cancelled'
        )
    WHERE id = p_customer_id;
    RETURN TRUE;
END;
$$;

-- FUNCIÓN 5: Verifica stock disponible (check_product_availability)
CREATE OR REPLACE FUNCTION check_product_availability(p_product_id INTEGER, p_quantity INTEGER)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock INTEGER;
BEGIN
    SELECT stock_quantity
    INTO v_stock
    FROM products
    WHERE id = p_product_id;
    IF v_stock IS NULL THEN
        RETURN FALSE;
    END IF;
    RETURN v_stock >= p_quantity;
END;
$$;

-- FUNCIÓN 6: Calcula margen de ganancia (calculate_profit_margin)
CREATE OR REPLACE FUNCTION calculate_profit_margin(p_product_id INTEGER)
RETURNS DECIMAL(5,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_price DECIMAL(10,2);
    v_cost  DECIMAL(10,2);
BEGIN
    SELECT price, cost
    INTO v_price, v_cost
    FROM products
    WHERE id = p_product_id;
    IF v_price IS NULL OR v_price = 0 THEN
        RETURN 0.00;
    END IF;
    RETURN ROUND(
        ((v_price - v_cost) / v_price) * 100, 2);
END;
$$;

-- FUNCIÓN 7: Días desde la última compra (days_since_last_order)
CREATE OR REPLACE FUNCTION days_since_last_order(p_customer_id INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql AS $$
DECLARE
    v_last_order DATE;
BEGIN
    SELECT MAX(created_at::date)
    INTO v_last_order
    FROM orders
    WHERE customer_id = p_customer_id;
    IF v_last_order IS NULL THEN
        RETURN NULL;
    END IF;
    RETURN CURRENT_DATE - v_last_order;
END;
$$;

-- FUNCIÓN 8: Valor total del inventario (get_inventory_value)
CREATE OR REPLACE FUNCTION get_inventory_value()
RETURNS DECIMAL(12,2)
LANGUAGE plpgsql AS $$
DECLARE
    v_total DECIMAL(12,2);
BEGIN
    SELECT COALESCE(SUM(stock_quantity * cost), 0.00)
    INTO v_total
    FROM products
    WHERE is_active = TRUE;
    RETURN v_total;
END;
$$;

-- =====================================================
-- VERIFICACIÓN (opcional)
-- =====================================================
-- Después de crear tus funciones, puedes probarlas con:
-- SELECT calculate_order_subtotal(1);
-- SELECT apply_discount(100, 10);
-- SELECT calculate_tax(1000);
-- etc.
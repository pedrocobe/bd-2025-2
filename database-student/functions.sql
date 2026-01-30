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
CREATE OR REPLACE FUNCTION calculate_order_subtotal(p_order_id INTEGER)
RETURNS DECIMAL(10,2)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN (
		SELECT COALESCE(ROUND(SUM(subtotal)::NUMERIC,2),0)
		FROM order_items
		WHERE order_id = p_order_id
	);
END;
$$;

CREATE OR REPLACE FUNCTION apply_discount(p_price DECIMAL(10,2), p_discount_percent DECIMAL(5,2))
RETURNS DECIMAL(10,2)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN (ROUND((COALESCE(p_price,0) * (100 - COALESCE(p_discount_percent,0)) / 100.0), 2));
END;
$$;

CREATE OR REPLACE FUNCTION calculate_tax(p_subtotal DECIMAL(10,2))
RETURNS DECIMAL(10,2)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN (SELECT ROUND(COALESCE(p_subtotal,0) * 0.16, 2));
END;
$$;

CREATE OR REPLACE FUNCTION update_customer_statistics(p_customer_id INTEGER)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE customers
	SET
		total_spent = COALESCE((SELECT SUM(o.total) FROM orders o WHERE o.customer_id = p_customer_id AND o.status <> 'cancelled'),0),
		order_count = COALESCE((SELECT COUNT(*) FROM orders o WHERE o.customer_id = p_customer_id AND o.status <> 'cancelled'),0)
	WHERE id = p_customer_id;

	RETURN (FOUND);
EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;
END;
$$;

CREATE OR REPLACE FUNCTION check_product_availability(p_product_id INTEGER, p_quantity INTEGER)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN (
		SELECT COALESCE(stock_quantity,0) >= COALESCE(p_quantity,0)
		FROM products WHERE id = p_product_id
	);
END;
$$;

CREATE OR REPLACE FUNCTION calculate_profit_margin(p_product_id INTEGER)
RETURNS DECIMAL(5,2)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN (
		SELECT CASE WHEN COALESCE(price,0)=0 THEN 0 ELSE ROUND(((price - COALESCE(cost,0)) / price) * 100, 2) END
		FROM products WHERE id = p_product_id
	);
END;
$$;

CREATE OR REPLACE FUNCTION days_since_last_order(p_customer_id INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN (
		SELECT CASE WHEN MAX(created_at) IS NULL THEN NULL ELSE (CURRENT_DATE - MAX(created_at)::date) END
		FROM orders WHERE customer_id = p_customer_id
	);
END;
$$;

CREATE OR REPLACE FUNCTION get_inventory_value()
RETURNS DECIMAL(12,2)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN (
		SELECT ROUND(COALESCE(SUM(stock_quantity * cost),0),2) FROM products WHERE is_active = TRUE
	);
END;
$$;

CREATE OR REPLACE FUNCTION calculate_profit_margin(p_product_id INTEGER)
RETURNS DECIMAL(5,2)
LANGUAGE plpgsql
AS $$
DECLARE
	v_price DECIMAL(10,2);
	v_cost  DECIMAL(10,2);
	v_margin DECIMAL(10,4);
BEGIN
	SELECT p.price, p.cost
	INTO v_price, v_cost
	FROM products p
	WHERE p.id = p_product_id;

	IF v_price IS NULL OR v_price = 0 THEN
		RETURN 0;
	END IF;

	v_margin := ((COALESCE(v_price, 0) - COALESCE(v_cost, 0)) / v_price) * 100;
	RETURN ROUND(v_margin, 2);
END;
$$;



-- FUNCIÓN 7: days_since_last_order
-- Descripción: Calcula cuántos días han pasado desde el último pedido de un cliente
-- Parámetros:
--   p_customer_id INTEGER - ID del cliente
-- Retorna: INTEGER - Número de días (NULL si nunca ha comprado)
--
-- Lógica:
-- - SELECT MAX(created_at) FROM orders WHERE customer_id = p_customer_id
-- - Calcula: CURRENT_DATE - fecha_ultimo_pedido
-- - Si no hay pedidos, retorna NULL
--
-- TODO: Escribe la función aquí

CREATE OR REPLACE FUNCTION days_since_last_order(p_customer_id INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
	v_last_order_at TIMESTAMP;
BEGIN
	SELECT MAX(o.created_at)
	INTO v_last_order_at
	FROM orders o
	WHERE o.customer_id = p_customer_id;

	IF v_last_order_at IS NULL THEN
		RETURN NULL;
	END IF;

	RETURN (CURRENT_DATE - v_last_order_at::date);
END;
$$;



-- FUNCIÓN 8: get_inventory_value
-- Descripción: Calcula el valor total del inventario (stock_quantity * cost de todos los productos)
-- Parámetros: ninguno
-- Retorna: DECIMAL(12,2) - Valor total del inventario
--
-- Lógica:
-- - SELECT SUM(stock_quantity * cost) FROM products WHERE is_active = true
-- - Usa COALESCE para retornar 0 si no hay productos
--
-- TODO: Escribe la función aquí

CREATE OR REPLACE FUNCTION get_inventory_value()
RETURNS DECIMAL(12,2)
LANGUAGE plpgsql
AS $$
DECLARE
	v_value DECIMAL(12,2);
BEGIN
	SELECT COALESCE(SUM(p.stock_quantity * p.cost), 0)::DECIMAL(12,2)
	INTO v_value
	FROM products p
	WHERE p.is_active = TRUE;

	RETURN ROUND(COALESCE(v_value, 0), 2);
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

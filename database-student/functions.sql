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
-- Descripción: Calcula el subtotal de un pedido sumando los subtotales de todos sus items
-- Parámetros:
--   p_order_id INTEGER - ID del pedido
-- Retorna: DECIMAL(10,2) - Subtotal del pedido
-- 
-- Lógica:
-- - Suma todos los subtotales de order_items donde order_id = p_order_id
-- - Si no hay items, retorna 0
-- - Usa COALESCE para manejar NULLs
--
-- TODO: Escribe la función aquí

CREATE OR REPLACE FUNCTION calculate_order_subtotal(p_order_id INTEGER)
RETURNS DECIMAL(10,2)
LANGUAGE plpgsql
AS $$
DECLARE
	v_subtotal DECIMAL(10,2);
BEGIN
	SELECT COALESCE(SUM(oi.subtotal), 0)::DECIMAL(10,2)
	INTO v_subtotal
	FROM order_items oi
	WHERE oi.order_id = p_order_id;

	RETURN ROUND(COALESCE(v_subtotal, 0), 2);
END;
$$;



-- FUNCIÓN 2: apply_discount
-- Descripción: Aplica un porcentaje de descuento a un precio
-- Parámetros:
--   p_price DECIMAL(10,2) - Precio original
--   p_discount_percent DECIMAL(5,2) - Porcentaje de descuento (ej: 10 para 10%)
-- Retorna: DECIMAL(10,2) - Precio con descuento aplicado
--
-- Lógica:
-- - Calcula: p_price - (p_price * p_discount_percent / 100)
-- - Redondea a 2 decimales
--
-- TODO: Escribe la función aquí

CREATE OR REPLACE FUNCTION apply_discount(
	p_price DECIMAL(10,2),
	p_discount_percent DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
LANGUAGE plpgsql
AS $$
DECLARE
	v_price DECIMAL(10,2);
	v_discount DECIMAL(5,2);
BEGIN
	v_price := COALESCE(p_price, 0);
	v_discount := COALESCE(p_discount_percent, 0);

	RETURN ROUND(v_price - (v_price * v_discount / 100), 2);
END;
$$;



-- FUNCIÓN 3: calculate_tax
-- Descripción: Calcula el impuesto (16%) sobre un monto
-- Parámetros:
--   p_subtotal DECIMAL(10,2) - Subtotal sobre el cual calcular impuesto
-- Retorna: DECIMAL(10,2) - Monto del impuesto
--
-- Lógica:
-- - Multiplica p_subtotal por 0.16
-- - Redondea a 2 decimales
--
-- TODO: Escribe la función aquí

CREATE OR REPLACE FUNCTION calculate_tax(p_subtotal DECIMAL(10,2))
RETURNS DECIMAL(10,2)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN ROUND(COALESCE(p_subtotal, 0) * 0.16, 2);
END;
$$;



-- FUNCIÓN 4: update_customer_statistics
-- Descripción: Actualiza las estadísticas de un cliente (total_spent, order_count)
-- Parámetros:
--   p_customer_id INTEGER - ID del cliente
-- Retorna: BOOLEAN - true si se actualizó, false si no
--
-- Lógica:
-- - UPDATE customers SET:
--   * total_spent = suma de orders.total donde customer_id = p_customer_id y status != 'cancelled'
--   * order_count = cantidad de orders donde customer_id = p_customer_id y status != 'cancelled'
-- - Usa subconsultas
-- - Retorna true si se ejecutó correctamente
--
-- TODO: Escribe la función aquí

CREATE OR REPLACE FUNCTION update_customer_statistics(p_customer_id INTEGER)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
	v_rows_updated INTEGER;
BEGIN
	UPDATE customers c
	SET
		total_spent = COALESCE(
			(SELECT SUM(o.total) FROM orders o WHERE o.customer_id = p_customer_id AND o.status <> 'cancelled'),
			0
		),
		order_count = COALESCE(
			(SELECT COUNT(*) FROM orders o WHERE o.customer_id = p_customer_id AND o.status <> 'cancelled'),
			0
		)
	WHERE c.id = p_customer_id;

	GET DIAGNOSTICS v_rows_updated = ROW_COUNT;
	RETURN v_rows_updated > 0;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$;



-- FUNCIÓN 5: check_product_availability
-- Descripción: Verifica si hay stock suficiente de un producto
-- Parámetros:
--   p_product_id INTEGER - ID del producto
--   p_quantity INTEGER - Cantidad solicitada
-- Retorna: BOOLEAN - true si hay stock suficiente, false si no
--
-- Lógica:
-- - SELECT stock_quantity FROM products WHERE id = p_product_id
-- - Compara si stock_quantity >= p_quantity
-- - Retorna el resultado de la comparación
--
-- TODO: Escribe la función aquí

CREATE OR REPLACE FUNCTION check_product_availability(p_product_id INTEGER, p_quantity INTEGER)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
	v_stock INTEGER;
BEGIN
	SELECT p.stock_quantity
	INTO v_stock
	FROM products p
	WHERE p.id = p_product_id;

	RETURN COALESCE(v_stock, 0) >= COALESCE(p_quantity, 0);
END;
$$;



-- FUNCIÓN 6: calculate_profit_margin
-- Descripción: Calcula el margen de ganancia de un producto en porcentaje
-- Parámetros:
--   p_product_id INTEGER - ID del producto
-- Retorna: DECIMAL(5,2) - Porcentaje de margen (ej: 25.50 para 25.5%)
--
-- Lógica:
-- - SELECT price, cost FROM products WHERE id = p_product_id
-- - Si price = 0 o NULL, retorna 0
-- - Calcula: ((price - cost) / price) * 100
-- - Redondea a 2 decimales con ROUND()
--
-- TODO: Escribe la función aquí

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

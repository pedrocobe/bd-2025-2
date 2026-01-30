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
	s NUMERIC := 0;
BEGIN
	SELECT COALESCE(SUM(subtotal),0) INTO s FROM order_items WHERE order_id = p_order_id;
	RETURN ROUND(s::DECIMAL(10,2),2);
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
BEGIN
	RETURN ROUND(COALESCE(p_price,0) - (COALESCE(p_price,0) * COALESCE(p_discount_percent,0) / 100.0), 2);
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
	RETURN ROUND((COALESCE(p_subtotal,0) * 16) / 100.0, 2);
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
	tot NUMERIC;
	cnt INTEGER;
BEGIN
	SELECT COALESCE(SUM(total),0), COALESCE(COUNT(*),0) INTO tot, cnt FROM orders WHERE customer_id = p_customer_id AND status <> 'cancelled';
	UPDATE customers SET total_spent = tot, order_count = cnt WHERE id = p_customer_id;
	RETURN FOUND;
EXCEPTION WHEN OTHERS THEN
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
BEGIN
	RETURN EXISTS(
		SELECT 1 FROM products WHERE id = p_product_id AND COALESCE(stock_quantity,0) >= COALESCE(p_quantity,0)
	);
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
	pr NUMERIC;
	ct NUMERIC;
BEGIN
	SELECT price, cost INTO pr, ct FROM products WHERE id = p_product_id;
	pr := COALESCE(pr,0);
	ct := COALESCE(ct,0);
	IF pr = 0 THEN
		RETURN 0;
	END IF;
	RETURN ROUND(((pr - ct) / pr) * 100, 2);
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
	last_ts TIMESTAMP;
BEGIN
	SELECT MAX(created_at) INTO last_ts FROM orders WHERE customer_id = p_customer_id;
	IF last_ts IS NULL THEN
		RETURN NULL;
	END IF;
	RETURN (CURRENT_DATE - last_ts::date);
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
	v NUMERIC;
BEGIN
	SELECT SUM(stock_quantity * cost) INTO v FROM products WHERE is_active = TRUE;
	RETURN ROUND(COALESCE(v,0),2);
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

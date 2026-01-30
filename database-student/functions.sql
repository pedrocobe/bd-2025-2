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
RETURNS DECIMAL(10,2) AS $$
DECLARE
    v_subtotal DECIMAL(10,2);
BEGIN
    SELECT COALESCE(SUM(total_price), 0)
    INTO v_subtotal
    FROM order_items
    WHERE order_id = p_order_id;
    
    RETURN v_subtotal;
END;
$$ LANGUAGE plpgsql;

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
RETURNS DECIMAL(10,2) AS $$
DECLARE
    v_discounted_price DECIMAL(10,2);
BEGIN
    v_discounted_price := p_price - (p_price * p_discount_percent / 100);
    
    -- Asegurar que no sea negativo
    IF v_discounted_price < 0 THEN
        v_discounted_price := 0;
    END IF;
    
    RETURN ROUND(v_discounted_price, 2);
END;
$$ LANGUAGE plpgsql;

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
RETURNS DECIMAL(10,2) AS $$
DECLARE
    v_tax_amount DECIMAL(10,2);
BEGIN
    v_tax_amount := p_subtotal * 0.16;
    RETURN ROUND(v_tax_amount, 2);
END;
$$ LANGUAGE plpgsql;

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
RETURNS BOOLEAN AS $$
DECLARE
    v_rows_affected INTEGER;
BEGIN
    UPDATE customers
    SET 
        total_spent = (
            SELECT COALESCE(SUM(total_amount), 0)
            FROM orders 
            WHERE customer_id = p_customer_id 
              AND status != 'cancelled'
        ),
        order_count = (
            SELECT COUNT(*)
            FROM orders 
            WHERE customer_id = p_customer_id 
              AND status != 'cancelled'
        ),
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_customer_id;
    
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    
    RETURN v_rows_affected > 0;
END;
$$ LANGUAGE plpgsql;

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
CREATE OR REPLACE FUNCTION check_product_availability(
    p_product_id INTEGER,
    p_quantity INTEGER
)
RETURNS BOOLEAN AS $$
DECLARE
    v_stock_quantity INTEGER;
BEGIN
    -- Obtener stock actual
    SELECT stock_quantity
    INTO v_stock_quantity
    FROM products
    WHERE id = p_product_id;
    
    -- Si el producto no existe
    IF v_stock_quantity IS NULL THEN
        RETURN FALSE;
    END IF;
    
    -- Verificar si hay suficiente stock
    RETURN v_stock_quantity >= p_quantity;
END;
$$ LANGUAGE plpgsql;

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
RETURNS DECIMAL(5,2) AS $$
DECLARE
    v_price DECIMAL(10,2);
    v_cost DECIMAL(10,2);
    v_margin DECIMAL(5,2);
BEGIN
    -- Obtener precio y costo
    SELECT price, cost
    INTO v_price, v_cost
    FROM products
    WHERE id = p_product_id;
    
    -- Verificar si el producto existe y tiene precio válido
    IF v_price IS NULL OR v_price <= 0 THEN
        RETURN 0;
    END IF;
    
    -- Si no hay costo, asumir costo = 0
    IF v_cost IS NULL THEN
        v_cost := 0;
    END IF;
    
    -- Calcular margen
    v_margin := ((v_price - v_cost) / v_price) * 100;
    
    RETURN ROUND(v_margin, 2);
END;
$$ LANGUAGE plpgsql;

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
RETURNS INTEGER AS $$
DECLARE
    v_last_order_date TIMESTAMP;
    v_days_passed INTEGER;
BEGIN
    -- Obtener fecha del último pedido
    SELECT MAX(order_date)
    INTO v_last_order_date
    FROM orders
    WHERE customer_id = p_customer_id
      AND status != 'cancelled';
    
    -- Si no hay pedidos, retornar NULL
    IF v_last_order_date IS NULL THEN
        RETURN NULL;
    END IF;
    
    -- Calcular días transcurridos
    v_days_passed := EXTRACT(DAY FROM (CURRENT_DATE - v_last_order_date::date));
    
    RETURN v_days_passed;
END;
$$ LANGUAGE plpgsql;

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
RETURNS DECIMAL(12,2) AS $$
DECLARE
    v_total_value DECIMAL(12,2);
BEGIN
    SELECT COALESCE(SUM(stock_quantity * cost), 0)
    INTO v_total_value
    FROM products
    WHERE is_active = TRUE;
    
    RETURN v_total_value;
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

DO $$
BEGIN
    RAISE NOTICE '✅ 8 funciones creadas correctamente:';
    RAISE NOTICE '   1. calculate_order_subtotal(order_id)';
    RAISE NOTICE '   2. apply_discount(price, discount_percent)';
    RAISE NOTICE '   3. calculate_tax(subtotal)';
    RAISE NOTICE '   4. update_customer_statistics(customer_id)';
    RAISE NOTICE '   5. check_product_availability(product_id, quantity)';
    RAISE NOTICE '   6. calculate_profit_margin(product_id)';
    RAISE NOTICE '   7. days_since_last_order(customer_id)';
    RAISE NOTICE '   8. get_inventory_value()';
END $$;
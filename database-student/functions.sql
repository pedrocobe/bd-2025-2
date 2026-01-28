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



-- =====================================================
-- VERIFICACIÓN (opcional)
-- =====================================================
-- Después de crear tus funciones, puedes probarlas con:
-- SELECT calculate_order_subtotal(1);
-- SELECT apply_discount(100, 10);
-- SELECT calculate_tax(1000);
-- etc.

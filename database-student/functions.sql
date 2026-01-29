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
CREATE OR REPLACE FUNCTION calculate_order_subtotal(p_order_id INTEGER)
RETURNS DECIMAL(12,2) AS $$
DECLARE
  v_subtotal DECIMAL(12,2);
BEGIN
  SELECT COALESCE(SUM(subtotal), 0.00)
  INTO v_subtotal
  FROM order_items
  WHERE order_id = p_order_id;
  
  RETURN v_subtotal;
END;
$$ LANGUAGE plpgsql;

-- FUNCIÓN 2: apply_discount
-- Descripción: Aplica un porcentaje de descuento a un precio
CREATE OR REPLACE FUNCTION apply_discount(p_price DECIMAL(10,2), p_discount_percent DECIMAL(5,2))
RETURNS DECIMAL(10,2) AS $$
BEGIN
  RETURN ROUND(p_price - (p_price * p_discount_percent / 100), 2);
END;
$$ LANGUAGE plpgsql;

-- FUNCIÓN 3: calculate_tax
-- Descripción: Calcula el impuesto (16%) sobre un monto
CREATE OR REPLACE FUNCTION calculate_tax(p_subtotal DECIMAL(10,2))
RETURNS DECIMAL(10,2) AS $$
BEGIN
  RETURN ROUND(p_subtotal * 0.16, 2);
END;
$$ LANGUAGE plpgsql;

-- FUNCIÓN 4: update_customer_statistics
-- Descripción: Actualiza las estadísticas de un cliente (total_spent, order_count)
CREATE OR REPLACE FUNCTION update_customer_statistics(p_customer_id INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
  v_total_spent DECIMAL(12,2);
  v_order_count INTEGER;
BEGIN
  -- Calcular total_spent y order_count excluindo pedidos cancelados
  SELECT COALESCE(SUM(total), 0.00), COALESCE(COUNT(*), 0)
  INTO v_total_spent, v_order_count
  FROM orders
  WHERE customer_id = p_customer_id AND status != 'cancelled';
  
  -- Actualizar el cliente
  UPDATE customers
  SET total_spent = v_total_spent, order_count = v_order_count
  WHERE id = p_customer_id;
  
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- FUNCIÓN 5: check_product_availability
-- Descripción: Verifica si hay stock suficiente de un producto
CREATE OR REPLACE FUNCTION check_product_availability(p_product_id INTEGER, p_quantity INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
  v_available_stock INTEGER;
BEGIN
  SELECT stock_quantity
  INTO v_available_stock
  FROM products
  WHERE id = p_product_id;
  
  IF v_available_stock IS NULL THEN
    RETURN FALSE;
  END IF;
  
  RETURN v_available_stock >= p_quantity;
END;
$$ LANGUAGE plpgsql;

-- FUNCIÓN 6: calculate_profit_margin
-- Descripción: Calcula el margen de ganancia de un producto en porcentaje
CREATE OR REPLACE FUNCTION calculate_profit_margin(p_product_id INTEGER)
RETURNS DECIMAL(5,2) AS $$
DECLARE
  v_price DECIMAL(10,2);
  v_cost DECIMAL(10,2);
BEGIN
  SELECT price, cost
  INTO v_price, v_cost
  FROM products
  WHERE id = p_product_id;
  
  IF v_price IS NULL OR v_price = 0 THEN
    RETURN 0.00;
  END IF;
  
  RETURN ROUND(((v_price - v_cost) / v_price) * 100, 2);
END;
$$ LANGUAGE plpgsql;

-- FUNCIÓN 7: days_since_last_order
-- Descripción: Calcula cuántos días han pasado desde el último pedido de un cliente
CREATE OR REPLACE FUNCTION days_since_last_order(p_customer_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
  v_last_order_date TIMESTAMP;
BEGIN
  SELECT MAX(created_at)
  INTO v_last_order_date
  FROM orders
  WHERE customer_id = p_customer_id;
  
  IF v_last_order_date IS NULL THEN
    RETURN NULL;
  END IF;
  
  RETURN CAST(CURRENT_DATE - CAST(v_last_order_date AS DATE) AS INTEGER);
END;
$$ LANGUAGE plpgsql;

-- FUNCIÓN 8: get_inventory_value
-- Descripción: Calcula el valor total del inventario (stock_quantity * cost de todos los productos)
CREATE OR REPLACE FUNCTION get_inventory_value()
RETURNS DECIMAL(12,2) AS $$
DECLARE
  v_total_value DECIMAL(12,2);
BEGIN
  SELECT COALESCE(SUM(stock_quantity * cost), 0.00)
  INTO v_total_value
  FROM products
  WHERE is_active = true;
  
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

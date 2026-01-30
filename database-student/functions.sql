-- Subtotal de pedido
CREATE OR REPLACE FUNCTION calculate_order_subtotal(p_order_id INT)
RETURNS NUMERIC(12,2) AS $$
BEGIN
  RETURN COALESCE((
    SELECT SUM(price * quantity)
    FROM order_items
    WHERE order_id = p_order_id
  ), 0);
END;
$$ LANGUAGE plpgsql;

-- Aplicar descuento
CREATE OR REPLACE FUNCTION apply_discount(
  p_subtotal NUMERIC(12,2),
  p_discount_percent NUMERIC(5,2)
)
RETURNS NUMERIC(12,2) AS $$
BEGIN
  RETURN ROUND(p_subtotal - (p_subtotal * p_discount_percent / 100), 2);
END;
$$ LANGUAGE plpgsql;

-- Calcular impuestos (16%)
CREATE OR REPLACE FUNCTION calculate_tax(p_subtotal NUMERIC(12,2))
RETURNS NUMERIC(12,2) AS $$
BEGIN
  RETURN ROUND(p_subtotal * 0.16, 2);
END;
$$ LANGUAGE plpgsql;

-- Estadísticas cliente
CREATE OR REPLACE FUNCTION get_customer_statistics(p_customer_id INT)
RETURNS TABLE(total_orders INT, total_spent NUMERIC(12,2)) AS $$
BEGIN
  RETURN QUERY
  SELECT COUNT(*), COALESCE(SUM(total),0)
  FROM orders
  WHERE customer_id = p_customer_id
    AND status <> 'cancelled';
END;
$$ LANGUAGE plpgsql;

-- Verificar stock
CREATE OR REPLACE FUNCTION check_product_availability(p_product_id INT, p_quantity INT)
RETURNS BOOLEAN AS $$
DECLARE v_stock INT;
BEGIN
  SELECT stock_quantity INTO v_stock FROM products WHERE id = p_product_id;
  RETURN COALESCE(v_stock,0) >= p_quantity;
END;
$$ LANGUAGE plpgsql;

-- Margen de ganancia
CREATE OR REPLACE FUNCTION calculate_profit_margin(p_product_id INT)
RETURNS NUMERIC(5,2) AS $$
DECLARE v_price NUMERIC; v_cost NUMERIC;
BEGIN
  SELECT price, cost INTO v_price, v_cost FROM products WHERE id = p_product_id;
  IF v_price IS NULL OR v_price = 0 THEN RETURN 0; END IF;
  RETURN ROUND(((v_price - v_cost) / v_price) * 100, 2);
END;
$$ LANGUAGE plpgsql;

-- Días desde última compra
CREATE OR REPLACE FUNCTION days_since_last_order(p_customer_id INT)
RETURNS INT AS $$
DECLARE v_last TIMESTAMP;
BEGIN
  SELECT MAX(created_at) INTO v_last FROM orders WHERE customer_id = p_customer_id;
  IF v_last IS NULL THEN RETURN NULL; END IF;
  RETURN CURRENT_DATE - v_last::DATE;
END;
$$ LANGUAGE plpgsql;

-- Valor total inventario
CREATE OR REPLACE FUNCTION get_inventory_value()
RETURNS NUMERIC(12,2) AS $$
BEGIN
  RETURN COALESCE((SELECT SUM(stock_quantity * cost) FROM products WHERE active = true),0);
END;
$$ LANGUAGE plpgsql;
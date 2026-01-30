-- Actualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_users
BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_update_products
BEFORE UPDATE ON products
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();


-- Validar stock 
CREATE OR REPLACE FUNCTION validate_product_stock()
RETURNS TRIGGER AS $$
DECLARE v_stock INT;
BEGIN
  SELECT stock_quantity INTO v_stock
  FROM products
  WHERE id = NEW.product_id
  FOR UPDATE;

  IF v_stock < NEW.quantity THEN
    RAISE EXCEPTION 'Insufficient stock for product %', NEW.product_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_stock
BEFORE INSERT OR UPDATE ON order_items
FOR EACH ROW EXECUTE FUNCTION validate_product_stock();

-- Actualizar stock 
CREATE OR REPLACE FUNCTION update_product_stock()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE products
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE id = NEW.product_id;

  ELSIF TG_OP = 'DELETE' THEN
    UPDATE products
    SET stock_quantity = stock_quantity + OLD.quantity
    WHERE id = OLD.product_id;

  ELSIF TG_OP = 'UPDATE' THEN
    UPDATE products
    SET stock_quantity = stock_quantity + OLD.quantity - NEW.quantity
    WHERE id = NEW.product_id;
  END IF;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_stock
AFTER INSERT OR UPDATE OR DELETE ON order_items
FOR EACH ROW EXECUTE FUNCTION update_product_stock();

-- Recalcular totales
CREATE OR REPLACE FUNCTION update_order_totals()
RETURNS TRIGGER AS $$
DECLARE
  v_order INT;
  v_sub NUMERIC;
  v_tax NUMERIC;
  v_discount NUMERIC;
BEGIN
  v_order := COALESCE(NEW.order_id, OLD.order_id);

  SELECT COALESCE(SUM(price * quantity),0)
  INTO v_sub
  FROM order_items
  WHERE order_id = v_order;

  v_tax := ROUND(v_sub * 0.16, 2);

  SELECT COALESCE(discount,0)
  INTO v_discount
  FROM orders
  WHERE id = v_order;

  UPDATE orders
  SET subtotal = v_sub,
      tax = v_tax,
      total = v_sub + v_tax - v_discount
  WHERE id = v_order;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_order_totals
AFTER INSERT OR UPDATE OR DELETE ON order_items
FOR EACH ROW EXECUTE FUNCTION update_order_totals();

-- Auditoría productos
CREATE OR REPLACE FUNCTION audit_product_changes()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit(table_name, operation, record_id, before_data, after_data)
  VALUES ('products', TG_OP, COALESCE(NEW.id, OLD.id), row_to_json(OLD), row_to_json(NEW));

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_products
AFTER INSERT OR UPDATE OR DELETE ON products
FOR EACH ROW EXECUTE FUNCTION audit_product_changes();

-- Actualizar estadísticas del cliente cuando cambian pedidos
CREATE OR REPLACE FUNCTION update_customer_statistics()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE customers
  SET total_orders = (
        SELECT COUNT(*) FROM orders
        WHERE customer_id = NEW.customer_id AND status <> 'cancelled'
      ),
      total_spent = (
        SELECT COALESCE(SUM(total),0) FROM orders
        WHERE customer_id = NEW.customer_id AND status <> 'cancelled'
      ),
      last_purchase = CURRENT_TIMESTAMP
  WHERE id = NEW.customer_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_customer_stats
AFTER INSERT OR UPDATE ON orders
FOR EACH ROW EXECUTE FUNCTION update_customer_statistics();

-- Evitar pedidos sin cliente
CREATE OR REPLACE FUNCTION validate_order_customer()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.customer_id IS NULL THEN
    RAISE EXCEPTION 'Order must have a customer';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_order_customer
BEFORE INSERT ON orders
FOR EACH ROW EXECUTE FUNCTION validate_order_customer();

-- Auditoría de pedidos
CREATE OR REPLACE FUNCTION audit_order_changes()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit(table_name, operation, record_id, before_data, after_data)
  VALUES ('orders', TG_OP, COALESCE(NEW.id, OLD.id), row_to_json(OLD), row_to_json(NEW));

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_orders
AFTER INSERT OR UPDATE OR DELETE ON orders
FOR EACH ROW EXECUTE FUNCTION audit_order_changes();
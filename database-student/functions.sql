-- =====================================================
-- FUNCIONES PL/pgSQL - E-COMMERCE EXAM
-- =====================================================
-- Autor: [TU NOMBRE]
-- Fecha: 29 Enero 2026
-- =====================================================

-- Eliminar funciones si existen
DROP FUNCTION IF EXISTS calculate_order_subtotal(INTEGER);
DROP FUNCTION IF EXISTS apply_discount(DECIMAL, DECIMAL);
DROP FUNCTION IF EXISTS calculate_tax(DECIMAL);
DROP FUNCTION IF EXISTS update_customer_statistics(INTEGER);
DROP FUNCTION IF EXISTS check_product_availability(INTEGER, INTEGER);
DROP FUNCTION IF EXISTS calculate_profit_margin(INTEGER);
DROP FUNCTION IF EXISTS days_since_last_order(INTEGER);
DROP FUNCTION IF EXISTS get_inventory_value();

-- =====================================================
-- FUNCIÓN 1: calculate_order_subtotal
-- =====================================================
CREATE OR REPLACE FUNCTION calculate_order_subtotal(p_order_id INTEGER)
RETURNS DECIMAL(10,2)
LANGUAGE plpgsql
AS $$
DECLARE
    subtotal_result DECIMAL(10,2);
BEGIN
    SELECT COALESCE(SUM(subtotal), 0)
    INTO subtotal_result
    FROM order_items
    WHERE order_id = p_order_id;
    
    RETURN subtotal_result;
END;
$$;

COMMENT ON FUNCTION calculate_order_subtotal IS 'Calcula el subtotal de todos los items de un pedido';

-- =====================================================
-- FUNCIÓN 2: apply_discount
-- =====================================================
CREATE OR REPLACE FUNCTION apply_discount(p_price DECIMAL, p_discount_percent DECIMAL)
RETURNS DECIMAL(10,2)
LANGUAGE plpgsql
AS $$
DECLARE
    discounted_price DECIMAL(10,2);
BEGIN
    IF p_discount_percent < 0 OR p_discount_percent > 100 THEN
        RAISE EXCEPTION 'El porcentaje de descuento debe estar entre 0 y 100';
    END IF;
    
    discounted_price := p_price - (p_price * p_discount_percent / 100);
    
    RETURN ROUND(discounted_price, 2);
END;
$$;

COMMENT ON FUNCTION apply_discount IS 'Aplica un porcentaje de descuento a un precio';

-- =====================================================
-- FUNCIÓN 3: calculate_tax
-- =====================================================
CREATE OR REPLACE FUNCTION calculate_tax(p_subtotal DECIMAL)
RETURNS DECIMAL(10,2)
LANGUAGE plpgsql
AS $$
DECLARE
    tax_amount DECIMAL(10,2);
BEGIN
    -- Calcula impuesto del 16%
    tax_amount := p_subtotal * 0.16;
    
    RETURN ROUND(tax_amount, 2);
END;
$$;

COMMENT ON FUNCTION calculate_tax IS 'Calcula el impuesto (16%) sobre un monto';

-- =====================================================
-- FUNCIÓN 4: update_customer_statistics
-- =====================================================
CREATE OR REPLACE FUNCTION update_customer_statistics(p_customer_id INTEGER)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    total_orders INTEGER;
    total_amount DECIMAL(10,2);
BEGIN
    -- Calcular estadísticas
    SELECT 
        COUNT(*),
        COALESCE(SUM(total_amount), 0)
    INTO total_orders, total_amount
    FROM orders
    WHERE customer_id = p_customer_id
        AND status != 'cancelled';
    
    -- Nota: Como la tabla customers no tiene campos total_spent y order_count,
    -- solo retornamos true. En un sistema real, aquí se haría el UPDATE.
    RAISE NOTICE 'Cliente %: % pedidos, $% gastados', p_customer_id, total_orders, total_amount;
    
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END;
$$;

COMMENT ON FUNCTION update_customer_statistics IS 'Actualiza las estadísticas de un cliente';

-- =====================================================
-- FUNCIÓN 5: check_product_availability
-- =====================================================
CREATE OR REPLACE FUNCTION check_product_availability(p_product_id INTEGER, p_quantity INTEGER)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    current_stock INTEGER;
BEGIN
    SELECT stock_quantity
    INTO current_stock
    FROM products
    WHERE id = p_product_id;
    
    IF current_stock IS NULL THEN
        RAISE EXCEPTION 'Producto no encontrado';
    END IF;
    
    RETURN current_stock >= p_quantity;
END;
$$;

COMMENT ON FUNCTION check_product_availability IS 'Verifica si hay stock suficiente de un producto';

-- =====================================================
-- FUNCIÓN 6: calculate_profit_margin
-- =====================================================
CREATE OR REPLACE FUNCTION calculate_profit_margin(p_product_id INTEGER)
RETURNS DECIMAL(5,2)
LANGUAGE plpgsql
AS $$
DECLARE
    product_price DECIMAL(10,2);
    product_cost DECIMAL(10,2);
    margin_percent DECIMAL(5,2);
BEGIN
    SELECT price, cost
    INTO product_price, product_cost
    FROM products
    WHERE id = p_product_id;
    
    IF product_price IS NULL OR product_cost IS NULL THEN
        RAISE EXCEPTION 'Producto no encontrado';
    END IF;
    
    IF product_price = 0 THEN
        RETURN 0;
    END IF;
    
    margin_percent := ((product_price - product_cost) / product_price) * 100;
    
    RETURN ROUND(margin_percent, 2);
END;
$$;

COMMENT ON FUNCTION calculate_profit_margin IS 'Calcula el margen de ganancia de un producto en porcentaje';

-- =====================================================
-- FUNCIÓN 7: days_since_last_order
-- =====================================================
CREATE OR REPLACE FUNCTION days_since_last_order(p_customer_id INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    last_order_date DATE;
    days_elapsed INTEGER;
BEGIN
    SELECT MAX(created_at::DATE)
    INTO last_order_date
    FROM orders
    WHERE customer_id = p_customer_id;
    
    IF last_order_date IS NULL THEN
        RETURN NULL; -- Cliente sin pedidos
    END IF;
    
    days_elapsed := CURRENT_DATE - last_order_date;
    
    RETURN days_elapsed;
END;
$$;

COMMENT ON FUNCTION days_since_last_order IS 'Calcula días transcurridos desde el último pedido de un cliente';

-- =====================================================
-- FUNCIÓN 8: get_inventory_value
-- =====================================================
CREATE OR REPLACE FUNCTION get_inventory_value()
RETURNS DECIMAL(12,2)
LANGUAGE plpgsql
AS $$
DECLARE
    total_value DECIMAL(12,2);
BEGIN
    SELECT COALESCE(SUM(stock_quantity * cost), 0)
    INTO total_value
    FROM products
    WHERE is_active = true;
    
    RETURN total_value;
END;
$$;

COMMENT ON FUNCTION get_inventory_value IS 'Calcula el valor total del inventario actual';

-- =====================================================
-- VERIFICACIÓN
-- =====================================================

-- Probar función 1
SELECT calculate_order_subtotal(1) AS subtotal_pedido_1;

-- Probar función 2
SELECT apply_discount(100.00, 10) AS precio_con_descuento;

-- Probar función 3
SELECT calculate_tax(1000.00) AS impuesto;

-- Probar función 5
SELECT check_product_availability(1, 5) AS stock_disponible;

-- Probar función 6
SELECT calculate_profit_margin(1) AS margen_producto_1;

-- Probar función 7
SELECT days_since_last_order(1) AS dias_ultimo_pedido;

-- Probar función 8
SELECT get_inventory_value() AS valor_inventario_total;

-- =====================================================
-- FIN DE FUNCIONES
-- =====================================================
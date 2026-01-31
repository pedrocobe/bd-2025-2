-- =====================================================
-- FUNCIONES ALMACENADAS - E-COMMERCE EXAM
-- =====================================================
-- Este archivo contiene funciones SQL reutilizables para
-- operaciones complejas del sistema de e-commerce
-- =====================================================

-- =====================================================
-- FUNCIÓN 1: Calcular descuento por volumen
-- =====================================================
-- Descripción: Calcula el descuento según la cantidad comprada
-- Parámetros: quantity (cantidad), unit_price (precio unitario)
-- Retorna: precio con descuento aplicado
SET client_encoding = 'UTF8';

CREATE OR REPLACE FUNCTION calculate_volume_discount(
    p_quantity INTEGER,
    p_unit_price DECIMAL(10,2)
)
RETURNS DECIMAL(10,2) AS $$
DECLARE
    v_discount_percent DECIMAL(5,2);
    v_final_price DECIMAL(10,2);
BEGIN
    -- Determinar el porcentaje de descuento según cantidad
    v_discount_percent := CASE
        WHEN p_quantity >= 100 THEN 0.15  -- 15% de descuento
        WHEN p_quantity >= 50 THEN 0.10   -- 10% de descuento
        WHEN p_quantity >= 20 THEN 0.05   -- 5% de descuento
        ELSE 0.00                          -- Sin descuento
    END;

    -- Calcular precio final
    v_final_price := p_unit_price * (1 - v_discount_percent);

    RETURN ROUND(v_final_price, 2);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

COMMENT ON FUNCTION calculate_volume_discount IS 
'Calcula el precio con descuento por volumen según la cantidad';


-- =====================================================
-- FUNCIÓN 2: Verificar disponibilidad de stock
-- =====================================================
-- Descripción: Verifica si hay suficiente stock para un producto
-- Parámetros: product_id, cantidad requerida
-- Retorna: TRUE si hay stock, FALSE si no

CREATE OR REPLACE FUNCTION check_stock_availability(
    p_product_id INTEGER,
    p_quantity INTEGER
)
RETURNS BOOLEAN AS $$
DECLARE
    v_available_stock INTEGER;
BEGIN
    SELECT stock_quantity
    INTO v_available_stock
    FROM products
    WHERE id = p_product_id AND is_active = true;

    IF v_available_stock IS NULL THEN
        RETURN FALSE;
    END IF;

    RETURN v_available_stock >= p_quantity;
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION check_stock_availability IS 
'Verifica si hay stock suficiente para un producto';


-- =====================================================
-- FUNCIÓN 3: Obtener total de ventas de un período
-- =====================================================
-- Descripción: Calcula el total de ventas en un rango de fechas
-- Parámetros: fecha inicio, fecha fin
-- Retorna: total de ventas (excluyendo cancelados)

CREATE OR REPLACE FUNCTION get_sales_total(
    p_start_date DATE,
    p_end_date DATE
)
RETURNS DECIMAL(12,2) AS $$
DECLARE
    v_total DECIMAL(12,2);
BEGIN
    SELECT COALESCE(SUM(total), 0)
    INTO v_total
    FROM orders
    WHERE created_at::DATE BETWEEN p_start_date AND p_end_date
    AND status != 'cancelled';

    RETURN v_total;
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION get_sales_total IS 
'Calcula el total de ventas en un rango de fechas';


-- =====================================================
-- FUNCIÓN 4: Obtener productos con stock bajo
-- =====================================================
-- Descripción: Retorna lista de productos con stock bajo
-- Parámetros: ninguno
-- Retorna: tabla con productos que necesitan reabastecimiento

CREATE OR REPLACE FUNCTION get_low_stock_products()
RETURNS TABLE (
    product_id INTEGER,
    product_name VARCHAR(200),
    sku VARCHAR(50),
    current_stock INTEGER,
    min_stock INTEGER,
    deficit INTEGER,
    category_name VARCHAR(100)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.id,
        p.name,
        p.sku,
        p.stock_quantity,
        p.min_stock_level,
        (p.min_stock_level - p.stock_quantity) AS deficit,
        c.name AS category_name
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE p.stock_quantity < p.min_stock_level
    AND p.is_active = true
    ORDER BY deficit DESC;
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION get_low_stock_products IS 
'Retorna todos los productos con stock bajo el nivel mínimo';


-- =====================================================
-- FUNCIÓN 5: Calcular valor total del inventario
-- =====================================================
-- Descripción: Calcula el valor total del inventario
-- Parámetros: ninguno
-- Retorna: valor total (stock_quantity * cost)

CREATE OR REPLACE FUNCTION get_total_inventory_value()
RETURNS DECIMAL(15,2) AS $$
DECLARE
    v_total_value DECIMAL(15,2);
BEGIN
    SELECT COALESCE(SUM(stock_quantity * cost), 0)
    INTO v_total_value
    FROM products
    WHERE is_active = true;

    RETURN v_total_value;
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION get_total_inventory_value IS 
'Calcula el valor total del inventario al costo';


-- =====================================================
-- FUNCIÓN 6: Obtener estadísticas de cliente
-- =====================================================
-- Descripción: Retorna estadísticas completas de un cliente
-- Parámetros: customer_id
-- Retorna: registro con todas las estadísticas

CREATE OR REPLACE FUNCTION get_customer_stats(p_customer_id INTEGER)
RETURNS TABLE (
    customer_id INTEGER,
    full_name VARCHAR(200),
    email VARCHAR(100),
    total_orders INTEGER,
    total_spent DECIMAL(12,2),
    avg_order_value DECIMAL(10,2),
    last_order_date TIMESTAMP,
    days_since_last_order INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.id,
        (c.first_name || ' ' || c.last_name)::VARCHAR(200),
        c.email,
        COUNT(o.id)::INTEGER,
        COALESCE(SUM(o.total), 0)::DECIMAL(12,2),
        COALESCE(AVG(o.total), 0)::DECIMAL(10,2),
        MAX(o.created_at),
        COALESCE(CURRENT_DATE - MAX(o.created_at)::DATE, 0)::INTEGER
    FROM customers c
    LEFT JOIN orders o ON c.id = o.customer_id AND o.status != 'cancelled'
    WHERE c.id = p_customer_id
    GROUP BY c.id, c.first_name, c.last_name, c.email;
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION get_customer_stats IS 
'Retorna estadísticas completas de un cliente específico';


-- =====================================================
-- FUNCIÓN 7: Calcular comisión de vendedor
-- =====================================================
-- Descripción: Calcula la comisión de un vendedor según sus ventas
-- Parámetros: user_id, fecha inicio, fecha fin
-- Retorna: monto de comisión (5% de ventas)

CREATE OR REPLACE FUNCTION calculate_employee_commission(
    p_user_id INTEGER,
    p_start_date DATE,
    p_end_date DATE
)
RETURNS DECIMAL(10,2) AS $$
DECLARE
    v_total_sales DECIMAL(12,2);
    v_commission DECIMAL(10,2);
BEGIN
    -- Obtener total de ventas del empleado
    SELECT COALESCE(SUM(total), 0)
    INTO v_total_sales
    FROM orders
    WHERE created_by = p_user_id
    AND created_at::DATE BETWEEN p_start_date AND p_end_date
    AND status != 'cancelled';

    -- Calcular comisión (5%)
    v_commission := v_total_sales * 0.05;

    RETURN ROUND(v_commission, 2);
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION calculate_employee_commission IS 
'Calcula la comisión de un empleado según sus ventas (5%)';


-- =====================================================
-- FUNCIÓN 8: Validar datos de tarjeta de crédito (simulado)
-- =====================================================
-- Descripción: Simula validación de tarjeta de crédito
-- Parámetros: número de tarjeta
-- Retorna: TRUE si válida, FALSE si no

CREATE OR REPLACE FUNCTION validate_credit_card(
    p_card_number VARCHAR(16)
)
RETURNS BOOLEAN AS $$
BEGIN
    -- Validar longitud
    IF LENGTH(p_card_number) != 16 THEN
        RETURN FALSE;
    END IF;

    -- Validar que solo contenga números
    IF p_card_number !~ '^[0-9]+$' THEN
        RETURN FALSE;
    END IF;

    -- Simulación: rechazar tarjetas que empiecen con 0000
    IF p_card_number LIKE '0000%' THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

COMMENT ON FUNCTION validate_credit_card IS 
'Valida formato básico de número de tarjeta de crédito';


-- =====================================================
-- FUNCIÓN 9: Obtener productos más vendidos
-- =====================================================
-- Descripción: Retorna los N productos más vendidos
-- Parámetros: límite de resultados
-- Retorna: tabla con productos y cantidad vendida

CREATE OR REPLACE FUNCTION get_top_selling_products(p_limit INTEGER DEFAULT 10)
RETURNS TABLE (
    product_id INTEGER,
    product_name VARCHAR(200),
    sku VARCHAR(50),
    total_quantity_sold BIGINT,
    total_revenue DECIMAL(12,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.id,
        p.name,
        p.sku,
        SUM(oi.quantity)::BIGINT,
        SUM(oi.subtotal)::DECIMAL(12,2)
    FROM products p
    INNER JOIN order_items oi ON p.id = oi.product_id
    INNER JOIN orders o ON oi.order_id = o.id
    WHERE o.status != 'cancelled'
    GROUP BY p.id, p.name, p.sku
    ORDER BY SUM(oi.quantity) DESC
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION get_top_selling_products IS 
'Retorna los productos más vendidos';


-- =====================================================
-- FUNCIÓN 10: Calcular edad del inventario
-- =====================================================
-- Descripción: Calcula cuántos días lleva un producto en catálogo
-- Parámetros: product_id
-- Retorna: número de días

CREATE OR REPLACE FUNCTION get_product_age(p_product_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
    v_days INTEGER;
BEGIN
    SELECT CURRENT_DATE - created_at::DATE
    INTO v_days
    FROM products
    WHERE id = p_product_id;

    RETURN COALESCE(v_days, 0);
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION get_product_age IS 
'Calcula cuántos días lleva un producto en el catálogo';


-- =====================================================
-- FUNCIÓN 11: Generar reporte de ventas diarias
-- =====================================================
-- Descripción: Retorna resumen de ventas del día
-- Parámetros: fecha
-- Retorna: tabla con resumen

CREATE OR REPLACE FUNCTION get_daily_sales_report(p_date DATE)
RETURNS TABLE (
    sale_date DATE,
    total_orders INTEGER,
    total_revenue DECIMAL(12,2),
    avg_order_value DECIMAL(10,2),
    total_items_sold BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p_date,
        COUNT(DISTINCT o.id)::INTEGER,
        COALESCE(SUM(o.total), 0)::DECIMAL(12,2),
        COALESCE(AVG(o.total), 0)::DECIMAL(10,2),
        COALESCE(SUM(oi.quantity), 0)::BIGINT
    FROM orders o
    LEFT JOIN order_items oi ON o.id = oi.order_id
    WHERE o.created_at::DATE = p_date
    AND o.status != 'cancelled';
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION get_daily_sales_report IS 
'Genera un resumen de ventas para una fecha específica';


-- =====================================================
-- FUNCIÓN 12: Buscar productos por texto
-- =====================================================
-- Descripción: Búsqueda full-text en productos
-- Parámetros: término de búsqueda
-- Retorna: tabla con productos encontrados

CREATE OR REPLACE FUNCTION search_products(p_search_term VARCHAR(200))
RETURNS TABLE (
    product_id INTEGER,
    product_name VARCHAR(200),
    sku VARCHAR(50),
    price DECIMAL(10,2),
    stock INTEGER,
    category VARCHAR(100)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.id,
        p.name,
        p.sku,
        p.price,
        p.stock_quantity,
        c.name
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE p.is_active = true
    AND (
        p.name ILIKE '%' || p_search_term || '%'
        OR p.sku ILIKE '%' || p_search_term || '%'
        OR p.description ILIKE '%' || p_search_term || '%'
    )
    ORDER BY p.name;
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION search_products IS 
'Busca productos por nombre, SKU o descripción';


-- =====================================================
-- FUNCIÓN 13: Calcular tasa de conversión
-- =====================================================
-- Descripción: Calcula el porcentaje de pedidos completados vs cancelados
-- Parámetros: fecha inicio, fecha fin
-- Retorna: porcentaje de conversión

CREATE OR REPLACE FUNCTION calculate_conversion_rate(
    p_start_date DATE,
    p_end_date DATE
)
RETURNS DECIMAL(5,2) AS $$
DECLARE
    v_total_orders INTEGER;
    v_completed_orders INTEGER;
    v_conversion_rate DECIMAL(5,2);
BEGIN
    -- Total de pedidos
    SELECT COUNT(*)
    INTO v_total_orders
    FROM orders
    WHERE created_at::DATE BETWEEN p_start_date AND p_end_date;

    -- Pedidos completados (delivered)
    SELECT COUNT(*)
    INTO v_completed_orders
    FROM orders
    WHERE created_at::DATE BETWEEN p_start_date AND p_end_date
    AND status = 'delivered';

    -- Calcular tasa de conversión
    IF v_total_orders = 0 THEN
        RETURN 0;
    END IF;

    v_conversion_rate := (v_completed_orders::DECIMAL / v_total_orders) * 100;

    RETURN ROUND(v_conversion_rate, 2);
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION calculate_conversion_rate IS 
'Calcula el porcentaje de pedidos que se completan exitosamente';


-- =====================================================
-- FIN DE FUNCIONES
-- =====================================================

-- Verificación: Listar todas las funciones creadas
SELECT 
    routine_name AS function_name,
    routine_type,
    data_type AS return_type
FROM information_schema.routines
WHERE routine_schema = 'public'
AND routine_type = 'FUNCTION'
AND routine_name NOT LIKE 'update_%_column'
ORDER BY routine_name;

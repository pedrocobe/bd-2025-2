/**
 * QUERIES DE REPORTES - reports.queries.ts
 * 
 * INSTRUCCIONES:
 * Este archivo contiene queries SQL COMPLEJOS para reportería y análisis.
 * Requieren conocimiento avanzado de:
 * - JOINs múltiples
 * - Agregaciones (COUNT, SUM, AVG, etc.)
 * - GROUP BY y HAVING
 * - Subconsultas
 * - Funciones de fecha
 * - UNION
 * 
 * Estos queries son los MÁS DIFÍCILES del examen.
 */

export const ReportsQueries = {
  /**
   * dailySales - Ventas diarias en un rango de fechas
   * 
   * Descripción: Agrupa las ventas por día
   * Parámetros:
   *   $1 = fecha_inicio (date)
   *   $2 = fecha_fin (date)
   * 
   * Debe retornar:
   *   DATE(created_at) AS sale_date,
   *   COUNT(*) AS order_count,
   *   SUM(total) AS total_sales,
   *   AVG(total) AS avg_order_value,
   *   SUM(subtotal) AS subtotal,
   *   SUM(tax) AS total_tax,
   *   SUM(shipping_cost) AS total_shipping
   * 
   * Tabla: orders
   * Filtro: created_at BETWEEN $1 AND $2 AND status != 'cancelled'
   * Agrupa por: DATE(created_at)
   * Ordenar por: sale_date ascendente
   */
  dailySales: `
    
  `,

  /**
   * monthlySales - Ventas mensuales de un año
   * 
   * Descripción: Agrupa ventas por mes
   * Parámetros:
   *   $1 = año (integer)
   * 
   * Debe retornar:
   *   EXTRACT(MONTH FROM created_at)::INTEGER AS month_num,
   *   TO_CHAR(created_at, 'Month') AS month_name,
   *   COUNT(*) AS order_count,
   *   SUM(total) AS total_sales,
   *   AVG(total) AS avg_order_value
   * 
   * Filtro: EXTRACT(YEAR FROM created_at) = $1 AND status != 'cancelled'
   * Agrupa por: mes
   * Ordenar por: month_num ascendente
   */
  monthlySales: `
    
  `,

  /**
   * topSellingProducts - Ranking de productos más vendidos (MUY COMPLEJO)
   * 
   * Descripción: Productos con mayor volumen de ventas
   * Parámetros:
   *   $1 = limit (integer)
   * 
   * Debe retornar:
   *   p.id, p.name, p.sku, p.price,
   *   c.name AS category_name,
   *   SUM(oi.quantity) AS total_quantity_sold,
   *   COUNT(DISTINCT o.id) AS order_count,
   *   SUM(oi.subtotal) AS total_revenue,
   *   AVG(oi.unit_price) AS avg_selling_price
   * 
   * Tablas:
   *   - INNER JOIN order_items oi con products p
   *   - INNER JOIN orders o con order_items
   *   - LEFT JOIN categories c con products
   * 
   * Filtro: o.status != 'cancelled'
   * Agrupa por: p.id, p.name, p.sku, p.price, c.name
   * Ordenar por: total_quantity_sold descendente
   * Usa: LIMIT $1
   */
  topSellingProducts: `
    
  `,

  /**
   * topCustomers - Mejores clientes por valor de compras
   * 
   * Parámetros:
   *   $1 = limit (integer)
   * 
   * Debe retornar:
   *   c.id,
   *   c.first_name || ' ' || c.last_name AS customer_name,
   *   c.email, c.city, c.country,
   *   COUNT(o.id) AS order_count,
   *   COALESCE(SUM(o.total), 0) AS lifetime_value,
   *   COALESCE(AVG(o.total), 0) AS avg_order_value,
   *   MAX(o.created_at) AS last_order_date
   * 
   * Tabla principal: customers c
   * Usa: LEFT JOIN orders o (filtrar status != 'cancelled')
   * Agrupa por: c.id y demás campos del cliente
   * Ordenar por: lifetime_value descendente
   * Usa: LIMIT $1
   * 
   * NOTA: Usa COALESCE para manejar clientes sin pedidos
   */
  topCustomers: `
    
  `,

  /**
   * salesByCategory - Ventas agrupadas por categoría
   * 
   * Parámetros: ninguno
   * 
   * Debe retornar:
   *   c.id AS category_id,
   *   c.name AS category_name,
   *   COUNT(DISTINCT p.id) AS product_count,
   *   COALESCE(SUM(oi.quantity), 0) AS units_sold,
   *   COALESCE(SUM(oi.subtotal), 0) AS total_revenue,
   *   COALESCE(AVG(oi.unit_price), 0) AS avg_price
   * 
   * Tabla principal: categories c
   * LEFT JOIN: products p, order_items oi, orders o
   * Filtro en orders: o.status != 'cancelled'
   * Agrupa por: c.id, c.name
   * Ordenar por: total_revenue descendente
   */
  salesByCategory: `
    
  `,

  /**
   * inventoryAnalysis - Análisis completo de inventario por categoría
   * 
   * Parámetros: ninguno
   * 
   * Debe retornar:
   *   c.name AS category_name,
   *   COUNT(p.id) AS product_count,
   *   SUM(p.stock_quantity) AS total_units,
   *   SUM(p.stock_quantity * p.cost) AS inventory_cost,
   *   SUM(p.stock_quantity * p.price) AS inventory_value,
   *   SUM(p.stock_quantity * (p.price - p.cost)) AS potential_profit,
   *   COUNT(CASE WHEN p.stock_quantity < p.min_stock_level THEN 1 END) AS low_stock_items
   * 
   * Usa: LEFT JOIN products con categories
   * Filtro: p.is_active = true
   * Agrupa por: c.name
   * Ordenar por: inventory_value descendente
   * 
   * PISTA: COUNT(CASE WHEN ... THEN 1 END) cuenta solo los casos que cumplen condición
   */
  inventoryAnalysis: `
    
  `,

  /**
   * profitMarginReport - Reporte de márgenes de ganancia
   * 
   * Parámetros: ninguno
   * 
   * Debe retornar:
   *   p.id, p.name, p.sku,
   *   c.name AS category_name,
   *   p.cost, p.price,
   *   (p.price - p.cost) AS profit_per_unit,
   *   ROUND(((p.price - p.cost) / p.price) * 100, 2) AS margin_percent,
   *   p.stock_quantity,
   *   (p.stock_quantity * (p.price - p.cost)) AS total_potential_profit
   * 
   * Usa: LEFT JOIN con categories
   * Filtro: p.is_active = true AND p.price > 0
   * Ordenar por: margin_percent descendente
   */
  profitMarginReport: `
    
  `,

  /**
   * salesByCity - Ventas agrupadas por ciudad
   * 
   * Parámetros: ninguno
   * 
   * Debe retornar:
   *   c.city, c.country,
   *   COUNT(DISTINCT c.id) AS customer_count,
   *   COUNT(o.id) AS order_count,
   *   COALESCE(SUM(o.total), 0) AS total_revenue,
   *   ROUND(COALESCE(COUNT(o.id)::NUMERIC / NULLIF(COUNT(DISTINCT c.id), 0), 0), 2) AS orders_per_customer,
   *   ROUND(COALESCE(AVG(o.total), 0), 2) AS avg_order_value
   * 
   * Tabla: customers c
   * LEFT JOIN: orders o (filtrar status != 'cancelled')
   * Agrupa por: c.city, c.country
   * Filtro con HAVING: COUNT(DISTINCT c.id) > 0
   * Ordenar por: total_revenue descendente
   * 
   * PISTA: NULLIF previene división por cero
   */
  salesByCity: `
    
  `,

  /**
   * abandonedOrders - Pedidos pendientes abandonados
   * 
   * Descripción: Pedidos en estado 'pending' con más de X días
   * Parámetros:
   *   $1 = días (integer)
   * 
   * Debe retornar:
   *   o.id, o.order_number, o.created_at,
   *   CURRENT_DATE - o.created_at::date AS days_pending,
   *   o.total,
   *   c.first_name || ' ' || c.last_name AS customer_name,
   *   c.email
   * 
   * Usa: INNER JOIN customers c ON o.customer_id = c.id
   * Filtro: o.status = 'pending' 
   *         AND o.created_at < CURRENT_DATE - ($1 || ' days')::INTERVAL
   * Ordenar por: days_pending descendente
   * 
   * PISTA: ($1 || ' days')::INTERVAL convierte número a intervalo de días
   */
  abandonedOrders: `
    
  `,

  /**
   * unsoldProducts - Productos sin ventas en un período
   * 
   * Parámetros:
   *   $1 = días (integer)
   * 
   * Debe retornar:
   *   p.id, p.name, p.sku,
   *   c.name AS category_name,
   *   p.price, p.stock_quantity,
   *   p.created_at,
   *   CURRENT_DATE - p.created_at::date AS days_in_catalog
   * 
   * Tabla: products p
   * LEFT JOIN: categories c
   * LEFT JOIN: order_items oi ON p.id = oi.product_id
   * LEFT JOIN: orders o ON oi.order_id = o.id 
   *            AND o.created_at >= CURRENT_DATE - ($1 || ' days')::INTERVAL
   * 
   * Filtro: p.is_active = true AND o.id IS NULL
   * Ordenar por: days_in_catalog descendente
   * 
   * PISTA: Si no hay ventas en el período, o.id será NULL
   */
  unsoldProducts: `
    
  `,

  /**
   * employeePerformance - Rendimiento de empleados por ventas
   * 
   * Parámetros:
   *   $1 = fecha_inicio (date)
   *   $2 = fecha_fin (date)
   * 
   * Debe retornar:
   *   u.id, u.full_name, u.role,
   *   COUNT(o.id) AS orders_created,
   *   COALESCE(SUM(o.total), 0) AS total_sales,
   *   COALESCE(AVG(o.total), 0) AS avg_order_value,
   *   COUNT(DISTINCT o.customer_id) AS unique_customers
   * 
   * Tabla: users u
   * LEFT JOIN: orders o ON u.id = o.created_by
   * Filtros en JOIN: o.created_at BETWEEN $1 AND $2 AND o.status != 'cancelled'
   * Filtro WHERE: u.role IN ('employee', 'manager')
   * Agrupa por: u.id, u.full_name, u.role
   * Ordenar por: total_sales descendente
   */
  employeePerformance: `
    
  `,

  /**
   * salesTrend - Comparación de ventas: mes actual vs mes anterior (UNION)
   * 
   * Descripción: Usa UNION para comparar dos períodos
   * Parámetros:
   *   $1 = mes (integer, 1-12)
   *   $2 = año (integer)
   * 
   * Query 1 - Mes Actual:
   *   SELECT 'Mes Actual' AS period, COUNT(*) AS order_count, SUM(total) AS total_sales
   *   FROM orders
   *   WHERE EXTRACT(MONTH FROM created_at) = $1
   *     AND EXTRACT(YEAR FROM created_at) = $2
   *     AND status != 'cancelled'
   * 
   * UNION ALL
   * 
   * Query 2 - Mes Anterior:
   *   SELECT 'Mes Anterior' AS period, COUNT(*) AS order_count, SUM(total) AS total_sales
   *   FROM orders
   *   WHERE EXTRACT(MONTH FROM created_at) = [mes anterior]
   *     AND EXTRACT(YEAR FROM created_at) = [año correspondiente]
   *     AND status != 'cancelled'
   * 
   * NOTA: Si $1 = 1 (enero), el mes anterior es 12 (diciembre) del año $2 - 1
   *       Usa: CASE WHEN $1 = 1 THEN 12 ELSE $1 - 1 END
   */
  salesTrend: `
    
  `,

  /**
   * dashboardMetrics - Métricas generales del dashboard (SUBCONSULTAS)
   * 
   * Descripción: Un solo query con múltiples subconsultas en el SELECT
   * Parámetros: ninguno
   * 
   * Debe retornar (cada uno con una subconsulta):
   *   (SELECT COUNT(*) FROM customers WHERE is_active = true) AS total_customers,
   *   (SELECT COUNT(*) FROM products WHERE is_active = true) AS total_products,
   *   (SELECT COUNT(*) FROM orders WHERE status != 'cancelled') AS total_orders,
   *   (SELECT COALESCE(SUM(total), 0) FROM orders WHERE status != 'cancelled') AS total_revenue,
   *   (SELECT COALESCE(AVG(total), 0) FROM orders WHERE status != 'cancelled') AS avg_order_value,
   *   (SELECT COUNT(*) FROM products WHERE stock_quantity < min_stock_level) AS products_low_stock
   * 
   * NOTA: Este query NO tiene FROM, solo subconsultas en el SELECT
   */
  dashboardMetrics: `
    
  `,
};

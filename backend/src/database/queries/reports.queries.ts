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
    SELECT DATE(created_at) AS sale_date,
           COUNT(*) AS order_count,
           SUM(total) AS total_sales,
           AVG(total) AS avg_order_value,
           SUM(subtotal) AS subtotal,
           SUM(tax) AS total_tax,
           SUM(shipping_cost) AS total_shipping
    FROM orders
    WHERE created_at BETWEEN $1 AND $2 AND status != 'cancelled'
    GROUP BY DATE(created_at)
    ORDER BY sale_date ASC
  `,

  monthlySales: `
    SELECT EXTRACT(MONTH FROM created_at)::INTEGER AS month_num,
           TO_CHAR(created_at, 'Month') AS month_name,
           COUNT(*) AS order_count,
           SUM(total) AS total_sales,
           AVG(total) AS avg_order_value
    FROM orders
    WHERE EXTRACT(YEAR FROM created_at) = $1 AND status != 'cancelled'
    GROUP BY month_num, month_name
    ORDER BY month_num ASC
  `,

  topSellingProducts: `
    SELECT p.id, p.name, p.sku, p.price,
           c.name AS category_name,
           SUM(oi.quantity) AS total_quantity_sold,
           COUNT(DISTINCT o.id) AS order_count,
           SUM(oi.subtotal) AS total_revenue,
           AVG(oi.unit_price) AS avg_selling_price
    FROM products p
    INNER JOIN order_items oi ON p.id = oi.product_id
    INNER JOIN orders o ON oi.order_id = o.id
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE o.status != 'cancelled'
    GROUP BY p.id, p.name, p.sku, p.price, c.name
    ORDER BY total_quantity_sold DESC
    LIMIT $1
  `,

  topCustomers: `
    SELECT c.id,
           c.first_name || ' ' || c.last_name AS customer_name,
           c.email, c.city, c.country,
           COUNT(o.id) AS order_count,
           COALESCE(SUM(o.total), 0) AS lifetime_value,
           COALESCE(AVG(o.total), 0) AS avg_order_value,
           MAX(o.created_at) AS last_order_date
    FROM customers c
    LEFT JOIN orders o ON c.id = o.customer_id AND o.status != 'cancelled'
    GROUP BY c.id
    ORDER BY lifetime_value DESC
    LIMIT $1
  `,

  salesByCategory: `
    SELECT c.id AS category_id,
           c.name AS category_name,
           COUNT(DISTINCT p.id) AS product_count,
           COALESCE(SUM(oi.quantity), 0) AS units_sold,
           COALESCE(SUM(oi.subtotal), 0) AS total_revenue,
           COALESCE(AVG(oi.unit_price), 0) AS avg_price
    FROM categories c
    LEFT JOIN products p ON c.id = p.category_id
    LEFT JOIN order_items oi ON p.id = oi.product_id
    LEFT JOIN orders o ON oi.order_id = o.id AND o.status != 'cancelled'
    GROUP BY c.id, c.name
    ORDER BY total_revenue DESC
  `,

  inventoryAnalysis: `
    SELECT c.name AS category_name,
           COUNT(p.id) AS product_count,
           SUM(p.stock_quantity) AS total_units,
           SUM(p.stock_quantity * p.cost) AS inventory_cost,
           SUM(p.stock_quantity * p.price) AS inventory_value,
           SUM(p.stock_quantity * (p.price - p.cost)) AS potential_profit,
           COUNT(CASE WHEN p.stock_quantity < p.min_stock_level THEN 1 END) AS low_stock_items
    FROM categories c
    LEFT JOIN products p ON c.id = p.category_id
    WHERE p.is_active = true
    GROUP BY c.name
    ORDER BY inventory_value DESC
  `,

  profitMarginReport: `
    SELECT p.id, p.name, p.sku,
           c.name AS category_name,
           p.cost, p.price,
           (p.price - p.cost) AS profit_per_unit,
           ROUND(((p.price - p.cost) / p.price) * 100, 2) AS margin_percent,
           p.stock_quantity,
           (p.stock_quantity * (p.price - p.cost)) AS total_potential_profit
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE p.is_active = true AND p.price > 0
    ORDER BY margin_percent DESC
  `,

  salesByCity: `
    SELECT c.city, c.country,
           COUNT(DISTINCT c.id) AS customer_count,
           COUNT(o.id) AS order_count,
           COALESCE(SUM(o.total), 0) AS total_revenue,
           ROUND(COALESCE(COUNT(o.id)::NUMERIC / NULLIF(COUNT(DISTINCT c.id), 0), 0), 2) AS orders_per_customer,
           ROUND(COALESCE(AVG(o.total), 0), 2) AS avg_order_value
    FROM customers c
    LEFT JOIN orders o ON c.id = o.customer_id AND o.status != 'cancelled'
    GROUP BY c.city, c.country
    HAVING COUNT(DISTINCT c.id) > 0
    ORDER BY total_revenue DESC
  `,

  abandonedOrders: `
    SELECT o.id, o.order_number, o.created_at,
           CURRENT_DATE - o.created_at::date AS days_pending,
           o.total,
           c.first_name || ' ' || c.last_name AS customer_name,
           c.email
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.id
    WHERE o.status = 'pending'
      AND o.created_at < CURRENT_DATE - ($1 || ' days')::INTERVAL
    ORDER BY days_pending DESC
  `,

  unsoldProducts: `
    SELECT p.id, p.name, p.sku,
           c.name AS category_name,
           p.price, p.stock_quantity,
           p.created_at,
           CURRENT_DATE - p.created_at::date AS days_in_catalog
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    LEFT JOIN order_items oi ON p.id = oi.product_id
    LEFT JOIN orders o ON oi.order_id = o.id 
            AND o.created_at >= CURRENT_DATE - ($1 || ' days')::INTERVAL
    WHERE p.is_active = true AND o.id IS NULL
    ORDER BY days_in_catalog DESC
  `,

  employeePerformance: `
    SELECT u.id, u.full_name, u.role,
           COUNT(o.id) AS orders_created,
           COALESCE(SUM(o.total), 0) AS total_sales,
           COALESCE(AVG(o.total), 0) AS avg_order_value,
           COUNT(DISTINCT o.customer_id) AS unique_customers
    FROM users u
    LEFT JOIN orders o ON u.id = o.created_by 
         AND o.created_at BETWEEN $1 AND $2 
         AND o.status != 'cancelled'
    WHERE u.role IN ('employee', 'manager')
    GROUP BY u.id, u.full_name, u.role
    ORDER BY total_sales DESC
  `,

  salesTrend: `
    SELECT 'Mes Actual' AS period, COUNT(*) AS order_count, SUM(total) AS total_sales
    FROM orders
    WHERE EXTRACT(MONTH FROM created_at) = $1
      AND EXTRACT(YEAR FROM created_at) = $2
      AND status != 'cancelled'
    
    UNION ALL
    
    SELECT 'Mes Anterior' AS period, COUNT(*) AS order_count, SUM(total) AS total_sales
    FROM orders
    WHERE EXTRACT(MONTH FROM created_at) = CASE WHEN $1 = 1 THEN 12 ELSE $1 - 1 END
      AND EXTRACT(YEAR FROM created_at) = CASE WHEN $1 = 1 THEN $2 - 1 ELSE $2 END
      AND status != 'cancelled'
  `,

  dashboardMetrics: `
    SELECT
      (SELECT COUNT(*) FROM customers WHERE is_active = true) AS total_customers,
      (SELECT COUNT(*) FROM products WHERE is_active = true) AS total_products,
      (SELECT COUNT(*) FROM orders WHERE status != 'cancelled') AS total_orders,
      (SELECT COALESCE(SUM(total), 0) FROM orders WHERE status != 'cancelled') AS total_revenue,
      (SELECT COALESCE(AVG(total), 0) FROM orders WHERE status != 'cancelled') AS avg_order_value,
      (SELECT COUNT(*) FROM products WHERE stock_quantity < min_stock_level) AS products_low_stock
  `,
};

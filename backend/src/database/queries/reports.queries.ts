export const ReportsQueries = {
  dailySales: `
    SELECT 
      DATE(order_date) AS sale_date,
      COUNT(*) AS order_count,
      SUM(total_amount) AS total_sales,
      AVG(total_amount) AS avg_order_value
    FROM orders
    WHERE order_date BETWEEN $1 AND $2 AND status != 'cancelled'
    GROUP BY DATE(order_date)
    ORDER BY sale_date ASC
  `,

  monthlySales: `
    SELECT 
      EXTRACT(MONTH FROM order_date)::INTEGER AS month_num,
      TO_CHAR(order_date, 'Month') AS month_name,
      COUNT(*) AS order_count,
      SUM(total_amount) AS total_sales,
      AVG(total_amount) AS avg_order_value
    FROM orders
    WHERE EXTRACT(YEAR FROM order_date) = $1 AND status != 'cancelled'
    GROUP BY EXTRACT(MONTH FROM order_date), TO_CHAR(order_date, 'Month')
    ORDER BY month_num ASC
  `,

  topSellingProducts: `
    SELECT 
      p.id, p.name, p.sku, p.price,
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
    SELECT 
      c.id,
      c.first_name || ' ' || c.last_name AS customer_name,
      c.email, c.city, c.country,
      COUNT(o.id) AS order_count,
      COALESCE(SUM(o.total_amount), 0) AS lifetime_value,
      COALESCE(AVG(o.total_amount), 0) AS avg_order_value,
      MAX(o.order_date) AS last_order_date
    FROM customers c
    LEFT JOIN orders o ON c.id = o.customer_id AND o.status != 'cancelled'
    GROUP BY c.id, c.first_name, c.last_name, c.email, c.city, c.country
    ORDER BY lifetime_value DESC
    LIMIT $1
  `,

  salesByCategory: `
    SELECT 
      c.id AS category_id,
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
    SELECT 
      c.name AS category_name,
      COUNT(p.id) AS product_count,
      SUM(p.stock_quantity) AS total_units,
      SUM(p.stock_quantity * p.cost) AS inventory_cost,
      SUM(p.stock_quantity * p.price) AS inventory_value,
      SUM(p.stock_quantity * (p.price - p.cost)) AS potential_profit,
      COUNT(CASE WHEN p.stock_quantity < 10 THEN 1 END) AS low_stock_items
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE p.is_active = true
    GROUP BY c.name
    ORDER BY inventory_value DESC
  `,

  profitMarginReport: `
    SELECT 
      p.id, p.name, p.sku,
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
    SELECT 
      c.city, c.country,
      COUNT(DISTINCT c.id) AS customer_count,
      COUNT(o.id) AS order_count,
      COALESCE(SUM(o.total_amount), 0) AS total_revenue,
      ROUND(COALESCE(COUNT(o.id)::NUMERIC / NULLIF(COUNT(DISTINCT c.id), 0), 0), 2) AS orders_per_customer,
      ROUND(COALESCE(AVG(o.total_amount), 0), 2) AS avg_order_value
    FROM customers c
    LEFT JOIN orders o ON c.id = o.customer_id AND o.status != 'cancelled'
    GROUP BY c.city, c.country
    HAVING COUNT(DISTINCT c.id) > 0
    ORDER BY total_revenue DESC
  `,

  abandonedOrders: `
    SELECT 
      o.id, o.order_date,
      CURRENT_DATE - o.order_date::date AS days_pending,
      o.total_amount,
      c.first_name || ' ' || c.last_name AS customer_name,
      c.email
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.id
    WHERE o.status = 'pending' 
      AND o.order_date < CURRENT_DATE - ($1 || ' days')::INTERVAL
    ORDER BY days_pending DESC
  `,

  unsoldProducts: `
    SELECT 
      p.id, p.name, p.sku,
      c.name AS category_name,
      p.price, p.stock_quantity,
      p.created_at,
      CURRENT_DATE - p.created_at::date AS days_in_catalog
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    LEFT JOIN order_items oi ON p.id = oi.product_id
    LEFT JOIN orders o ON oi.order_id = o.id 
      AND o.order_date >= CURRENT_DATE - ($1 || ' days')::INTERVAL
    WHERE p.is_active = true AND o.id IS NULL
    ORDER BY days_in_catalog DESC
  `,

  employeePerformance: `
    SELECT 
      u.id, u.full_name, u.role,
      0 AS orders_created,
      0 AS total_sales,
      0 AS avg_order_value,
      0 AS unique_customers
    FROM users u
    WHERE u.role IN ('employee', 'manager')
    ORDER BY u.full_name
  `,

  salesTrend: `
    SELECT 'Mes Actual' AS period, COUNT(*) AS order_count, COALESCE(SUM(total_amount), 0) AS total_sales
    FROM orders
    WHERE EXTRACT(MONTH FROM order_date) = $1
      AND EXTRACT(YEAR FROM order_date) = $2
      AND status != 'cancelled'
    UNION ALL
    SELECT 'Mes Anterior' AS period, COUNT(*) AS order_count, COALESCE(SUM(total_amount), 0) AS total_sales
    FROM orders
    WHERE EXTRACT(MONTH FROM order_date) = CASE WHEN $1 = 1 THEN 12 ELSE $1 - 1 END
      AND EXTRACT(YEAR FROM order_date) = CASE WHEN $1 = 1 THEN $2 - 1 ELSE $2 END
      AND status != 'cancelled'
  `,

  dashboardMetrics: `
    SELECT 
      (SELECT COUNT(*) FROM customers) AS total_customers,
      (SELECT COUNT(*) FROM products WHERE is_active = true) AS total_products,
      (SELECT COUNT(*) FROM orders WHERE status != 'cancelled') AS total_orders,
      (SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE status != 'cancelled') AS total_revenue,
      (SELECT COALESCE(AVG(total_amount), 0) FROM orders WHERE status != 'cancelled') AS avg_order_value,
      (SELECT COUNT(*) FROM products WHERE stock_quantity < 10) AS products_low_stock
  `,
};
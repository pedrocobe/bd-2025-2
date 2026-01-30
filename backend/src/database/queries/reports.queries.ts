export const ReportsQueries = {
  dailySales: `
    SELECT DATE(o.created_at) AS date,
           SUM(o.total) AS total_sales
    FROM orders o
    WHERE o.status != 'cancelled'
      AND o.created_at BETWEEN $1 AND $2
    GROUP BY date
    ORDER BY date DESC
  `,

  monthlySales: `
    SELECT EXTRACT(MONTH FROM o.created_at) AS month,
           SUM(o.total) AS total_sales
    FROM orders o
    WHERE o.status != 'cancelled'
      AND EXTRACT(YEAR FROM o.created_at) = $1
    GROUP BY month
    ORDER BY month
  `,

  topSellingProducts: `
    SELECT p.id,
           p.name,
           p.sku,
           cat.name AS category_name,
           SUM(oi.quantity) AS total_quantity_sold,
           SUM(oi.quantity * oi.price) AS total_revenue,
           COUNT(DISTINCT o.id) AS total_orders
    FROM products p
    JOIN order_items oi ON p.id = oi.product_id
    JOIN orders o ON oi.order_id = o.id
    JOIN categories cat ON p.category_id = cat.id
    WHERE o.status != 'cancelled'
    GROUP BY p.id, p.name, p.sku, cat.name
    ORDER BY total_quantity_sold DESC
    LIMIT $1
  `,

  topCustomers: `
    SELECT c.id,
           c.name AS customer_name,
           c.email,
           COUNT(o.id) AS total_orders,
           SUM(o.total) AS total_spent
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    WHERE o.status != 'cancelled'
    GROUP BY c.id, c.name, c.email
    ORDER BY total_spent DESC
    LIMIT $1
  `,

  salesByCategory: `
    SELECT cat.name AS category_name,
           SUM(oi.quantity * oi.price) AS total_sales
    FROM order_items oi
    JOIN products p ON oi.product_id = p.id
    JOIN categories cat ON p.category_id = cat.id
    JOIN orders o ON oi.order_id = o.id
    WHERE o.status != 'cancelled'
    GROUP BY cat.name
    ORDER BY total_sales DESC
  `,

  inventoryAnalysis: `
    SELECT cat.name AS category_name,
           COUNT(p.id) AS total_products,
           SUM(p.stock_quantity) AS total_units,
           SUM(p.stock_quantity * p.cost) AS inventory_value
    FROM products p
    LEFT JOIN categories cat ON p.category_id = cat.id
    WHERE p.active = true
    GROUP BY cat.name
    ORDER BY inventory_value DESC
  `,

  profitMarginReport: `
    SELECT id,
           name,
           price,
           cost,
           (price - cost) AS profit,
           ROUND(((price - cost) / price) * 100, 2) AS profit_margin_percent
    FROM products
    WHERE active = true AND price > 0
    ORDER BY profit_margin_percent DESC
  `,

  salesByCity: `
    SELECT c.phone, COUNT(o.id) AS total_orders, SUM(o.total) AS total_spent
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    WHERE o.status != 'cancelled'
    GROUP BY c.phone
    ORDER BY total_spent DESC
  `,

  abandonedOrders: `
    SELECT id, customer_id, created_at, total
    FROM orders
    WHERE status = 'pending'
      AND created_at < CURRENT_DATE - ($1 || ' days')::interval
    ORDER BY created_at
  `,

  unsoldProducts: `
    SELECT p.id, p.name, p.sku, p.price, p.stock_quantity
    FROM products p
    LEFT JOIN order_items oi ON p.id = oi.product_id
    WHERE oi.id IS NULL
      AND p.created_at < CURRENT_DATE - ($1 || ' days')::interval
      AND p.active = true
    ORDER BY p.created_at DESC
  `,

  employeePerformance: `
    SELECT u.id, u.username,
           COUNT(o.id) AS orders_managed,
           SUM(o.total) AS total_sold
    FROM users u
    JOIN orders o ON o.customer_id = u.id
    WHERE o.created_at BETWEEN $1 AND $2
    GROUP BY u.id, u.username
    ORDER BY total_sold DESC
  `,

  salesTrend: `
    SELECT EXTRACT(DAY FROM o.created_at) AS day,
           SUM(o.total) AS total_sales
    FROM orders o
    WHERE EXTRACT(MONTH FROM o.created_at) = $1
      AND EXTRACT(YEAR FROM o.created_at) = $2
      AND o.status != 'cancelled'
    GROUP BY day
    ORDER BY day
  `,

  dashboardMetrics: `
    SELECT
      (SELECT COUNT(*) FROM products WHERE active = true) AS total_products,
      (SELECT COUNT(*) FROM customers) AS total_customers,
      (SELECT COUNT(*) FROM orders WHERE status != 'cancelled') AS total_orders,
      (SELECT SUM(total) FROM orders WHERE status != 'cancelled') AS total_revenue
  `
};

export const CustomersQueries = {
  findAll: `
    SELECT *
    FROM customers
    ORDER BY created_at DESC
  `,

  findById: `
    SELECT *
    FROM customers
    WHERE id = $1
  `,

  findByEmail: `
    SELECT *
    FROM customers
    WHERE email = $1
  `,

  create: `
    INSERT INTO customers (first_name, last_name, email, phone, address, city, country)
    VALUES ($1, $2, $3, $4, $5, $6, $7)
    RETURNING *
  `,

  update: `
    UPDATE customers
    SET first_name = $2, last_name = $3, email = $4, phone = $5,
        address = $6, city = $7, country = $8, updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING *
  `,

  delete: `
    DELETE FROM customers
    WHERE id = $1
    RETURNING id
  `,

  updateStatistics: `
    UPDATE customers
    SET updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id
  `,

  search: `
    SELECT id, first_name, last_name, email, phone, city
    FROM customers
    WHERE first_name ILIKE $1 OR last_name ILIKE $1 OR email ILIKE $1
    ORDER BY last_name ASC
  `,

  findTopCustomers: `
    SELECT 
      c.id, c.first_name, c.last_name, c.email,
      (c.first_name || ' ' || c.last_name) AS full_name,
      COUNT(o.id) AS order_count,
      COALESCE(SUM(o.total_amount), 0) AS total_spent
    FROM customers c
    LEFT JOIN orders o ON c.id = o.customer_id AND o.status != 'cancelled'
    GROUP BY c.id, c.first_name, c.last_name, c.email
    ORDER BY total_spent DESC
    LIMIT $1
  `,

  groupByCity: `
    SELECT
      city,
      country,
      COUNT(*) AS customer_count,
      COALESCE(SUM((
        SELECT SUM(total_amount) 
        FROM orders 
        WHERE customer_id = customers.id AND status != 'cancelled'
      )), 0) AS total_revenue
    FROM customers
    GROUP BY city, country
    ORDER BY total_revenue DESC
  `,

  findWithRecentOrders: `
    SELECT
      DISTINCT c.id, c.first_name, c.last_name, c.email,
      COUNT(o.id) AS recent_orders,
      MAX(o.order_date) AS last_order_date
    FROM customers c
    INNER JOIN orders o ON c.id = o.customer_id
    WHERE o.order_date >= CURRENT_DATE - ($1 || ' days')::INTERVAL
    GROUP BY c.id, c.first_name, c.last_name, c.email
    ORDER BY last_order_date DESC
  `,

  findInactive: `
    SELECT
      c.id, c.first_name, c.last_name, c.email,
      MAX(o.order_date) AS last_order_date,
      CURRENT_DATE - MAX(o.order_date)::date AS days_since_last_order
    FROM customers c
    LEFT JOIN orders o ON c.id = o.customer_id
    GROUP BY c.id, c.first_name, c.last_name, c.email
    HAVING MAX(o.order_date) < CURRENT_DATE - ($1 || ' days')::INTERVAL OR MAX(o.order_date) IS NULL
    ORDER BY days_since_last_order DESC NULLS LAST
  `,
};
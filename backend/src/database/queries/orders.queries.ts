export const OrdersQueries = {
  findAll: `
    SELECT 
      o.*,
      (c.first_name || ' ' || c.last_name) AS customer_name,
      c.email AS customer_email
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.id
    ORDER BY o.created_at DESC
  `,

  findById: `
    SELECT 
      o.*,
      (c.first_name || ' ' || c.last_name) AS customer_name,
      c.email AS customer_email
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.id
    WHERE o.id = $1
  `,

  findByOrderNumber: `
    SELECT 
      o.*,
      (c.first_name || ' ' || c.last_name) AS customer_name,
      c.email AS customer_email
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.id
    WHERE o.id = $1
  `,

  findByCustomer: `
    SELECT *
    FROM orders
    WHERE customer_id = $1
    ORDER BY created_at DESC
  `,

  findByStatus: `
    SELECT 
      o.*,
      (c.first_name || ' ' || c.last_name) AS customer_name,
      c.email AS customer_email
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.id
    WHERE o.status = $1
    ORDER BY o.created_at DESC
  `,

  create: `
    INSERT INTO orders (customer_id, shipping_address, notes)
    VALUES ($1, $2, $3)
    RETURNING *
  `,

  updateStatus: `
    UPDATE orders
    SET status = $2, updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, status, updated_at
  `,

  updateTotals: `
    UPDATE orders
    SET total_amount = $2, updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, total_amount, updated_at
  `,

  cancel: `
    UPDATE orders
    SET status = 'cancelled', updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, status
  `,

  delete: `
    DELETE FROM orders
    WHERE id = $1
    RETURNING id
  `,

  findOrderItems: `
    SELECT
      oi.id, oi.order_id, oi.product_id, oi.quantity,
      oi.unit_price, oi.subtotal,
      p.name AS product_name, p.sku
    FROM order_items oi
    INNER JOIN products p ON oi.product_id = p.id
    WHERE oi.order_id = $1
    ORDER BY oi.id ASC
  `,

  addOrderItem: `
    INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal)
    VALUES ($1, $2, $3, $4, $3 * $4)
    RETURNING *
  `,

  updateOrderItem: `
    UPDATE order_items
    SET quantity = $2, subtotal = quantity * unit_price
    WHERE id = $1
    RETURNING id, order_id, product_id, quantity, subtotal
  `,

  deleteOrderItem: `
    DELETE FROM order_items
    WHERE id = $1
    RETURNING id
  `,

  getOrderSummary: `
    SELECT 
      o.*,
      (c.first_name || ' ' || c.last_name) AS customer_name,
      c.email AS customer_email,
      c.phone AS customer_phone,
      c.address AS customer_address
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.id
    WHERE o.id = $1
  `,

  calculateItemsTotal: `
    SELECT 
      order_id,
      SUM(subtotal) AS total_items
    FROM order_items
    WHERE order_id = $1
    GROUP BY order_id
  `,

  findByDateRange: `
    SELECT 
      o.*,
      (c.first_name || ' ' || c.last_name) AS customer_name,
      c.email AS customer_email
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.id
    WHERE o.order_date BETWEEN $1 AND $2
    ORDER BY o.created_at DESC
  `,

  countByStatus: `
    SELECT
      status,
      COUNT(*) AS order_count,
      SUM(total_amount) AS total_amount
    FROM orders
    GROUP BY status
    ORDER BY order_count DESC
  `,

  findLargeOrders: `
    SELECT 
      o.*,
      (c.first_name || ' ' || c.last_name) AS customer_name,
      c.email AS customer_email
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.id
    WHERE o.total_amount >= $1 AND o.status != 'cancelled'
    ORDER BY o.total_amount DESC
  `,
};
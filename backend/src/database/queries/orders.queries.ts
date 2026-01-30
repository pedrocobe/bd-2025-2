/**
 * =====================================================
 * QUERIES DE PEDIDOS - orders.queries.ts
 * =====================================================
 */

export const OrdersQueries = {
  /**
   * TODO: Obtener todos los pedidos
   */
  findAll: `
    SELECT 
      o.*, 
      (c.first_name || ' ' || c.last_name) AS customer_name,
      c.email AS customer_email
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.id
    ORDER BY o.created_at DESC
  `,

  /**
   * TODO: Obtener un pedido por ID
   */
  findById: `
    SELECT 
      o.*, 
      (c.first_name || ' ' || c.last_name) AS customer_name,
      c.email AS customer_email
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.id
    WHERE o.id = $1
  `,

  /**
   * TODO: Obtener pedido por número de orden
   */
  findByOrderNumber: `
    SELECT 
      o.*, 
      (c.first_name || ' ' || c.last_name) AS customer_name,
      c.email AS customer_email
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.id
    WHERE o.order_number = $1
  `,

  /**
   * TODO: Obtener pedidos de un cliente
   */
  findByCustomer: `
    SELECT * FROM orders 
    WHERE customer_id = $1 
    ORDER BY created_at DESC
  `,

  /**
   * TODO: Obtener pedidos por estado
   */
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

  /**
   * TODO: Crear un pedido (sin items)
   */
  create: `
    INSERT INTO orders (
      customer_id, order_number, shipping_address, 
      shipping_city, shipping_country, shipping_cost
    )
    VALUES ($1, $2, $3, $4, $5, $6)
    RETURNING *
  `,

  /**
   * TODO: Actualizar estado del pedido
   */
  updateStatus: `
    UPDATE orders 
    SET 
      status = $2, 
      shipped_at = CASE WHEN $2 = 'shipped' THEN CURRENT_TIMESTAMP ELSE shipped_at END,
      delivered_at = CASE WHEN $2 = 'delivered' THEN CURRENT_TIMESTAMP ELSE delivered_at END,
      updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, order_number, status, updated_at, shipped_at, delivered_at
  `,

  /**
   * TODO: Actualizar totales del pedido
   */
  updateTotals: `
    UPDATE orders
    SET subtotal = $2, tax = $3, total = $4, updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, subtotal, tax, total, updated_at
  `,

  /**
   * TODO: Cancelar un pedido
   */
  cancel: `
    UPDATE orders
    SET status = 'cancelled', updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, order_number, status
  `,

  /**
   * TODO: Eliminar un pedido
   */
  delete: `
    DELETE FROM orders 
    WHERE id = $1 
    RETURNING id
  `,

  /**
   * TODO: Obtener items de un pedido
   */
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

  /**
   * TODO: Agregar item a un pedido
   */
  addOrderItem: `
    INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal)
    VALUES ($1, $2, $3, $4, ($3 * $4))
    RETURNING *
  `,

  /**
   * TODO: Actualizar cantidad de un item
   */
  updateOrderItem: `
    UPDATE order_items
    SET quantity = $2, subtotal = ($2 * unit_price)
    WHERE id = $1
    RETURNING id, order_id, product_id, quantity, subtotal
  `,

  /**
   * TODO: Eliminar item de un pedido
   */
  deleteOrderItem: `
    DELETE FROM order_items 
    WHERE id = $1 
    RETURNING id
  `,

  /**
   * TODO: Obtener resumen de pedido
   */
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

  /**
   * TODO: Calcular total de items de un pedido
   */
  calculateItemsTotal: `
    SELECT order_id, SUM(subtotal) AS total_items
    FROM order_items
    WHERE order_id = $1
    GROUP BY order_id
  `,

  /**
   * TODO: Obtener pedidos en rango de fechas
   */
  findByDateRange: `
    SELECT 
      o.*, 
      (c.first_name || ' ' || c.last_name) AS customer_name,
      c.email AS customer_email
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.id
    WHERE o.created_at BETWEEN $1 AND $2
    ORDER BY o.created_at DESC
  `,

  /**
   * TODO: Contar pedidos por estado
   */
  countByStatus: `
    SELECT 
      status, 
      COUNT(*) AS order_count, 
      SUM(total) AS total_amount
    FROM orders
    GROUP BY status
    ORDER BY order_count DESC
  `,

  /**
   * TODO: Obtener pedidos grandes
   */
  findLargeOrders: `
    SELECT 
      o.*, 
      (c.first_name || ' ' || c.last_name) AS customer_name,
      c.email AS customer_email
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.id
    WHERE o.total >= $1 AND o.status != 'cancelled'
    ORDER BY o.total DESC
  `,
};
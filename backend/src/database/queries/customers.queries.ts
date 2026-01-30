/**
 * =====================================================
 * QUERIES DE CLIENTES - customers.queries.ts
 * =====================================================
 */

export const CustomersQueries = {
  /**
   * TODO: Obtener todos los clientes
   */
  findAll: `
    SELECT * FROM customers 
    ORDER BY created_at DESC
  `,

  /**
   * TODO: Obtener un cliente por ID
   */
  findById: `
    SELECT * FROM customers 
    WHERE id = $1
  `,

  /**
   * TODO: Obtener cliente por email
   */
  findByEmail: `
    SELECT * FROM customers 
    WHERE email = $1
  `,

  /**
   * TODO: Crear un cliente
   */
  create: `
    INSERT INTO customers (
      first_name, last_name, email, phone, 
      address, city, country, postal_code
    )
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
    RETURNING *
  `,

  /**
   * TODO: Actualizar un cliente
   */
  update: `
    UPDATE customers
    SET 
      first_name = $2, 
      last_name = $3, 
      email = $4, 
      phone = $5,
      address = $6, 
      city = $7, 
      country = $8, 
      postal_code = $9, 
      is_active = $10,
      updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING *
  `,

  /**
   * TODO: Eliminar un cliente
   */
  delete: `
    DELETE FROM customers 
    WHERE id = $1 
    RETURNING id
  `,

  /**
   * TODO: Actualizar estadísticas del cliente
   */
  updateStatistics: `
    UPDATE customers c
    SET 
      total_spent = COALESCE((
        SELECT SUM(total) 
        FROM orders o 
        WHERE o.customer_id = c.id AND o.status != 'cancelled'
      ), 0),
      order_count = (
        SELECT COUNT(*) 
        FROM orders o 
        WHERE o.customer_id = c.id AND o.status != 'cancelled'
      )
    WHERE id = $1
    RETURNING id, total_spent, order_count
  `,

  /**
   * TODO: Buscar clientes
   */
  search: `
    SELECT id, first_name, last_name, email, phone, city, total_spent, order_count
    FROM customers
    WHERE 
      first_name ILIKE $1 OR 
      last_name ILIKE $1 OR 
      email ILIKE $1
    ORDER BY last_name ASC
  `,

  /**
   * TODO: Obtener clientes con más compras (Top Customers)
   */
  findTopCustomers: `
    SELECT 
      id, first_name, last_name, email, 
      total_spent, order_count,
      (first_name || ' ' || last_name) AS full_name
    FROM customers
    WHERE is_active = true
    ORDER BY total_spent DESC
    LIMIT $1
  `,

  /**
   * TODO: Obtener clientes por ciudad
   */
  groupByCity: `
    SELECT 
      city, 
      country, 
      COUNT(*) AS customer_count, 
      SUM(total_spent) AS total_revenue
    FROM customers
    WHERE is_active = true
    GROUP BY city, country
    ORDER BY total_revenue DESC
  `,

  /**
   * TODO: Obtener clientes con pedidos recientes
   */
  findWithRecentOrders: `
    SELECT 
      c.id, c.first_name, c.last_name, c.email,
      COUNT(o.id) AS recent_orders,
      MAX(o.created_at) AS last_order_date
    FROM customers c
    INNER JOIN orders o ON c.id = o.customer_id
    WHERE o.created_at >= CURRENT_DATE - ($1 || ' days')::INTERVAL
    GROUP BY c.id, c.first_name, c.last_name, c.email
    ORDER BY last_order_date DESC
  `,

  /**
   * TODO: Obtener clientes inactivos
   */
  findInactive: `
    SELECT 
      c.id, c.first_name, c.last_name, c.email,
      MAX(o.created_at) AS last_order_date,
      (CURRENT_DATE - MAX(o.created_at)::date) AS days_since_last_order
    FROM customers c
    LEFT JOIN orders o ON c.id = o.customer_id
    WHERE c.is_active = true
    GROUP BY c.id, c.first_name, c.last_name, c.email
    HAVING MAX(o.created_at) < CURRENT_DATE - ($1 || ' days')::INTERVAL 
       OR MAX(o.created_at) IS NULL
    ORDER BY days_since_last_order DESC NULLS FIRST
  `,
};
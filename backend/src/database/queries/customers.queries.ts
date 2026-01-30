/**
 * =====================================================
 * QUERIES DE CLIENTES - PARA COMPLETAR
 * =====================================================
 */

export const CustomersQueries = {
  /**
   * TODO: Obtener todos los clientes
   * Objetivo: Consultar todos los clientes activos
   * Tablas: customers
   * Retorna: Todos los campos del cliente
   * Orden: Por created_at descendente
   */
  findAll: `
    SELECT 
      id, 
      user_id,
      first_name, 
      last_name, 
      email, 
      phone, 
      address, 
      city, 
      country,
      total_orders,
      total_spent,
      last_purchase_date,
      created_at,
      updated_at
    FROM customers
    ORDER BY created_at DESC
  `,

  /**
   * TODO: Obtener un cliente por ID
   * Objetivo: Consultar un cliente específico
   * Parámetros: $1 (id)
   * Tablas: customers
   * Retorna: Todos los campos del cliente
   */
  findById: `
    SELECT 
      id, 
      user_id,
      first_name, 
      last_name, 
      email, 
      phone, 
      address, 
      city, 
      country,
      total_orders,
      total_spent,
      last_purchase_date,
      created_at,
      updated_at
    FROM customers
    WHERE id = $1
  `,

  /**
   * TODO: Obtener cliente por email
   * Objetivo: Buscar cliente por su correo electrónico
   * Parámetros: $1 (email)
   * Tablas: customers
   * Retorna: Todos los campos del cliente
   */
  findByEmail: `
    SELECT 
      id, 
      user_id,
      first_name, 
      last_name, 
      email, 
      phone, 
      address, 
      city, 
      country,
      total_orders,
      total_spent,
      last_purchase_date,
      created_at,
      updated_at
    FROM customers
    WHERE email = $1
  `,

  /**
   * TODO: Crear un cliente
   * Objetivo: Insertar un nuevo cliente
   * Parámetros: $1 (first_name), $2 (last_name), $3 (email), $4 (phone),
   *             $5 (address), $6 (city), $7 (country)
   * Tablas: customers
   * Retorna: Todos los campos del cliente insertado
   */
  create: `
    INSERT INTO customers (
      first_name, 
      last_name, 
      email, 
      phone, 
      address, 
      city, 
      country
    ) VALUES ($1, $2, $3, $4, $5, $6, $7)
    RETURNING 
      id, 
      user_id,
      first_name, 
      last_name, 
      email, 
      phone, 
      address, 
      city, 
      country,
      total_orders,
      total_spent,
      last_purchase_date,
      created_at,
      updated_at
  `,

  /**
   * TODO: Actualizar un cliente
   * Objetivo: Modificar los datos de un cliente
   * Parámetros: $1 (id), $2 (first_name), $3 (last_name), $4 (email), $5 (phone),
   *             $6 (address), $7 (city), $8 (country), $9 (is_active)
   * Tablas: customers
   * Retorna: Todos los campos del cliente actualizado
   */
  update: `
    UPDATE customers
    SET 
      first_name = COALESCE($2, first_name),
      last_name = COALESCE($3, last_name),
      email = COALESCE($4, email),
      phone = COALESCE($5, phone),
      address = COALESCE($6, address),
      city = COALESCE($7, city),
      country = COALESCE($8, country),
      updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING 
      id, 
      user_id,
      first_name, 
      last_name, 
      email, 
      phone, 
      address, 
      city, 
      country,
      total_orders,
      total_spent,
      last_purchase_date,
      created_at,
      updated_at
  `,

  /**
   * TODO: Eliminar un cliente
   * Objetivo: Eliminar un cliente (solo si no tiene pedidos)
   * Parámetros: $1 (id)
   * Tablas: customers
   * Retorna: id
   */
  delete: `
    DELETE FROM customers
    WHERE id = $1
      AND NOT EXISTS (
        SELECT 1 FROM orders 
        WHERE customer_id = $1
      )
    RETURNING id
  `,

  /**
   * TODO: Actualizar estadísticas del cliente
   * Objetivo: Actualizar total_spent y order_count basado en pedidos reales
   * Parámetros: $1 (id)
   * Tablas: customers, orders
   * Retorna: id, total_spent, order_count
   * Nota: Calcular desde orders donde status != 'cancelled'
   */
  updateStatistics: `
    UPDATE customers c
    SET 
      total_spent = (
        SELECT COALESCE(SUM(o.total_amount), 0)
        FROM orders o
        WHERE o.customer_id = c.id
          AND o.status != 'cancelled'
      ),
      order_count = (
        SELECT COUNT(*)
        FROM orders o
        WHERE o.customer_id = c.id
          AND o.status != 'cancelled'
      ),
      last_purchase_date = (
        SELECT MAX(o.order_date)
        FROM orders o
        WHERE o.customer_id = c.id
          AND o.status != 'cancelled'
      ),
      updated_at = CURRENT_TIMESTAMP
    WHERE c.id = $1
    RETURNING 
      c.id,
      c.total_spent,
      c.order_count
  `,

  /**
   * TODO: Buscar clientes
   * Objetivo: Buscar clientes por nombre o email
   * Parámetros: $1 (search_term)
   * Tablas: customers
   * Retorna: id, first_name, last_name, email, phone, city, total_spent, order_count
   * Filtro: first_name ILIKE $1 OR last_name ILIKE $1 OR email ILIKE $1
   * Orden: Por last_name ascendente
   */
  search: `
    SELECT 
      id, 
      first_name, 
      last_name, 
      email, 
      phone, 
      city,
      total_spent,
      order_count
    FROM customers
    WHERE 
      first_name ILIKE '%' || $1 || '%'
      OR last_name ILIKE '%' || $1 || '%'
      OR email ILIKE '%' || $1 || '%'
    ORDER BY last_name ASC
  `,

  /**
   * TODO: Obtener clientes con más compras (Top Customers)
   * Objetivo: Consultar los clientes que más han gastado
   * Parámetros: $1 (limit)
   * Tablas: customers
   * Retorna: 
   *   id, first_name, last_name, email, 
   *   total_spent, order_count,
   *   (first_name || ' ' || last_name) AS full_name
   * Filtro: total_spent > 0
   * Orden: Por total_spent descendente
   * Límite: $1
   */
  findTopCustomers: `
    SELECT 
      id, 
      first_name, 
      last_name, 
      email, 
      total_spent, 
      order_count,
      (first_name || ' ' || last_name) AS full_name
    FROM customers
    WHERE total_spent > 0
    ORDER BY total_spent DESC
    LIMIT $1
  `,

  /**
   * TODO: Obtener clientes por ciudad
   * Objetivo: Agrupar clientes por ciudad con estadísticas
   * Parámetros: ninguno
   * Tablas: customers
   * Retorna:
   *   city,
   *   country,
   *   COUNT(*) AS customer_count,
   *   SUM(total_spent) AS total_revenue
   * Filtro: city IS NOT NULL
   * Agrupación: Por city, country
   * Orden: Por total_revenue descendente
   */
  groupByCity: `
    SELECT 
      city,
      country,
      COUNT(*) AS customer_count,
      SUM(total_spent) AS total_revenue
    FROM customers
    WHERE city IS NOT NULL
    GROUP BY city, country
    ORDER BY total_revenue DESC
  `,

  /**
   * TODO: Obtener clientes con pedidos recientes
   * Objetivo: Consultar clientes que han realizado pedidos en los últimos N días
   * Parámetros: $1 (days - número de días hacia atrás)
   * Tablas: customers, orders
   * Retorna:
   *   DISTINCT c.id, c.first_name, c.last_name, c.email,
   *   COUNT(o.id) AS recent_orders,
   *   MAX(o.order_date) AS last_order_date
   * Join: INNER JOIN orders
   * Filtro: o.order_date >= CURRENT_DATE - INTERVAL '$1 days'
   * Agrupación: Por c.id, c.first_name, c.last_name, c.email
   * Orden: Por last_order_date descendente
   */
  findWithRecentOrders: `
    SELECT DISTINCT
      c.id, 
      c.first_name, 
      c.last_name, 
      c.email,
      COUNT(o.id) AS recent_orders,
      MAX(o.order_date) AS last_order_date
    FROM customers c
    INNER JOIN orders o ON c.id = o.customer_id
    WHERE o.order_date >= CURRENT_DATE - ($1 || ' days')::INTERVAL
      AND o.status != 'cancelled'
    GROUP BY c.id, c.first_name, c.last_name, c.email
    ORDER BY last_order_date DESC
  `,

  /**
   * TODO: Obtener clientes inactivos
   * Objetivo: Encontrar clientes sin pedidos en los últimos N días
   * Parámetros: $1 (days)
   * Tablas: customers, orders
   * Retorna:
   *   c.id, c.first_name, c.last_name, c.email,
   *   MAX(o.order_date) AS last_order_date,
   *   CURRENT_DATE - MAX(o.order_date)::date AS days_since_last_order
   * Join: LEFT JOIN orders
   * Filtro: 
   *   - c.total_orders > 0  -- Al menos ha comprado una vez
   *   - (MAX(o.order_date) IS NULL OR MAX(o.order_date) < CURRENT_DATE - ($1 || ' days')::INTERVAL)
   * Agrupación: Por c.id, c.first_name, c.last_name, c.email
   * Orden: Por days_since_last_order DESC NULLS FIRST
   */
  findInactive: `
    SELECT 
      c.id, 
      c.first_name, 
      c.last_name, 
      c.email,
      MAX(o.order_date) AS last_order_date,
      EXTRACT(DAY FROM (CURRENT_DATE - MAX(o.order_date))) AS days_since_last_order
    FROM customers c
    LEFT JOIN orders o ON c.id = o.customer_id AND o.status != 'cancelled'
    WHERE c.total_orders > 0
    GROUP BY c.id, c.first_name, c.last_name, c.email
    HAVING 
      MAX(o.order_date) IS NULL 
      OR MAX(o.order_date) < CURRENT_DATE - ($1 || ' days')::INTERVAL
    ORDER BY days_since_last_order DESC NULLS FIRST
  `,
};
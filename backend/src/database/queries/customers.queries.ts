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
    SELECT *
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
    SELECT *
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
    SELECT *
    FROM customers
    WHERE email = $1
  `,

  /**
   * TODO: Crear un cliente
   * Objetivo: Insertar un nuevo cliente
   * Parámetros: $1 (first_name), $2 (last_name), $3 (email), $4 (phone),
   *             $5 (address), $6 (city), $7 (country), $8 (postal_code)
   * Tablas: customers
   * Retorna: Todos los campos del cliente insertado
   */
  create: `
    INSERT INTO customers (first_name, last_name, email, phone, address, city, country, postal_code)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
    RETURNING *
  `,

  /**
   * TODO: Actualizar un cliente
   * Objetivo: Modificar los datos de un cliente
   * Parámetros: $1 (id), $2 (first_name), $3 (last_name), $4 (email), $5 (phone),
   *             $6 (address), $7 (city), $8 (country), $9 (postal_code), $10 (is_active)
   * Tablas: customers
   * Retorna: Todos los campos del cliente actualizado
   */
  update: `
    UPDATE customers
    SET first_name = $2, last_name = $3, email = $4, phone = $5,
        address = $6, city = $7, country = $8, postal_code = $9, is_active = $10,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING *
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
    UPDATE customers
    SET total_spent = (
          SELECT COALESCE(SUM(total), 0)
          FROM orders
          WHERE customer_id = $1 AND status != 'cancelled'
        ),
        order_count = (
          SELECT COUNT(*)
          FROM orders
          WHERE customer_id = $1 AND status != 'cancelled'
        ),
        updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, total_spent, order_count
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
    SELECT id, first_name, last_name, email, phone, city, total_spent, order_count
    FROM customers
    WHERE first_name ILIKE $1 OR last_name ILIKE $1 OR email ILIKE $1
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
   * Filtro: is_active = true
   * Orden: Por total_spent descendente
   * Límite: $1
   */
  findTopCustomers: `
    SELECT id, first_name, last_name, email,
           total_spent, order_count,
           (first_name || ' ' || last_name) AS full_name
    FROM customers
    WHERE is_active = true
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
   * Filtro: is_active = true
   * Agrupación: Por city, country
   * Orden: Por total_revenue descendente
   */
  groupByCity: `
    SELECT city,
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
   * Objetivo: Consultar clientes que han realizado pedidos en los últimos N días
   * Parámetros: $1 (days - número de días hacia atrás)
   * Tablas: customers, orders
   * Retorna:
   *   DISTINCT c.id, c.first_name, c.last_name, c.email,
   *   COUNT(o.id) AS recent_orders,
   *   MAX(o.created_at) AS last_order_date
   * Join: INNER JOIN orders
   * Filtro: o.created_at >= CURRENT_DATE - INTERVAL '$1 days'
   * Agrupación: Por c.id, c.first_name, c.last_name, c.email
   * Orden: Por last_order_date descendente
   */
  findWithRecentOrders: `
    SELECT c.id, c.first_name, c.last_name, c.email,
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
   * Objetivo: Encontrar clientes sin pedidos en los últimos N días
   * Parámetros: $1 (days)
   * Tablas: customers, orders
   * Retorna:
   *   c.id, c.first_name, c.last_name, c.email,
   *   MAX(o.created_at) AS last_order_date,
   *   CURRENT_DATE - MAX(o.created_at)::date AS days_since_last_order
   * Join: LEFT JOIN orders
   * Filtro: 
   *   - c.is_active = true
   *   - MAX(o.created_at) < CURRENT_DATE - $1 OR no orders
   * Agrupación: Por c.id, c.first_name, c.last_name, c.email
   * Orden: Por days_since_last_order descendente
   */
  findInactive: `
    SELECT c.id, c.first_name, c.last_name, c.email,
           MAX(o.created_at) AS last_order_date,
           CURRENT_DATE - MAX(o.created_at)::date AS days_since_last_order
    FROM customers c
    LEFT JOIN orders o ON c.id = o.customer_id
    WHERE c.is_active = true
    GROUP BY c.id, c.first_name, c.last_name, c.email
    HAVING MAX(o.created_at) < CURRENT_DATE - ($1 || ' days')::INTERVAL OR MAX(o.created_at) IS NULL
    ORDER BY days_since_last_order DESC
  `,
};

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
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Obtener un cliente por ID
   * Objetivo: Consultar un cliente específico
   * Parámetros: $1 (id)
   * Tablas: customers
   * Retorna: Todos los campos del cliente
   */
  findById: `
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Obtener cliente por email
   * Objetivo: Buscar cliente por su correo electrónico
   * Parámetros: $1 (email)
   * Tablas: customers
   * Retorna: Todos los campos del cliente
   */
  findByEmail: `
    -- TODO: Escribe tu consulta aquí
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
    -- TODO: Escribe tu consulta aquí
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
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Eliminar un cliente
   * Objetivo: Eliminar un cliente (solo si no tiene pedidos)
   * Parámetros: $1 (id)
   * Tablas: customers
   * Retorna: id
   */
  delete: `
    -- TODO: Escribe tu consulta aquí
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
    -- TODO: Escribe tu consulta aquí (AVANZADO)
    -- Pista: Usa subconsultas o UPDATE con JOIN
    -- UPDATE customers SET 
    --   total_spent = (SELECT SUM(...) FROM orders WHERE ...),
    --   order_count = (SELECT COUNT(...) FROM orders WHERE ...)
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
    -- TODO: Escribe tu consulta aquí
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
    -- TODO: Escribe tu consulta aquí
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
    -- TODO: Escribe tu consulta aquí
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
    -- TODO: Escribe tu consulta aquí (AVANZADO)
    -- Pista: Usa CURRENT_DATE - INTERVAL
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
    -- TODO: Escribe tu consulta aquí (AVANZADO)
  `,
};

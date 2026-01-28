/**
 * =====================================================
 * QUERIES DE PEDIDOS - PARA COMPLETAR
 * =====================================================
 * Nota: Muchas operaciones de pedidos requieren TRANSACCIONES
 * =====================================================
 */

export const OrdersQueries = {
  /**
   * TODO: Obtener todos los pedidos
   * Objetivo: Consultar todos los pedidos con información del cliente
   * Tablas: orders, customers
   * Retorna:
   *   o.*, 
   *   (c.first_name || ' ' || c.last_name) AS customer_name,
   *   c.email AS customer_email
   * Join: INNER JOIN customers
   * Orden: Por o.created_at descendente
   */
  findAll: `
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Obtener un pedido por ID
   * Objetivo: Consultar un pedido específico con información del cliente
   * Parámetros: $1 (id)
   * Tablas: orders, customers
   * Retorna: Todos los campos de orders + customer_name, customer_email
   * Join: INNER JOIN customers
   */
  findById: `
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Obtener pedido por número de orden
   * Objetivo: Buscar pedido por su order_number único
   * Parámetros: $1 (order_number)
   * Tablas: orders, customers
   * Retorna: Todos los campos + customer info
   */
  findByOrderNumber: `
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Obtener pedidos de un cliente
   * Objetivo: Consultar todos los pedidos de un cliente específico
   * Parámetros: $1 (customer_id)
   * Tablas: orders
   * Retorna: Todos los campos de orders
   * Orden: Por created_at descendente
   */
  findByCustomer: `
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Obtener pedidos por estado
   * Objetivo: Filtrar pedidos por su status
   * Parámetros: $1 (status)
   * Tablas: orders, customers
   * Retorna: o.*, customer_name, customer_email
   * Join: INNER JOIN customers
   * Filtro: o.status = $1
   * Orden: Por created_at descendente
   */
  findByStatus: `
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Crear un pedido (sin items)
   * Objetivo: Insertar un nuevo pedido
   * Parámetros: $1 (customer_id), $2 (order_number), $3 (shipping_address),
   *             $4 (shipping_city), $5 (shipping_country), $6 (shipping_cost), $7 (created_by)
   * Tablas: orders
   * Retorna: Todos los campos del pedido insertado
   * Nota: subtotal, tax y total se calculan en 0, se actualizarán con triggers
   */
  create: `
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Actualizar estado del pedido
   * Objetivo: Cambiar el status de un pedido
   * Parámetros: $1 (id), $2 (status)
   * Tablas: orders
   * Retorna: id, order_number, status, updated_at
   * Nota: Si status = 'shipped', actualizar shipped_at = CURRENT_TIMESTAMP
   *       Si status = 'delivered', actualizar delivered_at = CURRENT_TIMESTAMP
   */
  updateStatus: `
    -- TODO: Escribe tu consulta aquí
    -- Pista: Usa CASE WHEN para actualizar shipped_at y delivered_at
  `,

  /**
   * TODO: Actualizar totales del pedido
   * Objetivo: Actualizar subtotal, tax y total del pedido
   * Parámetros: $1 (id), $2 (subtotal), $3 (tax), $4 (total)
   * Tablas: orders
   * Retorna: id, subtotal, tax, total, updated_at
   */
  updateTotals: `
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Cancelar un pedido
   * Objetivo: Marcar pedido como cancelado
   * Parámetros: $1 (id)
   * Tablas: orders
   * Retorna: id, order_number, status
   * Nota: Establecer status = 'cancelled'
   */
  cancel: `
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Eliminar un pedido
   * Objetivo: Eliminar permanentemente un pedido y sus items (CASCADE)
   * Parámetros: $1 (id)
   * Tablas: orders
   * Retorna: id
   */
  delete: `
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Obtener items de un pedido
   * Objetivo: Consultar todos los productos de un pedido
   * Parámetros: $1 (order_id)
   * Tablas: order_items, products
   * Retorna:
   *   oi.id, oi.order_id, oi.product_id, oi.quantity, 
   *   oi.unit_price, oi.subtotal,
   *   p.name AS product_name, p.sku
   * Join: INNER JOIN products
   * Filtro: oi.order_id = $1
   * Orden: Por oi.id ascendente
   */
  findOrderItems: `
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Agregar item a un pedido
   * Objetivo: Insertar un nuevo item en un pedido
   * Parámetros: $1 (order_id), $2 (product_id), $3 (quantity), $4 (unit_price)
   * Tablas: order_items
   * Retorna: Todos los campos del item insertado
   * Nota: subtotal se puede calcular con trigger o aquí: $3 * $4
   */
  addOrderItem: `
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Actualizar cantidad de un item
   * Objetivo: Modificar la cantidad de un item en el pedido
   * Parámetros: $1 (id), $2 (quantity)
   * Tablas: order_items
   * Retorna: id, order_id, product_id, quantity, subtotal
   * Nota: Recalcular subtotal = quantity * unit_price
   */
  updateOrderItem: `
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Eliminar item de un pedido
   * Objetivo: Quitar un producto del pedido
   * Parámetros: $1 (id)
   * Tablas: order_items
   * Retorna: id
   */
  deleteOrderItem: `
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Obtener resumen de pedido
   * Objetivo: Obtener información completa del pedido con items
   * Parámetros: $1 (order_id)
   * Tablas: orders, customers, order_items, products
   * Retorna:
   *   JSON o múltiples columnas con:
   *   - Info del pedido (order_number, status, total, etc)
   *   - Info del cliente (nombre, email, dirección)
   *   - Items (productos, cantidades, precios)
   * Nota: Esta query puede requerir múltiples SELECTs en la aplicación
   */
  getOrderSummary: `
    -- TODO: Escribe tu consulta aquí
    -- Pista: Esta es la query principal del pedido,
    -- los items se obtienen con findOrderItems
  `,

  /**
   * TODO: Calcular total de items de un pedido
   * Objetivo: Sumar el subtotal de todos los items de un pedido
   * Parámetros: $1 (order_id)
   * Tablas: order_items
   * Retorna: order_id, SUM(subtotal) AS total_items
   * Agrupación: Por order_id
   */
  calculateItemsTotal: `
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Obtener pedidos en rango de fechas
   * Objetivo: Filtrar pedidos por fecha de creación
   * Parámetros: $1 (start_date), $2 (end_date)
   * Tablas: orders, customers
   * Retorna: o.*, customer_name, customer_email
   * Filtro: o.created_at BETWEEN $1 AND $2
   * Orden: Por created_at descendente
   */
  findByDateRange: `
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Contar pedidos por estado
   * Objetivo: Obtener estadísticas de pedidos agrupados por status
   * Parámetros: ninguno
   * Tablas: orders
   * Retorna:
   *   status,
   *   COUNT(*) AS order_count,
   *   SUM(total) AS total_amount
   * Agrupación: Por status
   * Orden: Por order_count descendente
   */
  countByStatus: `
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Obtener pedidos grandes
   * Objetivo: Consultar pedidos con total mayor a cierto monto
   * Parámetros: $1 (min_amount)
   * Tablas: orders, customers
   * Retorna: o.*, customer_name, customer_email
   * Filtro: o.total >= $1 AND o.status != 'cancelled'
   * Orden: Por total descendente
   */
  findLargeOrders: `
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Verificar disponibilidad de stock para pedido
   * Objetivo: Validar que todos los productos tengan stock suficiente
   * Parámetros: array de (product_id, quantity) - se hace en código
   * Nota: Esta query se implementará en el servicio usando múltiples queries
   */
};

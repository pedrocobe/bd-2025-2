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
   * Objetivo: Consultar un pedido específico con información del cliente
   * Parámetros: $1 (id)
   * Tablas: orders, customers
   * Retorna: Todos los campos de orders + customer_name, customer_email
   * Join: INNER JOIN customers
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
   * Objetivo: Buscar pedido por su order_number único
   * Parámetros: $1 (order_number)
   * Tablas: orders, customers
   * Retorna: Todos los campos + customer info
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
   * Objetivo: Consultar todos los pedidos de un cliente específico
   * Parámetros: $1 (customer_id)
   * Tablas: orders
   * Retorna: Todos los campos de orders
   * Orden: Por created_at descendente
   */
  findByCustomer: `
    SELECT *
    FROM orders
    WHERE customer_id = $1
    ORDER BY created_at DESC
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
   * Objetivo: Insertar un nuevo pedido
   * Parámetros: $1 (customer_id), $2 (order_number), $3 (shipping_address),
   *             $4 (shipping_city), $5 (shipping_country), $6 (shipping_amount), $7 (created_by)
   * Tablas: orders
   * Retorna: Todos los campos del pedido insertado
   * Nota: subtotal, tax y total se calculan en 0, se actualizarán con triggers
   */
  create: `
    INSERT INTO orders (
      customer_id,
      order_number,
      shipping_address,
      shipping_city,
      shipping_country,
      shipping_amount,
      payment_method,
      subtotal,
      tax_amount,
      total_amount,
      status
    ) VALUES ($1, $2, $3, $4, $5, $6, 'pending', 0, 0, 0, 'pending')
    RETURNING *
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
    UPDATE orders
    SET 
      status = $2,
      updated_at = CURRENT_TIMESTAMP,
      shipped_at = CASE 
        WHEN $2 = 'shipped' THEN CURRENT_TIMESTAMP
        ELSE shipped_at
      END,
      delivered_at = CASE 
        WHEN $2 = 'delivered' THEN CURRENT_TIMESTAMP
        ELSE delivered_at
      END
    WHERE id = $1
    RETURNING id, order_number, status, updated_at
  `,

  /**
   * TODO: Actualizar totales del pedido
   * Objetivo: Actualizar subtotal, tax y total del pedido
   * Parámetros: $1 (id), $2 (subtotal), $3 (tax), $4 (total)
   * Tablas: orders
   * Retorna: id, subtotal, tax, total, updated_at
   */
  updateTotals: `
    UPDATE orders
    SET 
      subtotal = $2,
      tax_amount = $3,
      total_amount = $4,
      updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, subtotal, tax_amount, total_amount, updated_at
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
    UPDATE orders
    SET 
      status = 'cancelled',
      updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, order_number, status
  `,

  /**
   * TODO: Eliminar un pedido
   * Objetivo: Eliminar permanentemente un pedido y sus items (CASCADE)
   * Parámetros: $1 (id)
   * Tablas: orders
   * Retorna: id
   */
  delete: `
    DELETE FROM orders
    WHERE id = $1
    RETURNING id
  `,

  /**
   * TODO: Obtener items de un pedido
   * Objetivo: Consultar todos los productos de un pedido
   * Parámetros: $1 (order_id)
   * Tablas: order_items, products
   * Retorna:
   *   oi.id, oi.order_id, oi.product_id, oi.quantity, 
   *   oi.unit_price, oi.total_price,
   *   p.name AS product_name, p.sku
   * Join: INNER JOIN products
   * Filtro: oi.order_id = $1
   * Orden: Por oi.id ascendente
   */
  findOrderItems: `
    SELECT 
      oi.id, 
      oi.order_id, 
      oi.product_id, 
      oi.quantity, 
      oi.unit_price, 
      oi.total_price,
      oi.discount,
      p.name AS product_name, 
      p.sku
    FROM order_items oi
    INNER JOIN products p ON oi.product_id = p.id
    WHERE oi.order_id = $1
    ORDER BY oi.id ASC
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
    INSERT INTO order_items (
      order_id,
      product_id,
      quantity,
      unit_price
    ) VALUES ($1, $2, $3, $4)
    RETURNING *
  `,

  /**
   * TODO: Actualizar cantidad de un item
   * Objetivo: Modificar la cantidad de un item en el pedido
   * Parámetros: $1 (id), $2 (quantity)
   * Tablas: order_items
   * Retorna: id, order_id, product_id, quantity, total_price
   * Nota: Recalcular total_price = (unit_price - discount) * quantity
   */
  updateOrderItem: `
    UPDATE order_items
    SET 
      quantity = $2,
      -- El total_price se recalcula automáticamente por la columna GENERATED
      updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, order_id, product_id, quantity, total_price
  `,

  /**
   * TODO: Eliminar item de un pedido
   * Objetivo: Quitar un producto del pedido
   * Parámetros: $1 (id)
   * Tablas: order_items
   * Retorna: id
   */
  deleteOrderItem: `
    DELETE FROM order_items
    WHERE id = $1
    RETURNING id
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
    -- Esta consulta obtiene la información básica del pedido
    -- Los items se obtienen con la consulta findOrderItems
    SELECT 
      o.*,
      (c.first_name || ' ' || c.last_name) AS customer_name,
      c.email AS customer_email,
      c.phone AS customer_phone,
      c.address AS customer_address,
      c.city AS customer_city,
      c.country AS customer_country
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.id
    WHERE o.id = $1
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
    SELECT 
      order_id,
      SUM(total_price) AS total_items
    FROM order_items
    WHERE order_id = $1
    GROUP BY order_id
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
    SELECT 
      o.*,
      (c.first_name || ' ' || c.last_name) AS customer_name,
      c.email AS customer_email
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.id
    WHERE o.order_date BETWEEN $1 AND $2
    ORDER BY o.order_date DESC
  `,

  /**
   * TODO: Contar pedidos por estado
   * Objetivo: Obtener estadísticas de pedidos agrupados por status
   * Parámetros: ninguno
   * Tablas: orders
   * Retorna:
   *   status,
   *   COUNT(*) AS order_count,
   *   SUM(total_amount) AS total_amount
   * Agrupación: Por status
   * Orden: Por order_count descendente
   */
  countByStatus: `
    SELECT 
      status,
      COUNT(*) AS order_count,
      SUM(total_amount) AS total_amount
    FROM orders
    GROUP BY status
    ORDER BY order_count DESC
  `,

  /**
   * TODO: Obtener pedidos grandes
   * Objetivo: Consultar pedidos con total mayor a cierto monto
   * Parámetros: $1 (min_amount)
   * Tablas: orders, customers
   * Retorna: o.*, customer_name, customer_email
   * Filtro: o.total_amount >= $1 AND o.status != 'cancelled'
   * Orden: Por total_amount descendente
   */
  findLargeOrders: `
    SELECT 
      o.*,
      (c.first_name || ' ' || c.last_name) AS customer_name,
      c.email AS customer_email
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.id
    WHERE o.total_amount >= $1 
      AND o.status != 'cancelled'
    ORDER BY o.total_amount DESC
  `,

  /**
   * TODO: Verificar disponibilidad de stock para pedido
   * Objetivo: Validar que todos los productos tengan stock suficiente
   * Parámetros: array de (product_id, quantity) - se hace en código
   * Nota: Esta query se implementará en el servicio usando múltiples queries
   */
};
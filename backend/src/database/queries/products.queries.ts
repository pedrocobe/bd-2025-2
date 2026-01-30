/**
 * QUERIES DE PRODUCTOS - products.queries.ts
 *
 * INSTRUCCIONES:
 * Este archivo contiene todos los queries SQL necesarios para el módulo de productos.
 * Muchos queries requieren JOINs con la tabla categories.
 */

export const ProductsQueries = {
  /**
   * findAll - Obtener todos los productos con su categoría
   */
  findAll: `
    SELECT 
      p.id, p.name, p.description, p.sku, p.price, p.stock_quantity, 
      p.is_active, c.name AS category_name, c.id AS category_id
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    ORDER BY p.created_at DESC
  `,

  /**
   * findById - Obtener producto por ID con categoría
   */
  findById: `
    SELECT p.*, c.name AS category_name
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE p.id = $1
  `,

  /**
   * findBySku - Buscar producto por SKU
   */
  findBySku: `
    SELECT * FROM products 
    WHERE sku = $1
  `,

  /**
   * findByCategory - Productos de una categoría específica
   */
  findByCategory: `
    SELECT id, name, sku, price, stock_quantity, is_active
    FROM products
    WHERE category_id = $1 AND is_active = true
    ORDER BY name ASC
  `,

  /**
   * create - Crear nuevo producto
   */
  create: `
    INSERT INTO products (
      name, description, sku, category_id, 
      price, cost, stock_quantity, min_stock_level, 
      created_by, created_at
    )
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, CURRENT_TIMESTAMP)
    RETURNING *
  `,

  /**
   * update - Actualizar producto existente
   */
  update: `
    UPDATE products
    SET 
      name = $2, 
      description = $3, 
      category_id = $4, 
      price = $5, 
      cost = $6, 
      stock_quantity = $7, 
      min_stock_level = $8, 
      is_active = $9, 
      updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING *
  `,

  /**
   * updateStock - Actualizar solo el inventario
   */
  updateStock: `
    UPDATE products
    SET stock_quantity = $2, updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, name, sku, stock_quantity, updated_at
  `,

  /**
   * delete - Eliminar producto
   */
  delete: `
    DELETE FROM products 
    WHERE id = $1 
    RETURNING id
  `,

  /**
   * findLowStock - Productos con inventario bajo
   */
  findLowStock: `
    SELECT 
      p.id, p.name, p.sku, p.stock_quantity, p.min_stock_level,
      (p.min_stock_level - p.stock_quantity) AS deficit,
      c.name AS category_name
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE p.stock_quantity < p.min_stock_level AND p.is_active = true
    ORDER BY deficit DESC
  `,

  /**
   * search - Buscar productos por nombre o SKU
   */
  search: `
    SELECT 
      p.id, p.name, p.sku, p.price, p.stock_quantity, 
      c.name AS category_name
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE p.name ILIKE $1 OR p.sku ILIKE $1
    ORDER BY p.name ASC
  `,

  /**
   * findTopSelling - Productos más vendidos
   */
  findTopSelling: `
    SELECT 
      p.id, p.name, p.sku, p.price,
      SUM(oi.quantity) AS total_sold,
      COUNT(DISTINCT o.id) AS order_count
    FROM products p
    LEFT JOIN order_items oi ON p.id = oi.product_id
    LEFT JOIN orders o ON oi.order_id = o.id
    WHERE o.status != 'cancelled' OR o.status IS NULL
    GROUP BY p.id, p.name, p.sku, p.price
    HAVING SUM(oi.quantity) IS NOT NULL
    ORDER BY total_sold DESC
    LIMIT $1
  `,

  /**
   * calculateProfitMargins - Calcular márgenes de ganancia
   */
  calculateProfitMargins: `
    SELECT 
      id, name, price, cost,
      (price - cost) AS profit,
      ROUND(((price - cost) / price) * 100, 2) AS profit_margin_percent
    FROM products
    WHERE is_active = true AND price > 0
    ORDER BY profit_margin_percent DESC
  `,

  /**
   * getInventoryValue - Valor del inventario por categoría
   */
  getInventoryValue: `
    SELECT 
      c.name AS category_name,
      COUNT(p.id) AS product_count,
      SUM(p.stock_quantity) AS total_units,
      SUM(p.stock_quantity * p.cost) AS inventory_value
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE p.is_active = true
    GROUP BY c.name
    ORDER BY inventory_value DESC
  `,

  /**
   * findNeverSold - Productos que nunca se han vendido
   */
  findNeverSold: `
    SELECT p.id, p.name, p.sku, p.price, p.stock_quantity, p.created_at
    FROM products p
    LEFT JOIN order_items oi ON p.id = oi.product_id
    WHERE oi.id IS NULL AND p.is_active = true
    ORDER BY p.created_at DESC
  `,
};
/**
 * QUERIES DE PRODUCTOS - products.queries.ts
 * 
 * INSTRUCCIONES:
 * Este archivo contiene todos los queries SQL necesarios para el módulo de productos.
 * Muchos queries requieren JOINs con la tabla categories.
 * 
 * Tablas involucradas:
 * - products (principal)
 * - categories (para mostrar nombre de categoría)
 * - order_items (para reportes de ventas)
 * - orders (para filtrar pedidos válidos)
 * 
 * Campos de la tabla products:
 * - id, name, description, sku, category_id
 * - price, cost, stock_quantity, min_stock_level
 * - is_active, created_at, updated_at, created_by
 */

export const ProductsQueries = {
  /**
   * findAll - Obtener todos los productos con el nombre de su categoría
   */
  findAll: `
    SELECT p.*, c.name as category_name
    FROM products p
    JOIN categories c ON p.category_id = c.id
    ORDER BY p.created_at DESC
  `,

  findById: `
    SELECT p.*, c.name as category_name
    FROM products p
    JOIN categories c ON p.category_id = c.id
    WHERE p.id = $1
  `,

  /**
   * ERROR 1: findBySku
   */
  findBySku: `
    SELECT p.*, c.name as category_name
    FROM products p
    JOIN categories c ON p.category_id = c.id
    WHERE p.sku = $1
  `,

  /**
   * create - Ajustado al orden exacto que envía el ProductsService
   */
  create: `
    INSERT INTO products (
      name, description, sku, category_id, 
      price, cost, stock_quantity, min_stock_level, is_active
    )
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
    RETURNING id, name, sku, price, stock_quantity as stock
  `,

  update: `
    UPDATE products
    SET category_id = $2, name = $3, description = $4, price = $5, stock_quantity = $6, sku = $7, updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING *
  `,

  delete: `
    DELETE FROM products WHERE id = $1 RETURNING id
  `,

  findByCategory: `
    SELECT p.*, c.name as category_name
    FROM products p
    JOIN categories c ON p.category_id = c.id
    WHERE p.category_id = $1
  `,

  updateStock: `
    UPDATE products SET stock_quantity = $2, updated_at = CURRENT_TIMESTAMP WHERE id = $1 RETURNING *
  `,

  search: `
    SELECT p.*, c.name as category_name
    FROM products p
    JOIN categories c ON p.category_id = c.id
    WHERE p.name ILIKE $1 OR p.sku ILIKE $1
  `,

  /**
   * ERROR 2: findLowStock
   */
  findLowStock: `
    SELECT p.*, c.name as category_name
    FROM products p
    JOIN categories c ON p.category_id = c.id
    WHERE p.stock_quantity < p.min_stock_level
    ORDER BY p.stock_quantity ASC
  `,

  /**
   * ERROR 3: findTopSelling (Renombrado de getTopSelling para coincidir con el Service)
   */
  findTopSelling: `
    SELECT 
      p.id, p.name, p.price, p.sku, 
      SUM(oi.quantity) as total_sold,
      COUNT(DISTINCT o.id) as order_count
    FROM products p
    JOIN order_items oi ON p.id = oi.product_id
    JOIN orders o ON oi.order_id = o.id
    WHERE o.status != 'cancelled'
    GROUP BY p.id, p.name, p.price, p.sku
    ORDER BY total_sold DESC
    LIMIT $1
  `,

  /**
   * calculateProfitMargins - El test espera la propiedad "profit"
   */
  calculateProfitMargins: `
    SELECT 
      id, name, sku, price, cost,
      (price - cost) AS profit,
      ROUND(((price - cost) / NULLIF(price, 0)) * 100, 2) AS profit_margin_percent
    FROM products
    WHERE is_active = true
    ORDER BY profit_margin_percent DESC
  `,

  /**
   * getInventoryValue - El test espera un desglose por categoría, no un total único
   */
  getInventoryValue: `
    SELECT 
      c.name AS category_name,
      COUNT(p.id) AS product_count,
      SUM(p.stock_quantity) AS total_units,
      SUM(p.stock_quantity * p.cost) AS inventory_value 
    FROM categories c
    JOIN products p ON c.id = p.category_id
    WHERE p.is_active = true
    GROUP BY c.name
    ORDER BY inventory_value DESC
  `,

  /**
   * ERROR 6: findNeverSold
   */
  findNeverSold: `
    SELECT p.*
    FROM products p
    LEFT JOIN order_items oi ON p.id = oi.product_id
    WHERE oi.product_id IS NULL
    ORDER BY p.name ASC
  `,
  
  // Mantenemos este por si acaso lo usa otro servicio
  getTopSelling: `
    SELECT p.id, p.name, SUM(oi.quantity) as total_sold
    FROM products p
    JOIN order_items oi ON p.id = oi.product_id
    GROUP BY p.id, p.name
    ORDER BY total_sold DESC
    LIMIT $1
  `
};

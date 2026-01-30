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
   * findAll - Obtener todos los productos con su categoría
   * 
   * Descripción: Lista todos los productos con el nombre de su categoría
   * Parámetros: ninguno
   * 
   * Debe retornar: 
   *   p.id, p.name, p.description, p.sku, p.price, p.stock_quantity,
   *   p.is_active, c.name AS category_name, c.id AS category_id
   * 
   * Usa: LEFT JOIN con categories
   * Ordenar por: p.created_at descendente
   */
  findAll: `
    SELECT p.id, p.name, p.description, p.sku, p.price, p.stock_quantity,
           p.is_active, c.name AS category_name, c.id AS category_id
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    ORDER BY p.created_at DESC
  `,

  findById: `
    SELECT p.*, c.name AS category_name
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE p.id = $1
  `,

  findBySku: `
    SELECT * FROM products WHERE sku = $1
  `,

  findByCategory: `
    SELECT id, name, sku, price, stock_quantity, is_active
    FROM products
    WHERE category_id = $1 AND is_active = true
    ORDER BY name ASC
  `,

  create: `
    INSERT INTO products (name, description, sku, category_id, price, cost, stock_quantity, min_stock_level, created_by)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
    RETURNING *
  `,

  update: `
    UPDATE products
    SET name = $2, description = $3, category_id = $4, price = $5, cost = $6, 
        stock_quantity = $7, min_stock_level = $8, is_active = $9
    WHERE id = $1
    RETURNING *
  `,

  updateStock: `
    UPDATE products
    SET stock_quantity = $2
    WHERE id = $1
    RETURNING id, name, sku, stock_quantity, updated_at
  `,

  delete: `
    DELETE FROM products WHERE id = $1 RETURNING id
  `,

  findLowStock: `
    SELECT p.id, p.name, p.sku, p.stock_quantity, p.min_stock_level,
           (p.min_stock_level - p.stock_quantity) AS deficit,
           c.name AS category_name
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE p.stock_quantity < p.min_stock_level AND p.is_active = true
    ORDER BY deficit DESC
  `,

  search: `
    SELECT p.id, p.name, p.sku, p.price, p.stock_quantity,
           c.name AS category_name
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE p.name ILIKE '%' || $1 || '%' OR p.sku ILIKE '%' || $1 || '%'
    ORDER BY p.name ASC
  `,

  findTopSelling: `
    SELECT p.id, p.name, p.sku, p.price,
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

  calculateProfitMargins: `
    SELECT id, name, price, cost,
           (price - cost) AS profit,
           ROUND(((price - cost) / price) * 100, 2) AS profit_margin_percent
    FROM products
    WHERE is_active = true AND price > 0
    ORDER BY profit_margin_percent DESC
  `,

  getInventoryValue: `
    SELECT c.name AS category_name,
           COUNT(p.id) AS product_count,
           SUM(p.stock_quantity) AS total_units,
           SUM(p.stock_quantity * p.cost) AS inventory_value
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE p.is_active = true
    GROUP BY c.name
    ORDER BY inventory_value DESC
  `,

  findNeverSold: `
    SELECT p.id, p.name, p.sku, p.price, p.stock_quantity, p.created_at
    FROM products p
    LEFT JOIN order_items oi ON p.id = oi.product_id
    WHERE oi.id IS NULL AND p.is_active = true
    ORDER BY p.created_at DESC
  `,
};

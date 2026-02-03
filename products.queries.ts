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

import { totalmem } from "os";

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

  /**
   * findById - Obtener producto por ID con categoría
   * 
   * Parámetros: $1 = id del producto
   * Debe retornar: p.* (todos los campos), c.name AS category_name
   * Usa: LEFT JOIN con categories
   */
  findById: `
    SELECT p.*, c.name AS category_name
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE p.id = $1
  `,

  /**
   * findBySku - Buscar producto por SKU
   * 
   * Descripción: El SKU es único para cada producto
   * Parámetros: $1 = sku (string)
   * Debe retornar: * (todos los campos)
   */
  findBySku: `
    SELECT *
    FROM products
    WHERE sku = $1
  `,

  /**
   * findByCategory - Productos de una categoría específica
   * 
   * Parámetros: $1 = category_id (integer)
   * Debe retornar: id, name, sku, price, stock_quantity, is_active
   * Filtros: category_id = $1 AND is_active = true
   * Ordenar por: name ascendente
   */
  findByCategory: `
    SELECT id, name, sku, price, stock_quantity, is_active
    FROM products
    WHERE category_id = $1 AND is_active = true
    ORDER BY name ASC
  `,

  /**
   * create - Crear nuevo producto
   * 
   * Parámetros:
   *   $1 = name, $2 = description, $3 = sku, $4 = category_id
   *   $5 = price, $6 = cost, $7 = stock_quantity
   *   $8 = min_stock_level, $9 = created_by
   * 
   * Debe retornar: * (todos los campos del producto insertado)
   * Usa: RETURNING
   */
  create: `
    INSERT INTO products (
      name, description, sku, category_id, 
      price, cost, stock_quantity, min_stock_level, 
      created_by, is_active
    )
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, true)
    RETURNING *
  `,

  /**
   * update - Actualizar producto existente
   * 
   * Parámetros:
   *   $1 = id, $2 = name, $3 = description, $4 = category_id
   *   $5 = price, $6 = cost, $7 = stock_quantity
   *   $8 = min_stock_level, $9 = is_active
   * 
   * Debe retornar: * (todos los campos)
   * Usa: RETURNING
   */
  update: `
    UPDATE products
    SET name = $2,
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
   * 
   * Parámetros:
   *   $1 = id, $2 = stock_quantity
   * 
   * Debe retornar: id, name, sku, stock_quantity, updated_at
   * Usa: RETURNING
   */
  updateStock: `
    UPDATE products
    SET stock_quantity = $2,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, name, sku, stock_quantity, updated_at
  `,

  /**
   * delete - Eliminar producto
   * 
   * Parámetros: $1 = id
   * Debe retornar: id
   * Usa: RETURNING
   */
  delete: `
    DELETE FROM products
    WHERE id = $1
    RETURNING id
  `,

  /**
   * findLowStock - Productos con inventario bajo
   * 
   * Descripción: Encuentra productos donde stock_quantity < min_stock_level
   * Parámetros: ninguno
   * 
   * Debe retornar:
   *   p.id, p.name, p.sku, p.stock_quantity, p.min_stock_level,
   *   (p.min_stock_level - p.stock_quantity) AS deficit,
   *   c.name AS category_name
   * 
   * Filtros: stock_quantity < min_stock_level AND is_active = true
   * Usa: LEFT JOIN con categories
   * Ordenar por: deficit descendente (mayor déficit primero)
   */
  findLowStock: `
    SELECT p.id, p.name, p.sku, p.stock_quantity, p.min_stock_level,
           (p.min_stock_level - p.stock_quantity) AS deficit,
           c.name AS category_name
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE p.stock_quantity < p.min_stock_level AND p.is_active = true
    ORDER BY deficit DESC
  `,

  /**
   * search - Buscar productos por nombre o SKU
   * 
   * Parámetros: $1 = search_term (string)
   * 
   * Debe retornar:
   *   p.id, p.name, p.sku, p.price, p.stock_quantity,
   *   c.name AS category_name
   * 
   * Usa: ILIKE para búsqueda en p.name OR p.sku
   * Usa: LEFT JOIN con categories
   * Ordenar por: p.name ascendente
   */
  search: `
    SELECT p.id, p.name, p.sku, p.price, p.stock_quantity,
           c.name AS category_name
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE p.name ILIKE '%' || $1 || '%' OR p.sku ILIKE '%' || $1 || '%'
    ORDER BY p.name ASC
  `,

  /**
   * findTopSelling - Productos más vendidos (COMPLEJO)
   * 
   * Descripción: Calcula los productos con mayor cantidad vendida
   * Parámetros: $1 = limit (integer) - cantidad de resultados
   * 
   * Debe retornar:
   *   p.id, p.name, p.sku, p.price,
   *   SUM(oi.quantity) AS total_sold,
   *   COUNT(DISTINCT o.id) AS order_count
   * 
   * Tablas: products p
   * Usa: LEFT JOIN con order_items oi ON p.id = oi.product_id
   * Usa: LEFT JOIN con orders o ON oi.order_id = o.id
   * Filtro: o.status != 'cancelled' OR o.status IS NULL
   * Agrupa por: p.id, p.name, p.sku, p.price
   * Usa: HAVING SUM(oi.quantity) IS NOT NULL
   * Ordenar por: total_sold descendente
   * Usa: LIMIT $1
   */
  findTopSelling: `
    SELECT p.id, p.name, p.sku, p.price,
           COALESCE(SUM(oi.quantity), 0) AS total_sold,
           COUNT(DISTINCT o.id) AS order_count
    FROM products p
    LEFT JOIN order_items oi ON p.id = oi.product_id
    LEFT JOIN orders o ON oi.order_id = o.id AND o.status != 'cancelled'
    GROUP BY p.id, p.name, p.sku, p.price
    HAVING SUM(oi.quantity) > 0
    ORDER BY total_sold DESC
    LIMIT $1
  `,

  /**
   * calculateProfitMargins - Calcular márgenes de ganancia
   * 
   * Descripción: Calcula el margen de ganancia de cada producto
   * Parámetros: ninguno
   * 
   * Debe retornar:
   *   id, name, price, cost,
   *   (price - cost) AS profit,
   *   ROUND(((price - cost) / price) * 100, 2) AS profit_margin_percent
   * 
   * Filtros: is_active = true AND price > 0
   * Ordenar por: profit_margin_percent descendente
   */
  calculateProfitMargins: `
    SELECT id, name, price, cost,
           (price - cost) AS profit,
           ROUND(((price - cost) / NULLIF(price, 0)) * 100, 2) AS profit_margin_percent
    FROM products
    WHERE is_active = true AND price > 0
    ORDER BY profit_margin_percent DESC
  `,

  /**
   * getInventoryValue - Valor del inventario por categoría
   * 
   * Descripción: Calcula el valor total del inventario agrupado por categoría
   * Parámetros: ninguno
   * 
   * Debe retornar:
   *   c.name AS category_name,
   *   COUNT(p.id) AS product_count,
   *   SUM(p.stock_quantity) AS total_units,
   *   SUM(p.stock_quantity * p.cost) AS inventory_value
   * 
   * Usa: LEFT JOIN con categories
   * Filtro: p.is_active = true
   * Agrupa por: c.name
   * Ordenar por: inventory_value descendente
   */
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

  /**
   * findNeverSold - Productos que nunca se han vendido
   * 
   * Descripción: Encuentra productos que no aparecen en ningún pedido
   * Parámetros: ninguno
   * 
   * Debe retornar:
   *   p.id, p.name, p.sku, p.price, p.stock_quantity, p.created_at
   * 
   * Usa: LEFT JOIN con order_items oi ON p.id = oi.product_id
   * Filtro: oi.id IS NULL AND p.is_active = true
   * Ordenar por: p.created_at descendente
   * 
   * PISTA: Si el LEFT JOIN no encuentra coincidencias, oi.id será NULL
   */
  findNeverSold: `
    SELECT p.id, p.name, p.sku, p.price, p.stock_quantity, p.created_at
    FROM products p
    LEFT JOIN order_items oi ON p.id = oi.product_id
    WHERE oi.id IS NULL AND p.is_active = true
    ORDER BY p.created_at DESC
  `,
};


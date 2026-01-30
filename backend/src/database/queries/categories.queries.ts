/**
 * =====================================================
 * QUERIES DE CATEGORÍAS - PARA COMPLETAR
 * =====================================================
 */

export const CategoriesQueries = {
  /**
   * TODO: Obtener todas las categorías
   * Objetivo: Consultar todas las categorías activas
   * Tablas: categories
   * Retorna: id, name, description, parent_id, is_active, created_at
   * Orden: Por name ascendente
   */
  findAll: `
    SELECT 
      id, 
      name, 
      description, 
      parent_id, 
      is_active, 
      created_at
    FROM categories
    WHERE is_active = TRUE
    ORDER BY name ASC
  `,

  /**
   * TODO: Obtener una categoría por ID
   * Objetivo: Consultar una categoría específica
   * Parámetros: $1 (id)
   * Tablas: categories
   * Retorna: id, name, description, parent_id, is_active, created_at, updated_at
   */
  findById: `
    SELECT 
      id, 
      name, 
      description, 
      parent_id, 
      slug,
      is_active, 
      created_at,
      updated_at
    FROM categories
    WHERE id = $1
  `,

  /**
   * TODO: Obtener categorías con información de la categoría padre
   * Objetivo: Consultar categorías con el nombre de su categoría padre (si existe)
   * Parámetros: ninguno
   * Tablas: categories (self-join)
   * Retorna: 
   *   - c.id AS id
   *   - c.name AS name
   *   - c.description
   *   - c.parent_id
   *   - parent.name AS parent_name
   *   - c.is_active
   * Join: LEFT JOIN con categories como parent
   * Orden: Por c.name ascendente
   */
  findAllWithParent: `
    SELECT 
      c.id AS id,
      c.name AS name,
      c.description,
      c.parent_id,
      p.name AS parent_name,
      c.is_active,
      c.slug
    FROM categories c
    LEFT JOIN categories p ON c.parent_id = p.id
    WHERE c.is_active = TRUE
    ORDER BY c.name ASC
  `,

  /**
   * TODO: Obtener categorías principales (sin padre)
   * Objetivo: Consultar solo las categorías de nivel superior
   * Parámetros: ninguno
   * Tablas: categories
   * Retorna: id, name, description, is_active
   * Filtro: parent_id IS NULL
   * Orden: Por name ascendente
   */
  findRootCategories: `
    SELECT 
      id, 
      name, 
      description, 
      is_active
    FROM categories
    WHERE parent_id IS NULL 
      AND is_active = TRUE
    ORDER BY name ASC
  `,

  /**
   * TODO: Obtener subcategorías de una categoría
   * Objetivo: Consultar las categorías hijas de una categoría específica
   * Parámetros: $1 (parent_id)
   * Tablas: categories
   * Retorna: id, name, description, parent_id, is_active
   * Filtro: parent_id = $1
   * Orden: Por name ascendente
   */
  findByParent: `
    SELECT 
      id, 
      name, 
      description, 
      parent_id, 
      is_active
    FROM categories
    WHERE parent_id = $1 
      AND is_active = TRUE
    ORDER BY name ASC
  `,

  /**
   * TODO: Crear una categoría
   * Objetivo: Insertar una nueva categoría
   * Parámetros: $1 (name), $2 (description), $3 (parent_id)
   * Tablas: categories
   * Retorna: id, name, description, parent_id, is_active, created_at
   */
  create: `
    INSERT INTO categories (
      name, 
      description, 
      parent_id,
      slug
    ) VALUES ($1, $2, $3, LOWER(REPLACE($1, ' ', '-')))
    RETURNING 
      id, 
      name, 
      description, 
      parent_id, 
      is_active, 
      created_at
  `,

  /**
   * TODO: Actualizar una categoría
   * Objetivo: Modificar los datos de una categoría
   * Parámetros: $1 (id), $2 (name), $3 (description), $4 (parent_id), $5 (is_active)
   * Tablas: categories
   * Retorna: id, name, description, parent_id, is_active, updated_at
   */
  update: `
    UPDATE categories
    SET 
      name = COALESCE($2, name),
      description = COALESCE($3, description),
      parent_id = COALESCE($4, parent_id),
      is_active = COALESCE($5, is_active),
      updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING 
      id, 
      name, 
      description, 
      parent_id, 
      is_active, 
      updated_at
  `,

  /**
   * TODO: Eliminar una categoría
   * Objetivo: Eliminar una categoría (solo si no tiene productos)
   * Parámetros: $1 (id)
   * Tablas: categories
   * Retorna: id
   */
  delete: `
    DELETE FROM categories
    WHERE id = $1
      AND NOT EXISTS (
        SELECT 1 FROM products 
        WHERE category_id = $1
      )
      AND NOT EXISTS (
        SELECT 1 FROM categories 
        WHERE parent_id = $1
      )
    RETURNING id
  `,

  /**
   * TODO: Contar productos por categoría
   * Objetivo: Obtener el número de productos en cada categoría
   * Parámetros: ninguno
   * Tablas: categories, products
   * Retorna: 
   *   - c.id
   *   - c.name
   *   - COUNT(p.id) AS product_count
   * Join: LEFT JOIN products
   * Agrupación: Por c.id, c.name
   * Orden: Por product_count descendente
   */
  countProducts: `
    SELECT 
      c.id,
      c.name,
      COUNT(p.id) AS product_count
    FROM categories c
    LEFT JOIN products p ON c.id = p.category_id 
      AND p.is_active = TRUE
    WHERE c.is_active = TRUE
    GROUP BY c.id, c.name
    ORDER BY product_count DESC
  `,

  /**
   * TODO: Obtener jerarquía completa de categorías
   * Objetivo: Obtener categorías con ruta completa (ej: Electrónica > Computadoras)
   * Parámetros: ninguno
   * Tablas: categories (self-join múltiple)
   * Retorna:
   *   - c.id
   *   - c.name AS category_name
   *   - parent.name AS parent_name
   *   - CASE para construir la ruta
   * Orden: Por la ruta completa
   */
  findHierarchy: `
    SELECT 
      c.id,
      c.name AS category_name,
      p.name AS parent_name,
      CASE 
        WHEN p.name IS NOT NULL THEN p.name || ' > ' || c.name
        ELSE c.name
      END AS full_path
    FROM categories c
    LEFT JOIN categories p ON c.parent_id = p.id
    WHERE c.is_active = TRUE
    ORDER BY 
      COALESCE(p.name, ''),
      c.name
  `,

  /**
   * EXTRA: Obtener categorías con conteo de productos y subcategorías
   */
  findCategoriesWithStats: `
    SELECT 
      c.id,
      c.name,
      c.description,
      c.parent_id,
      p.name AS parent_name,
      COUNT(DISTINCT prod.id) AS product_count,
      COUNT(DISTINCT child.id) AS subcategory_count
    FROM categories c
    LEFT JOIN categories p ON c.parent_id = p.id
    LEFT JOIN products prod ON c.id = prod.category_id AND prod.is_active = TRUE
    LEFT JOIN categories child ON c.id = child.parent_id AND child.is_active = TRUE
    WHERE c.is_active = TRUE
    GROUP BY c.id, c.name, c.description, c.parent_id, p.name
    ORDER BY c.name
  `,

  /**
   * EXTRA: Buscar categorías por nombre
   */
  search: `
    SELECT 
      id, 
      name, 
      description, 
      parent_id,
      is_active
    FROM categories
    WHERE name ILIKE '%' || $1 || '%'
      AND is_active = TRUE
    ORDER BY name
  `
};
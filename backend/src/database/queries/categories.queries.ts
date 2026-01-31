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
    -- Variante: usar explícitamente filtro y renombrado de columnas
    SELECT id, name, description, parent_id, is_active, created_at
    FROM categories
    WHERE is_active IS TRUE
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
    SELECT id, name, description, parent_id, is_active, created_at, updated_at
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
    -- Variante: usar subquery para obtener parent_name
    SELECT c.id,
           c.name,
           c.description,
           c.parent_id,
           (
             SELECT name FROM categories p WHERE p.id = c.parent_id
           ) AS parent_name,
           c.is_active
    FROM categories c
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
    SELECT id, name, description, is_active
    FROM categories
    WHERE parent_id IS NULL
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
    SELECT id, name, description, parent_id, is_active
    FROM categories
    WHERE parent_id = $1
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
    INSERT INTO categories (name, description, parent_id)
    VALUES ($1, $2, $3)
    RETURNING id, name, description, parent_id, is_active, created_at
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
    SET name = $2, description = $3, parent_id = $4, is_active = $5, updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, name, description, parent_id, is_active, updated_at
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
      -- Variante: COUNT DISTINCT por si hay duplicados
      SELECT c.id,
        c.name,
        COUNT(DISTINCT p.id) AS product_count
      FROM categories c
      LEFT JOIN products p ON p.category_id = c.id
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
    -- Variante: usar función concat_ws para construir ruta (si está disponible)
    SELECT c.id,
           c.name AS category_name,
           parent.name AS parent_name,
           CASE WHEN parent.name IS NOT NULL THEN concat(parent.name, ' > ', c.name) ELSE c.name END AS full_path
    FROM categories c
    LEFT JOIN categories parent ON c.parent_id = parent.id
    ORDER BY full_path ASC
  `,
};

/* actualizacion 30/01/2026 07:21*/

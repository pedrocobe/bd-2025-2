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
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Obtener una categoría por ID
   * Objetivo: Consultar una categoría específica
   * Parámetros: $1 (id)
   * Tablas: categories
   * Retorna: id, name, description, parent_id, is_active, created_at, updated_at
   */
  findById: `
    -- TODO: Escribe tu consulta aquí
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
    -- TODO: Escribe tu consulta aquí
    -- Pista: Usa LEFT JOIN categories parent ON c.parent_id = parent.id
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
    -- TODO: Escribe tu consulta aquí
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
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Crear una categoría
   * Objetivo: Insertar una nueva categoría
   * Parámetros: $1 (name), $2 (description), $3 (parent_id)
   * Tablas: categories
   * Retorna: id, name, description, parent_id, is_active, created_at
   */
  create: `
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Actualizar una categoría
   * Objetivo: Modificar los datos de una categoría
   * Parámetros: $1 (id), $2 (name), $3 (description), $4 (parent_id), $5 (is_active)
   * Tablas: categories
   * Retorna: id, name, description, parent_id, is_active, updated_at
   */
  update: `
    -- TODO: Escribe tu consulta aquí
  `,

  /**
   * TODO: Eliminar una categoría
   * Objetivo: Eliminar una categoría (solo si no tiene productos)
   * Parámetros: $1 (id)
   * Tablas: categories
   * Retorna: id
   */
  delete: `
    -- TODO: Escribe tu consulta aquí
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
    -- TODO: Escribe tu consulta aquí
    -- Pista: Usa LEFT JOIN y GROUP BY
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
    -- TODO: Escribe tu consulta aquí (AVANZADO)
    -- Pista: Usa CASE WHEN para construir la ruta jerárquica
    -- Ejemplo de resultado: "Electrónica > Computadoras"
  `,
};

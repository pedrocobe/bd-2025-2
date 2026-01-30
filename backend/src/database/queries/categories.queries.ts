export const CategoriesQueries = {
  findAll: `
    SELECT id, name, description, parent_id, created_at
    FROM categories
    ORDER BY name ASC
  `,

  findById: `
    SELECT id, name, description, parent_id, created_at, updated_at
    FROM categories
    WHERE id = $1
  `,

  findAllWithParent: `
    SELECT 
      c.id AS id,
      c.name AS name,
      c.description,
      c.parent_id,
      parent.name AS parent_name
    FROM categories c
    LEFT JOIN categories parent ON c.parent_id = parent.id
    ORDER BY c.name ASC
  `,

  findRootCategories: `
    SELECT id, name, description
    FROM categories
    WHERE parent_id IS NULL
    ORDER BY name ASC
  `,

  findByParent: `
    SELECT id, name, description, parent_id
    FROM categories
    WHERE parent_id = $1
    ORDER BY name ASC
  `,

  create: `
    INSERT INTO categories (name, description, parent_id)
    VALUES ($1, $2, $3)
    RETURNING id, name, description, parent_id, created_at
  `,

  update: `
    UPDATE categories
    SET name = $2, description = $3, parent_id = $4, updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, name, description, parent_id, updated_at
  `,

  delete: `
    DELETE FROM categories
    WHERE id = $1
    RETURNING id
  `,

  countProducts: `
    SELECT 
      c.id,
      c.name,
      COUNT(p.id) AS product_count
    FROM categories c
    LEFT JOIN products p ON c.id = p.category_id
    GROUP BY c.id, c.name
    ORDER BY product_count DESC
  `,

  findHierarchy: `
    SELECT
      c.id,
      c.name AS category_name,
      parent.name AS parent_name,
      CASE 
        WHEN parent.name IS NOT NULL THEN parent.name || ' > ' || c.name
        ELSE c.name
      END AS hierarchy_path
    FROM categories c
    LEFT JOIN categories parent ON c.parent_id = parent.id
    ORDER BY hierarchy_path
  `,
};
/**
 * QUERIES DE USUARIOS - users.queries.ts
 */

export const UsersQueries = {
  /**
   * findAll - Obtener todos los usuarios
   */
  findAll: `
    SELECT id, username, email, full_name, role, is_active, created_at
    FROM users
    ORDER BY created_at DESC
  `,

  /**
   * findById - Buscar usuario por ID
   */
  findById: `
    SELECT id, username, email, full_name, role, is_active, created_at, last_login
    FROM users
    WHERE id = $1
  `,

  /**
   * findByUsername - Buscar usuario por username (para autenticación)
   */
  findByUsername: `
    SELECT id, username, email, password_hash, full_name, role, is_active
    FROM users
    WHERE username = $1
  `,

  /**
   * findByEmail - Buscar usuario por email
   */
  findByEmail: `
    SELECT id, username, email, full_name, role, is_active
    FROM users
    WHERE email = $1
  `,

  /**
   * create - Crear nuevo usuario
   */
  create: `
    INSERT INTO users (username, email, password_hash, full_name, role)
    VALUES ($1, $2, $3, $4, $5)
    RETURNING id, username, email, full_name, role, is_active, created_at
  `,

  /**
   * update - Actualizar datos de usuario
   */
  update: `
    UPDATE users
    SET email = $2, full_name = $3, role = $4, is_active = $5
    WHERE id = $1
    RETURNING id, username, email, full_name, role, is_active, updated_at
  `,

  /**
   * updatePassword - Cambiar contraseña de usuario
   */
  updatePassword: `
    UPDATE users
    SET password_hash = $2
    WHERE id = $1
    RETURNING id, username, email
  `,

  /**
   * updateLastLogin - Actualizar timestamp de último login
   */
  updateLastLogin: `
    UPDATE users
    SET last_login = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, last_login
  `,

  /**
   * deactivate - Desactivar usuario
   */
  deactivate: `
    UPDATE users
    SET is_active = false
    WHERE id = $1
    RETURNING id, username, is_active
  `,

  /**
   * delete - Eliminar usuario permanentemente
   */
  delete: `
    DELETE FROM users
    WHERE id = $1
    RETURNING id
  `,

  /**
   * findByRole - Buscar usuarios por rol
   */
  findByRole: `
    SELECT id, username, email, full_name, role, is_active
    FROM users
    WHERE role = $1
    ORDER BY full_name ASC
  `,

  /**
   * countByRole - Contar usuarios por rol (estadísticas)
   */
  countByRole: `
    SELECT role, COUNT(*) as count
    FROM users
    GROUP BY role
    ORDER BY count DESC
  `,

  /**
   * search - Buscar usuarios por nombre o email
   */
  search: `
    SELECT id, username, email, full_name, role
    FROM users
    WHERE full_name ILIKE $1 OR email ILIKE $1
    ORDER BY full_name ASC
  `,
};

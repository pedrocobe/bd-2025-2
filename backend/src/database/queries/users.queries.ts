/**
 * QUERIES DE USUARIOS - users.queries.ts
 * 
 * INSTRUCCIONES:
 * Este archivo contiene todos los queries SQL necesarios para el módulo de usuarios.
 * Debes escribir ÚNICAMENTE las consultas SQL dentro de cada propiedad.
 * 
 * IMPORTANTE:
 * - Usa parámetros ($1, $2, $3, etc.) para valores dinámicos
 * - NO incluyas punto y coma (;) al final de cada query
 * - Usa RETURNING para devolver datos después de INSERT/UPDATE/DELETE
 * - La tabla se llama: users
 * 
 * Campos de la tabla users:
 * - id (serial, primary key)
 * - username (varchar, unique)
 * - email (varchar, unique)
 * - password_hash (varchar)
 * - full_name (varchar)
 * - role (enum: 'admin', 'manager', 'employee')
 * - is_active (boolean, default true)
 * - created_at (timestamp)
 * - updated_at (timestamp)
 * - last_login (timestamp)
 */

export const UsersQueries = {
  /**
   * findAll - Obtener todos los usuarios
   * 
   * Descripción: Obtiene la lista completa de usuarios del sistema
   * Parámetros: ninguno
   * Debe retornar: id, username, email, full_name, role, is_active, created_at
   * Ordenar por: created_at descendente (más recientes primero)
   * 
   * NOTA: NO incluyas password_hash en el resultado
   */
  findAll: `
    SELECT id, username, email, full_name, role, is_active, created_at
    FROM users
    ORDER BY created_at DESC
  `,

  findById: `
    SELECT id, username, email, full_name, role, is_active, created_at, last_login
    FROM users
    WHERE id = $1
  `,

  findByUsername: `
    SELECT id, username, email, password_hash, full_name, role, is_active
    FROM users
    WHERE username = $1
  `,

  findByEmail: `
    SELECT id, username, email, full_name, role, is_active
    FROM users
    WHERE email = $1
  `,

  create: `
    INSERT INTO users (username, email, password_hash, full_name, role)
    VALUES ($1, $2, $3, $4, $5)
    RETURNING id, username, email, full_name, role, is_active, created_at
  `,

  update: `
    UPDATE users
    SET email = $2, full_name = $3, role = $4, is_active = $5
    WHERE id = $1
    RETURNING id, username, email, full_name, role, is_active, updated_at
  `,

  updatePassword: `
    UPDATE users
    SET password_hash = $2
    WHERE id = $1
    RETURNING id, username, email
  `,

  updateLastLogin: `
    UPDATE users
    SET last_login = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, last_login
  `,

  deactivate: `
    UPDATE users
    SET is_active = false
    WHERE id = $1
    RETURNING id, username, is_active
  `,

  delete: `
    DELETE FROM users
    WHERE id = $1
    RETURNING id
  `,

  findByRole: `
    SELECT id, username, email, full_name, role, is_active
    FROM users
    WHERE role = $1
    ORDER BY full_name ASC
  `,

  countByRole: `
    SELECT role, COUNT(*) as count
    FROM users
    GROUP BY role
    ORDER BY count DESC
  `,

  search: `
    SELECT id, username, email, full_name, role
    FROM users
    WHERE full_name ILIKE '%' || $1 || '%' OR email ILIKE '%' || $1 || '%'
    ORDER BY full_name ASC
  `,
};

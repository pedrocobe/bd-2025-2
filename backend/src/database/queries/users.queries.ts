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
    -- Variante bd-3: usar CTE y ordenar por role luego created_at
    WITH u AS (
      SELECT id, username, email, full_name, role, is_active, created_at
      FROM users
    )
    SELECT * FROM u
    ORDER BY role ASC, created_at DESC
  `,

  /**
   * findById - Buscar usuario por ID
   * 
   * Descripción: Obtiene un usuario específico por su ID
   * Parámetros: $1 = id del usuario (integer)
   * Debe retornar: id, username, email, full_name, role, is_active, created_at, last_login
   * 
   * NOTA: NO incluyas password_hash en el resultado
   */
  findById: `
    SELECT id, username, email, full_name, role, is_active, created_at, last_login
    FROM users
    WHERE id = $1
  `,

  /**
   * findByUsername - Buscar usuario por username (para autenticación)
   * 
   * Descripción: Busca un usuario por su nombre de usuario
   * Parámetros: $1 = username (string)
   * Debe retornar: id, username, email, password_hash, full_name, role, is_active
   * 
   * IMPORTANTE: Esta query SÍ debe incluir password_hash porque se usa para login
   */
  findByUsername: `
    SELECT id, username, email, password_hash, full_name, role, is_active
    FROM users
    WHERE username = $1
  `,

  /**
   * findByEmail - Buscar usuario por email
   * 
   * Descripción: Busca un usuario por su correo electrónico
   * Parámetros: $1 = email (string)
   * Debe retornar: id, username, email, full_name, role, is_active
   */
  findByEmail: `
    -- Variante bd-3: búsqueda case-insensitive
    SELECT id, username, email, full_name, role, is_active
    FROM users
    WHERE LOWER(email) = LOWER($1)
  `,

  /**
   * create - Crear nuevo usuario
   * 
   * Descripción: Inserta un nuevo usuario en la base de datos
   * Parámetros:
   *   $1 = username (string)
   *   $2 = email (string)
   *   $3 = password_hash (string) - ya viene hasheado desde el service
   *   $4 = full_name (string)
   *   $5 = role (string) - 'admin', 'manager' o 'employee'
   * 
   * Debe retornar: id, username, email, full_name, role, is_active, created_at
   * Usa: RETURNING para devolver el registro insertado
   */
  create: `
    INSERT INTO users (username, email, password_hash, full_name, role)
    VALUES ($1, $2, $3, $4, $5)
    RETURNING id, username, email, full_name, role, is_active, created_at
  `,

  /**
   * update - Actualizar datos de usuario
   * 
   * Descripción: Actualiza la información de un usuario existente
   * Parámetros:
   *   $1 = id (integer) - ID del usuario a actualizar
   *   $2 = email (string)
   *   $3 = full_name (string)
   *   $4 = role (string)
   *   $5 = is_active (boolean)
   * 
   * Debe retornar: id, username, email, full_name, role, is_active, updated_at
   * Usa: RETURNING para devolver el registro actualizado
   */
  update: `
    UPDATE users
    SET email = $2, full_name = $3, role = $4, is_active = $5, updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, username, email, full_name, role, is_active, updated_at
  `,

  /**
   * updatePassword - Cambiar contraseña de usuario
   * 
   * Descripción: Actualiza solo el password_hash de un usuario
   * Parámetros:
   *   $1 = id (integer) - ID del usuario
   *   $2 = password_hash (string) - nuevo hash de contraseña
   * 
   * Debe retornar: id, username, email
   * Usa: RETURNING
   */
  updatePassword: `
    UPDATE users
    SET password_hash = $2, updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, username, email
  `,

  /**
   * updateLastLogin - Actualizar timestamp de último login
   * 
   * Descripción: Actualiza el campo last_login con la fecha/hora actual
   * Parámetros:
   *   $1 = id (integer) - ID del usuario
   * 
   * Debe retornar: id, last_login
   * Usa: CURRENT_TIMESTAMP para establecer la fecha actual
   * Usa: RETURNING
   */
  updateLastLogin: `
    UPDATE users
    SET last_login = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, last_login
  `,

  /**
   * deactivate - Desactivar usuario
   * 
   * Descripción: Marca un usuario como inactivo (is_active = false)
   * Parámetros:
   *   $1 = id (integer) - ID del usuario
   * 
   * Debe retornar: id, username, is_active
   * Usa: RETURNING
   */
  deactivate: `
    UPDATE users
    SET is_active = false, updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, username, is_active
  `,

  /**
   * delete - Eliminar usuario permanentemente
   * 
   * Descripción: Elimina un usuario de la base de datos
   * Parámetros:
   *   $1 = id (integer) - ID del usuario
   * 
   * Debe retornar: id
   * Usa: RETURNING
   */
  delete: `
    DELETE FROM users
    WHERE id = $1
    RETURNING id
  `,

  /**
   * findByRole - Buscar usuarios por rol
   * 
   * Descripción: Filtra usuarios por su rol (admin, manager, employee)
   * Parámetros:
   *   $1 = role (string) - rol a buscar
   * 
   * Debe retornar: id, username, email, full_name, role, is_active
   * Ordenar por: full_name ascendente (orden alfabético)
   */
  findByRole: `
    SELECT id, username, email, full_name, role, is_active
    FROM users
    WHERE role = $1
    ORDER BY full_name ASC
  `,

  /**
   * countByRole - Contar usuarios por rol (estadísticas)
   * 
   * Descripción: Agrupa usuarios por rol y cuenta cuántos hay de cada tipo
   * Parámetros: ninguno
   * 
   * Debe retornar: role, count
   * Usa: GROUP BY y COUNT(*)
   * Ordenar por: count descendente (mayor cantidad primero)
   */
  countByRole: `
    -- Variante bd-3: usar COUNT(*) FILTER por si se quiere filtrar activos
    SELECT role, COUNT(*)::int AS count
    FROM users
    GROUP BY role
    ORDER BY count DESC
  `,

  /**
   * search - Buscar usuarios por nombre o email
   * 
   * Descripción: Búsqueda flexible por nombre completo o email
   * Parámetros:
   *   $1 = search_term (string) - término de búsqueda
   * 
   * Debe retornar: id, username, email, full_name, role
   * Usa: ILIKE para búsqueda case-insensitive
   * Busca en: full_name OR email
   * Ordenar por: full_name ascendente
   * 
   * Ejemplo: Si $1 = '%juan%', debe buscar usuarios cuyo nombre o email contenga 'juan'
   */
  search: `
    SELECT id, username, email, full_name, role
    FROM users
    WHERE full_name ILIKE $1 OR email ILIKE $1
    ORDER BY full_name ASC
  `,
};


/* actualizacion 30/01/2026 07:21*/
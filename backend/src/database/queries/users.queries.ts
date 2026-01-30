export const UsersQueries = {
  findAll: `
    SELECT id,
           username,
           email,
           role,
           created_at,
           updated_at,
           full_name,
           is_active
    FROM users
    ORDER BY created_at DESC
  `,

  findById: `
    SELECT id,
           username,
           email,
           password_hash,
           full_name,
           is_active,
           role,
           created_at,
           updated_at
    FROM users
    WHERE id = $1
  `,

  findByUsername: `
    SELECT id,
           username,
           email,
           password_hash,
           full_name,
           is_active,
           role,
           created_at,
           updated_at
    FROM users
    WHERE username = $1
  `,

  findByEmail: `
    SELECT id,
           username,
           email,
           password_hash,
           full_name,
           is_active,
           role,
           created_at,
           updated_at
    FROM users
    WHERE email = $1
  `,

  create: `
    INSERT INTO users (username, email, password_hash, full_name, role)
    VALUES ($1, $2, $3, $4, $5)
    RETURNING id,
              username,
              email,
              password_hash,
              full_name,
              role,
              created_at,
              updated_at,
              is_active
  `,

  update: `
    UPDATE users
    SET email = $2,
        full_name = $3,
        role = $4,
        is_active = $5,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id,
              username,
              email,
              role,
              updated_at,
              full_name,
              is_active
  `,

  updatePassword: `
    UPDATE users
    SET password_hash = $2,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id,
              username,
              email
  `,

  updateLastLogin: `
    UPDATE users
    SET updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id
  `,

  deactivate: `
    UPDATE users
    SET is_active = false,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id
  `,

  delete: `
    DELETE FROM users
    WHERE id = $1
    RETURNING id
  `,

  findByRole: `
    SELECT id,
           username,
           email,
           role
    FROM users
    WHERE role = $1
    ORDER BY username ASC
  `,

  countByRole: `
    SELECT role, COUNT(*) AS count
    FROM users
    GROUP BY role
    ORDER BY count DESC
  `,

  search: `
    SELECT id,
           username,
           email,
           role
    FROM users
    WHERE username ILIKE $1
       OR email ILIKE $1
    ORDER BY username ASC
  `,

  existsByEmail: `
    SELECT id
    FROM users
    WHERE email = $1
  `,
};


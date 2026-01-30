export const UsersQueries = {
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
    SET email = $2, full_name = $3, role = $4, is_active = $5, updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, username, email, full_name, role, is_active, updated_at
  `,

  updatePassword: `
    UPDATE users
    SET password_hash = $2, updated_at = CURRENT_TIMESTAMP
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
    SET is_active = false, updated_at = CURRENT_TIMESTAMP
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
    WHERE full_name ILIKE $1 OR email ILIKE $1
    ORDER BY full_name ASC
  `,
};
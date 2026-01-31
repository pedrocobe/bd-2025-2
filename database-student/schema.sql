-- ESQUEMA DE BASE DE DATOS - E-COMMERCE EXAM

-- PASO 1: TIPOS ENUM
CREATE TYPE user_role AS ENUM ('admin', 'employee');
CREATE TYPE order_status AS ENUM ('pending', 'paid', 'shipped', 'cancelled');

-- PASO 2: TABLAS

-- USERS
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  full_name VARCHAR(100) NOT NULL,
  role user_role NOT NULL,
  is_active BOOLEAN DEFAULT true,
  last_login TIMESTAMP,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- CATEGORIES
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL,
  description TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- PRODUCTS
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL CHECK (price > 0),
  stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0),
  category_id INTEGER NOT NULL REFERENCES categories(id),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- CUSTOMERS
CREATE TABLE customers (
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(150) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  address TEXT,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- ORDERS
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  customer_id INTEGER NOT NULL REFERENCES customers(id),
  user_id INTEGER NOT NULL REFERENCES users(id),
  status order_status DEFAULT 'pending',
  total DECIMAL(12,2) NOT NULL CHECK (total >= 0),
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- ORDER ITEMS
CREATE TABLE order_items (
  id SERIAL PRIMARY KEY,
  order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id INTEGER NOT NULL REFERENCES products(id),
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  price DECIMAL(10,2) NOT NULL CHECK (price > 0),
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now(),
  UNIQUE (order_id, product_id)
);

-- AUDIT LOG
CREATE TABLE audit_log (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  action VARCHAR(100) NOT NULL,
  table_name VARCHAR(100) NOT NULL,
  record_id INTEGER,
  created_at TIMESTAMP DEFAULT now()
);

-- =========================
-- PASO 3: ÍNDICES
-- =========================
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_items_order ON order_items(order_id);

-- =========================
-- PASO 4: COMENTARIOS
-- =========================
COMMENT ON TABLE users IS 'Usuarios del sistema (administradores y empleados)';
COMMENT ON TABLE categories IS 'Categorías de productos';
COMMENT ON TABLE products IS 'Productos disponibles para la venta';
COMMENT ON TABLE customers IS 'Clientes del e-commerce';
COMMENT ON TABLE orders IS 'Pedidos realizados por clientes';
COMMENT ON TABLE order_items IS 'Detalle de productos por pedido';
COMMENT ON TABLE audit_log IS 'Registro de auditoría del sistema';

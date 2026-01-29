-- =====================================================
-- ESQUEMA DE BASE DE DATOS - E-COMMERCE EXAM
-- =====================================================
-- INSTRUCCIONES:
-- 1. Lee el archivo REQUISITOS.md para entender el sistema
-- 2. Diseña y crea TODAS las tablas necesarias
-- 3. Define relaciones (PRIMARY KEY, FOREIGN KEY)
-- 4. Agrega constraints apropiados (NOT NULL, UNIQUE, CHECK)
-- 5. Crea índices para optimizar búsquedas
-- 6. Usa tipos de datos apropiados
-- =====================================================

-- PASO 1: Crea tipos ENUM si los necesitas
CREATE TYPE user_role_enum AS ENUM ('admin', 'manager', 'employee', 'customer');
CREATE TYPE order_status_enum AS ENUM ('pending', 'processing', 'shipped', 'delivered', 'cancelled');

-- PASO 2: Crea las tablas del sistema

-- Tabla: users
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(255) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  role user_role_enum DEFAULT 'employee' NOT NULL,
  is_active BOOLEAN DEFAULT true NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  last_login TIMESTAMP
);

-- Tabla: categories
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  parent_id INTEGER REFERENCES categories(id),
  is_active BOOLEAN DEFAULT true NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Tabla: products
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  sku VARCHAR(100) UNIQUE NOT NULL,
  category_id INTEGER REFERENCES categories(id),
  price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
  cost DECIMAL(10,2) NOT NULL CHECK (cost >= 0),
  stock_quantity INTEGER DEFAULT 0 NOT NULL CHECK (stock_quantity >= 0),
  min_stock_level INTEGER DEFAULT 5 NOT NULL,
  is_active BOOLEAN DEFAULT true NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  created_by INTEGER REFERENCES users(id)
);

-- Tabla: customers
CREATE TABLE customers (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(20),
  address VARCHAR(255),
  city VARCHAR(100),
  country VARCHAR(100),
  postal_code VARCHAR(20),
  is_active BOOLEAN DEFAULT true NOT NULL,
  total_spent DECIMAL(12,2) DEFAULT 0 NOT NULL,
  order_count INTEGER DEFAULT 0 NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Tabla: orders
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  customer_id INTEGER NOT NULL REFERENCES customers(id),
  user_id INTEGER REFERENCES users(id),
  order_number VARCHAR(50) UNIQUE NOT NULL,
  status order_status_enum DEFAULT 'pending' NOT NULL,
  subtotal DECIMAL(12,2) DEFAULT 0 NOT NULL,
  tax DECIMAL(12,2) DEFAULT 0 NOT NULL,
  shipping_cost DECIMAL(12,2) DEFAULT 0 NOT NULL,
  total DECIMAL(12,2) DEFAULT 0 NOT NULL,
  shipping_address VARCHAR(255),
  shipping_city VARCHAR(100),
  shipping_country VARCHAR(100),
  shipping_postal_code VARCHAR(20),
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  shipped_at TIMESTAMP,
  delivered_at TIMESTAMP
);

-- Tabla: order_items
CREATE TABLE order_items (
  id SERIAL PRIMARY KEY,
  order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id INTEGER NOT NULL REFERENCES products(id),
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
  subtotal DECIMAL(12,2) NOT NULL CHECK (subtotal >= 0),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Tabla: audit_log (para auditoría de cambios)
CREATE TABLE audit_log (
  id SERIAL PRIMARY KEY,
  table_name VARCHAR(100) NOT NULL,
  record_id INTEGER NOT NULL,
  action VARCHAR(10) NOT NULL, -- INSERT, UPDATE, DELETE
  old_values JSONB,
  new_values JSONB,
  changed_by INTEGER REFERENCES users(id),
  changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- PASO 3: Crea índices para optimizar búsquedas
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_products_sku ON products(sku);
CREATE INDEX idx_products_is_active ON products(is_active);
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_categories_parent_id ON categories(parent_id);
CREATE INDEX idx_audit_log_table_name ON audit_log(table_name);
CREATE INDEX idx_audit_log_record_id ON audit_log(record_id);

-- PASO 4: Agrega comentarios descriptivos
COMMENT ON TABLE users IS 'Tabla de usuarios del sistema: admins, managers, employees';
COMMENT ON TABLE categories IS 'Categorías de productos con soporte para jerarquía (parent_id)';
COMMENT ON TABLE products IS 'Catálogo de productos con precio, costo e inventario';
COMMENT ON TABLE customers IS 'Base de clientes del e-commerce';
COMMENT ON TABLE orders IS 'Pedidos de clientes con estados y costos';
COMMENT ON TABLE order_items IS 'Detalles de cada artículo en un pedido';
COMMENT ON TABLE audit_log IS 'Registro de auditoría de cambios en tablas críticas';

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
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS audit_log CASCADE;
-- PASO 1: Crea tipos ENUM si los necesitas
-- Piensa qué campos tienen valores predefinidos (ej: roles, estados)
-- Usa CREATE TYPE nombre_enum AS ENUM ('valor1', 'valor2', ...)
DROP TYPE IF EXISTS user_role CASCADE;
DROP TYPE IF EXISTS order_status CASCADE;

CREATE TYPE user_role AS ENUM ('admin', 'manager', 'employee', 'readonly');
CREATE TYPE order_status AS ENUM ('pending', 'paid', 'shipped', 'delivered', 'cancelled');

-- PASO 2: Crea las tablas del sistema
-- Tablas requeridas: users, categories, products, customers, orders, order_items, audit_log
-- 
-- Para cada tabla considera:
-- - ID autoincremental (SERIAL PRIMARY KEY)
-- - Campos obligatorios (NOT NULL)
-- - Campos únicos (UNIQUE)
-- - Valores por defecto (DEFAULT)
-- - Tipos de datos apropiados (VARCHAR, INTEGER, DECIMAL, TIMESTAMP, BOOLEAN, etc.)
-- - Relaciones con otras tablas (REFERENCES)
-- 1. Tabla de Usuarios
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255),
    full_name VARCHAR(150) NOT NULL,
    role user_role DEFAULT 'employee',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);

-- 2. Tabla de Productos
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    sku VARCHAR(50) UNIQUE NOT NULL, -- Identificador único de inventario
    name VARCHAR(150) NOT NULL,
    description VARCHAR(50) NOT NULL,
    category_id INTEGER NOT NULL, -- Categoría como texto simple según tu petición
    price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    cost DECIMAL(12,2) NOT NULL DEFAULT 0,
    stock_quantity INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    min_stock_level INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Tabla de Clientes
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(150) NOT NULL,
    last_name VARCHAR(150) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(100),
    country VARCHAR(100),
    total_spent DECIMAL(12,2) DEFAULT 0.00,
    orders_count INTEGER DEFAULT 0 -- Cantidad total de pedidos realizados
);

-- 4. Tabla de Pedidos (Orders)
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    order_number VARCHAR(20) UNIQUE, -- Se llenará con el Trigger 9
    customer_id INTEGER REFERENCES customers(id), -- Relación con cliente
    user_id INTEGER REFERENCES users(id),
    status order_status DEFAULT 'pending',
    total DECIMAL(10,2) DEFAULT 0.00,
    tax DECIMAL(10,2) DEFAULT 0.00,
    subtotal DECIMAL(10,2) DEFAULT 0.00,
    shipping_cost DECIMAL(10,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Detalle de Pedidos (Muchos a Muchos entre Orders y Products)
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE NOT NULL,
    product_id INTEGER REFERENCES products(id) ON DELETE RESTRICT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    subtotal DECIMAL(10,2) NOT NULL
);

-- 6. Categorias
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_id INTEGER REFERENCES categories(id) ON DELETE SET NULL
);

-- 7. Registro de Auditoría (Para trazabilidad)
CREATE TABLE audit_log (
    id SERIAL PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    record_id INTEGER NOT NULL,
    action VARCHAR(20) NOT NULL, -- INSERT, UPDATE, DELETE
    old_values JSONB,
    new_values JSONB,
    user_id INTEGER REFERENCES users(id),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- PASO 3: Crea índices para optimizar búsquedas
-- Identifica columnas que se usarán frecuentemente en WHERE, JOIN u ORDER BY
-- Usa CREATE INDEX idx_nombre ON tabla(columna)
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_name ON products USING gin(to_tsvector('spanish', name)); -- Búsqueda por texto
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_order_items_order ON order_items(order_id);

-- PASO 4: Agrega comentarios descriptivos
-- Usa COMMENT ON TABLE nombre_tabla IS 'Descripción'
-- Esto ayuda a documentar tu base de datos
COMMENT ON TABLE users IS 'Almacena credenciales y roles de acceso al sistema.';
COMMENT ON TABLE products IS 'Inventario central con precios y costos de adquisición.';
COMMENT ON TABLE orders IS 'Registro principal de transacciones de venta.';
COMMENT ON TABLE audit_log IS 'Historial de cambios manuales en tablas críticas.';
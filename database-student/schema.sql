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
-- Piensa qué campos tienen valores predefinidos (ej: roles, estados)
-- Usa CREATE TYPE nombre_enum AS ENUM ('valor1', 'valor2', ...)

CREATE TYPE user_role AS ENUM ('admin', 'manager', 'employee');
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

-- 1. Tabla de Usuarios (No depende de nadie)
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role user_role DEFAULT 'employee',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);

-- 2. Tabla de Clientes (No depende de nadie)
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Tabla de Categorías (Auto-referenciada para jerarquía)
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    parent_id INTEGER REFERENCES categories(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Tabla de Productos (Depende de Categorías)
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    category_id INTEGER REFERENCES categories(id) NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(12, 2) NOT NULL CHECK (price > 0),
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    sku VARCHAR(50) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Tabla de Pedidos (Depende de Customers y Users)
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id) NOT NULL,
    user_id INTEGER REFERENCES users(id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status order_status DEFAULT 'pending',
    total_amount DECIMAL(12, 2) DEFAULT 0 CHECK (total_amount >= 0),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. Detalle de Pedidos (Depende de Orders y Products)
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(12, 2) NOT NULL,
    subtotal DECIMAL(12, 2) GENERATED ALWAYS AS (quantity * unit_price) STORED
);

-- 7. Log de Auditoría (Depende de Users)
CREATE TABLE audit_log (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    action VARCHAR(50) NOT NULL,
    table_name VARCHAR(50) NOT NULL,
    record_id INTEGER,
    old_data JSONB,
    new_data JSONB,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PASO 3: Crea índices para optimizar búsquedas
-- Identifica columnas que se usarán frecuentemente en WHERE, JOIN u ORDER BY
-- Usa CREATE INDEX idx_nombre ON tabla(columna)

-- Búsqueda de productos por nombre (búsquedas frecuentes)
CREATE INDEX idx_products_name ON products(name);

-- Búsqueda de pedidos de un cliente específico
CREATE INDEX idx_orders_customer ON orders(customer_id);

-- Búsqueda por jerarquía de categorías
CREATE INDEX idx_categories_parent ON categories(parent_id);

-- Para el Log de auditoría (ordenado por tiempo)
CREATE INDEX idx_audit_date ON audit_log(changed_at);

-- PASO 4: Agrega comentarios descriptivos
-- Usa COMMENT ON TABLE nombre_tabla IS 'Descripción'
-- Esto ayuda a documentar tu base de datos

COMMENT ON COLUMN categories.parent_id IS 'ID de la categoría superior para crear subcategorías';
COMMENT ON COLUMN products.stock IS 'Cantidad disponible en almacén. No puede ser negativa';
COMMENT ON TABLE order_items IS 'Relación muchos a muchos entre pedidos y productos con histórico de precio';
-- =====================================================
-- ESQUEMA DE BASE DE DATOS - E-COMMERCE EXAM
-- =====================================================
-- Sistema de E-commerce con gestión de usuarios, productos, clientes, pedidos y reportería
-- Base de datos: PostgreSQL 16
-- =====================================================

-- =====================================================
-- PASO 1: LIMPIAR TABLAS EXISTENTES (si existen)
-- =====================================================
SET client_encoding = 'UTF8';

DROP TABLE IF EXISTS audit_log CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- =====================================================
-- PASO 2: CREAR TIPOS ENUM
-- =====================================================

-- Tipo ENUM para roles de usuarios
CREATE TYPE user_role AS ENUM ('admin', 'manager', 'employee');

-- Tipo ENUM para estados de pedidos
CREATE TYPE order_status AS ENUM ('pending', 'processing', 'shipped', 'delivered', 'cancelled');

-- =====================================================
-- PASO 3: CREAR TABLAS
-- =====================================================

-- -----------------------------------------------------
-- Tabla: users
-- Descripción: Usuarios del sistema (empleados y administradores)
-- -----------------------------------------------------
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role user_role NOT NULL DEFAULT 'employee',
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT chk_username_length CHECK (LENGTH(username) >= 3)
);

-- -----------------------------------------------------
-- Tabla: categories
-- Descripción: Categorías de productos con jerarquía (árbol)
-- -----------------------------------------------------
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_id INTEGER,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    CONSTRAINT fk_category_parent FOREIGN KEY (parent_id) 
        REFERENCES categories(id) ON DELETE SET NULL,
    
    -- Constraints
    CONSTRAINT chk_category_name_length CHECK (LENGTH(name) >= 2),
    CONSTRAINT chk_no_self_reference CHECK (id != parent_id)
);

-- -----------------------------------------------------
-- Tabla: products
-- Descripción: Productos del inventario
-- -----------------------------------------------------
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    sku VARCHAR(50) NOT NULL UNIQUE,
    category_id INTEGER,
    price DECIMAL(10, 2) NOT NULL,
    cost DECIMAL(10, 2) NOT NULL,
    stock_quantity INTEGER NOT NULL DEFAULT 0,
    min_stock_level INTEGER NOT NULL DEFAULT 10,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER,
    
    -- Foreign Keys
    CONSTRAINT fk_product_category FOREIGN KEY (category_id) 
        REFERENCES categories(id) ON DELETE SET NULL,
    CONSTRAINT fk_product_created_by FOREIGN KEY (created_by) 
        REFERENCES users(id) ON DELETE SET NULL,
    
    -- Constraints
    CONSTRAINT chk_price_positive CHECK (price >= 0),
    CONSTRAINT chk_cost_positive CHECK (cost >= 0),
    CONSTRAINT chk_stock_non_negative CHECK (stock_quantity >= 0),
    CONSTRAINT chk_min_stock_positive CHECK (min_stock_level >= 0),
    CONSTRAINT chk_sku_format CHECK (LENGTH(sku) >= 3)
);

-- -----------------------------------------------------
-- Tabla: customers
-- Descripción: Clientes que realizan compras
-- -----------------------------------------------------
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    is_active BOOLEAN NOT NULL DEFAULT true,
    total_spent DECIMAL(12, 2) NOT NULL DEFAULT 0,
    order_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_customer_email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT chk_first_name_length CHECK (LENGTH(first_name) >= 2),
    CONSTRAINT chk_last_name_length CHECK (LENGTH(last_name) >= 2),
    CONSTRAINT chk_total_spent_non_negative CHECK (total_spent >= 0),
    CONSTRAINT chk_order_count_non_negative CHECK (order_count >= 0)
);

-- -----------------------------------------------------
-- Tabla: orders
-- Descripción: Pedidos realizados por clientes
-- -----------------------------------------------------
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    order_number VARCHAR(50) NOT NULL UNIQUE,
    customer_id INTEGER NOT NULL,
    status order_status NOT NULL DEFAULT 'pending',
    subtotal DECIMAL(10, 2) NOT NULL DEFAULT 0,
    tax DECIMAL(10, 2) NOT NULL DEFAULT 0,
    shipping_cost DECIMAL(10, 2) NOT NULL DEFAULT 0,
    total DECIMAL(10, 2) NOT NULL DEFAULT 0,
    shipping_address TEXT NOT NULL,
    shipping_city VARCHAR(100) NOT NULL,
    shipping_country VARCHAR(100) NOT NULL,
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    shipped_at TIMESTAMP,
    delivered_at TIMESTAMP,
    created_by INTEGER,
    
    -- Foreign Keys
    CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) 
        REFERENCES customers(id) ON DELETE RESTRICT,
    CONSTRAINT fk_order_created_by FOREIGN KEY (created_by) 
        REFERENCES users(id) ON DELETE SET NULL,
    
    -- Constraints
    CONSTRAINT chk_subtotal_non_negative CHECK (subtotal >= 0),
    CONSTRAINT chk_tax_non_negative CHECK (tax >= 0),
    CONSTRAINT chk_shipping_cost_non_negative CHECK (shipping_cost >= 0),
    CONSTRAINT chk_total_non_negative CHECK (total >= 0),
    CONSTRAINT chk_order_number_format CHECK (LENGTH(order_number) >= 5),
    CONSTRAINT chk_shipped_after_created CHECK (shipped_at IS NULL OR shipped_at >= created_at),
    CONSTRAINT chk_delivered_after_shipped CHECK (delivered_at IS NULL OR shipped_at IS NULL OR delivered_at >= shipped_at)
);

-- -----------------------------------------------------
-- Tabla: order_items
-- Descripción: Detalles de productos en cada pedido (relación muchos a muchos)
-- -----------------------------------------------------
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    CONSTRAINT fk_order_item_order FOREIGN KEY (order_id) 
        REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_order_item_product FOREIGN KEY (product_id) 
        REFERENCES products(id) ON DELETE RESTRICT,
    
    -- Constraints
    CONSTRAINT chk_quantity_positive CHECK (quantity > 0),
    CONSTRAINT chk_unit_price_positive CHECK (unit_price >= 0),
    CONSTRAINT chk_subtotal_non_negative CHECK (subtotal >= 0),
    
    -- Índice único para evitar duplicados de producto en la misma orden
    CONSTRAINT uk_order_product UNIQUE (order_id, product_id)
);

-- -----------------------------------------------------
-- Tabla: audit_log
-- Descripción: Registro de auditoría para seguimiento de cambios
-- -----------------------------------------------------
CREATE TABLE audit_log (
    id SERIAL PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    record_id INTEGER NOT NULL,
    action VARCHAR(20) NOT NULL,
    old_data JSONB,
    new_data JSONB,
    changed_by INTEGER,
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(50),
    
    -- Foreign Keys
    CONSTRAINT fk_audit_changed_by FOREIGN KEY (changed_by) 
        REFERENCES users(id) ON DELETE SET NULL,
    
    -- Constraints
    CONSTRAINT chk_action_type CHECK (action IN ('INSERT', 'UPDATE', 'DELETE'))
);

-- =====================================================
-- PASO 4: CREAR ÍNDICES PARA OPTIMIZACIÓN
-- =====================================================

-- Índices para users
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_is_active ON users(is_active);

-- Índices para categories
CREATE INDEX idx_categories_parent_id ON categories(parent_id);
CREATE INDEX idx_categories_name ON categories(name);
CREATE INDEX idx_categories_is_active ON categories(is_active);

-- Índices para products
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_products_sku ON products(sku);
CREATE INDEX idx_products_name ON products(name);
CREATE INDEX idx_products_is_active ON products(is_active);
CREATE INDEX idx_products_stock_quantity ON products(stock_quantity);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_created_by ON products(created_by);

-- Índices para customers
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_customers_city ON customers(city);
CREATE INDEX idx_customers_country ON customers(country);
CREATE INDEX idx_customers_is_active ON customers(is_active);
CREATE INDEX idx_customers_total_spent ON customers(total_spent);
CREATE INDEX idx_customers_last_name ON customers(last_name);

-- Índices para orders
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_order_number ON orders(order_number);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at);
CREATE INDEX idx_orders_total ON orders(total);
CREATE INDEX idx_orders_created_by ON orders(created_by);

-- Índices para order_items
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- Índices para audit_log
CREATE INDEX idx_audit_log_table_name ON audit_log(table_name);
CREATE INDEX idx_audit_log_record_id ON audit_log(record_id);
CREATE INDEX idx_audit_log_changed_at ON audit_log(changed_at);
CREATE INDEX idx_audit_log_changed_by ON audit_log(changed_by);

-- =====================================================
-- PASO 5: AGREGAR COMENTARIOS DESCRIPTIVOS
-- =====================================================

-- Comentarios en tablas
COMMENT ON TABLE users IS 'Usuarios del sistema (administradores, gerentes y empleados)';
COMMENT ON TABLE categories IS 'Categorías de productos con estructura jerárquica';
COMMENT ON TABLE products IS 'Productos del inventario con información de precio y stock';
COMMENT ON TABLE customers IS 'Clientes que realizan compras en el sistema';
COMMENT ON TABLE orders IS 'Pedidos realizados por los clientes';
COMMENT ON TABLE order_items IS 'Detalles de productos en cada pedido';
COMMENT ON TABLE audit_log IS 'Registro de auditoría para rastrear cambios en el sistema';

-- Comentarios en columnas importantes
COMMENT ON COLUMN users.role IS 'Rol del usuario: admin, manager o employee';
COMMENT ON COLUMN users.password_hash IS 'Contraseña hasheada con bcrypt';
COMMENT ON COLUMN products.sku IS 'Código único de identificación del producto';
COMMENT ON COLUMN products.min_stock_level IS 'Nivel mínimo de inventario antes de reordenar';
COMMENT ON COLUMN customers.total_spent IS 'Total acumulado de compras del cliente';
COMMENT ON COLUMN customers.order_count IS 'Número total de pedidos realizados';
COMMENT ON COLUMN orders.order_number IS 'Número único de orden para rastreo';
COMMENT ON COLUMN orders.status IS 'Estado del pedido: pending, processing, shipped, delivered, cancelled';
COMMENT ON COLUMN order_items.subtotal IS 'Subtotal del item: quantity * unit_price';

-- =====================================================
-- PASO 6: CREAR FUNCIÓN PARA ACTUALIZAR updated_at
-- =====================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- PASO 7: CREAR TRIGGERS PARA updated_at
-- =====================================================

CREATE TRIGGER trg_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_categories_updated_at
    BEFORE UPDATE ON categories
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_products_updated_at
    BEFORE UPDATE ON products
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_customers_updated_at
    BEFORE UPDATE ON customers
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_orders_updated_at
    BEFORE UPDATE ON orders
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- FIN DEL ESQUEMA
-- =====================================================

-- Verificación: Listar todas las tablas creadas
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

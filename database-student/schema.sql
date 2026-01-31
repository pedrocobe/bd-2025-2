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

DO $$
BEGIN
	-- Roles de usuario usados por el backend (ver UserRole en el código)
	CREATE TYPE user_role AS ENUM ('admin', 'manager', 'employee', 'customer');
EXCEPTION
	WHEN duplicate_object THEN NULL;
END $$;

DO $$
BEGIN
	-- Estados de pedidos usados por el sistema y triggers
	CREATE TYPE order_status AS ENUM ('pending', 'processing', 'shipped', 'delivered', 'cancelled');
EXCEPTION
	WHEN duplicate_object THEN NULL;
END $$;


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


CREATE TABLE IF NOT EXISTS users (
	id              SERIAL PRIMARY KEY,
	username        VARCHAR(50)  NOT NULL,
	email           VARCHAR(255) NOT NULL,
	password_hash   VARCHAR(255) NOT NULL,
	full_name       VARCHAR(150) NOT NULL,
	role            user_role    NOT NULL DEFAULT 'employee',
	is_active       BOOLEAN      NOT NULL DEFAULT TRUE,
	last_login      TIMESTAMP,
	created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT uq_users_username UNIQUE (username),
	CONSTRAINT uq_users_email UNIQUE (email)
);


CREATE TABLE IF NOT EXISTS categories (
	id          SERIAL PRIMARY KEY,
	name        VARCHAR(120) NOT NULL,
	description TEXT,
	parent_id   INTEGER,
	is_active   BOOLEAN      NOT NULL DEFAULT TRUE,
	created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT fk_categories_parent
		FOREIGN KEY (parent_id) REFERENCES categories(id)
		ON UPDATE CASCADE
		ON DELETE SET NULL,
	CONSTRAINT uq_categories_name_parent UNIQUE (name, parent_id)
);


CREATE TABLE IF NOT EXISTS products (
	id             SERIAL PRIMARY KEY,
	name           VARCHAR(180)  NOT NULL,
	sku            VARCHAR(80)   NOT NULL,
	description    TEXT,
	price          DECIMAL(10,2) NOT NULL,
	cost           DECIMAL(10,2) NOT NULL,
	stock_quantity INTEGER       NOT NULL DEFAULT 0,
	min_stock_level INTEGER      NOT NULL DEFAULT 0,
	category_id    INTEGER       NOT NULL,
	created_by     INTEGER,
	is_active      BOOLEAN       NOT NULL DEFAULT TRUE,
	created_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT uq_products_sku UNIQUE (sku),
	CONSTRAINT fk_products_category
		FOREIGN KEY (category_id) REFERENCES categories(id)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
	CONSTRAINT fk_products_created_by
		FOREIGN KEY (created_by) REFERENCES users(id)
		ON UPDATE CASCADE
		ON DELETE SET NULL,
	CONSTRAINT chk_products_price_positive CHECK (price > 0),
	CONSTRAINT chk_products_cost_positive CHECK (cost > 0),
	CONSTRAINT chk_products_stock_nonnegative CHECK (stock_quantity >= 0),
	CONSTRAINT chk_products_min_stock_nonnegative CHECK (min_stock_level >= 0)
);


CREATE TABLE IF NOT EXISTS customers (
	id           SERIAL PRIMARY KEY,
	first_name   VARCHAR(100) NOT NULL,
	last_name    VARCHAR(100) NOT NULL,
	email        VARCHAR(255) NOT NULL,
	phone        VARCHAR(50),
	address      VARCHAR(255),
	city         VARCHAR(120),
	country      VARCHAR(120),
	postal_code  VARCHAR(20),
	is_active    BOOLEAN      NOT NULL DEFAULT TRUE,
	total_spent  DECIMAL(12,2) NOT NULL DEFAULT 0,
	order_count  INTEGER      NOT NULL DEFAULT 0,
	created_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT uq_customers_email UNIQUE (email),
	CONSTRAINT chk_customers_total_spent_nonnegative CHECK (total_spent >= 0),
	CONSTRAINT chk_customers_order_count_nonnegative CHECK (order_count >= 0)
);


CREATE TABLE IF NOT EXISTS orders (
	id               SERIAL PRIMARY KEY,
	customer_id      INTEGER       NOT NULL,
	order_number     VARCHAR(30),
	status           order_status  NOT NULL DEFAULT 'pending',
	subtotal         DECIMAL(10,2) NOT NULL DEFAULT 0,
	tax              DECIMAL(10,2) NOT NULL DEFAULT 0,
	shipping_cost    DECIMAL(10,2) NOT NULL DEFAULT 0,
	total            DECIMAL(10,2) NOT NULL DEFAULT 0,
	shipping_address VARCHAR(255),
	shipping_city    VARCHAR(120),
	shipping_country VARCHAR(120),
	created_by       INTEGER,
	shipped_at       TIMESTAMP,
	delivered_at     TIMESTAMP,
	created_at       TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at       TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT fk_orders_customer
		FOREIGN KEY (customer_id) REFERENCES customers(id)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
	CONSTRAINT fk_orders_created_by
		FOREIGN KEY (created_by) REFERENCES users(id)
		ON UPDATE CASCADE
		ON DELETE SET NULL,
	CONSTRAINT uq_orders_order_number UNIQUE (order_number),
	CONSTRAINT chk_orders_subtotal_nonnegative CHECK (subtotal >= 0),
	CONSTRAINT chk_orders_tax_nonnegative CHECK (tax >= 0),
	CONSTRAINT chk_orders_shipping_nonnegative CHECK (shipping_cost >= 0),
	CONSTRAINT chk_orders_total_nonnegative CHECK (total >= 0)
);


CREATE TABLE IF NOT EXISTS order_items (
	id         SERIAL PRIMARY KEY,
	order_id   INTEGER       NOT NULL,
	product_id INTEGER       NOT NULL,
	quantity   INTEGER       NOT NULL,
	unit_price DECIMAL(10,2) NOT NULL,
	subtotal   DECIMAL(10,2) NOT NULL DEFAULT 0,
	created_at TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT fk_order_items_order
		FOREIGN KEY (order_id) REFERENCES orders(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT fk_order_items_product
		FOREIGN KEY (product_id) REFERENCES products(id)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
	CONSTRAINT chk_order_items_quantity_positive CHECK (quantity > 0),
	CONSTRAINT chk_order_items_unit_price_positive CHECK (unit_price > 0),
	CONSTRAINT chk_order_items_subtotal_nonnegative CHECK (subtotal >= 0)
);


CREATE TABLE IF NOT EXISTS audit_log (
	id         SERIAL PRIMARY KEY,
	table_name VARCHAR(100) NOT NULL,
	record_id  INTEGER      NOT NULL,
	action     VARCHAR(10)  NOT NULL,
	old_values JSONB,
	new_values JSONB,
	changed_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT chk_audit_log_action CHECK (action IN ('INSERT', 'UPDATE', 'DELETE'))
);


-- PASO 3: Crea índices para optimizar búsquedas
-- Identifica columnas que se usarán frecuentemente en WHERE, JOIN u ORDER BY
-- Usa CREATE INDEX idx_nombre ON tabla(columna)

CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);

CREATE INDEX IF NOT EXISTS idx_categories_parent_id ON categories(parent_id);

CREATE INDEX IF NOT EXISTS idx_products_category_id ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_is_active ON products(is_active);
CREATE INDEX IF NOT EXISTS idx_products_name ON products(name);

CREATE INDEX IF NOT EXISTS idx_customers_city ON customers(city);

CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at);

CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);

CREATE INDEX IF NOT EXISTS idx_audit_log_table_record ON audit_log(table_name, record_id);
CREATE INDEX IF NOT EXISTS idx_audit_log_changed_at ON audit_log(changed_at);


-- PASO 4: Agrega comentarios descriptivos
-- Usa COMMENT ON TABLE nombre_tabla IS 'Descripción'
-- Esto ayuda a documentar tu base de datos

COMMENT ON TABLE users IS 'Usuarios del sistema (autenticación y roles)';
COMMENT ON TABLE categories IS 'Categorías de productos con jerarquía padre-hijo';
COMMENT ON TABLE products IS 'Productos del catálogo e inventario';
COMMENT ON TABLE customers IS 'Clientes (compradores)';
COMMENT ON TABLE orders IS 'Pedidos realizados por clientes';
COMMENT ON TABLE order_items IS 'Detalle de items por pedido';
COMMENT ON TABLE audit_log IS 'Bitácora de auditoría de cambios (productos)';


/* actualizacion 30/01/2026 07:21*/

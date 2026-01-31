-- =====================================================
-- PERMISOS Y ROLES - E-COMMERCE EXAM
-- =====================================================
-- Este archivo configura roles de usuario y permisos para
-- garantizar la seguridad de la base de datos
-- =====================================================

-- =====================================================
-- PASO 1: Eliminar roles existentes (si existen)
-- =====================================================
SET client_encoding = 'UTF8';

DO $$
BEGIN
    -- Eliminar roles si existen
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'ecommerce_admin') THEN
        DROP ROLE ecommerce_admin;
    END IF;
    
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'ecommerce_manager') THEN
        DROP ROLE ecommerce_manager;
    END IF;
    
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'ecommerce_employee') THEN
        DROP ROLE ecommerce_employee;
    END IF;
    
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'ecommerce_readonly') THEN
        DROP ROLE ecommerce_readonly;
    END IF;
END $$;


-- =====================================================
-- PASO 2: Crear roles de la base de datos
-- =====================================================

-- ROL 1: Admin - Control total del sistema
CREATE ROLE ecommerce_admin WITH
    LOGIN
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    NOREPLICATION
    PASSWORD 'admin_secure_2024';

COMMENT ON ROLE ecommerce_admin IS 
'Administrador del sistema con acceso total a todas las operaciones';


-- ROL 2: Manager - Gestión de productos, categorías y reportes
CREATE ROLE ecommerce_manager WITH
    LOGIN
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    NOREPLICATION
    PASSWORD 'manager_secure_2024';

COMMENT ON ROLE ecommerce_manager IS 
'Gerente con permisos para gestionar productos, ver reportes y gestionar pedidos';


-- ROL 3: Employee - Crear pedidos y gestionar clientes
CREATE ROLE ecommerce_employee WITH
    LOGIN
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    NOREPLICATION
    PASSWORD 'employee_secure_2024';

COMMENT ON ROLE ecommerce_employee IS 
'Empleado con permisos para crear pedidos y gestionar clientes';


-- ROL 4: ReadOnly - Solo lectura para reportes
CREATE ROLE ecommerce_readonly WITH
    LOGIN
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    NOREPLICATION
    PASSWORD 'readonly_secure_2024';

COMMENT ON ROLE ecommerce_readonly IS 
'Usuario de solo lectura para consultas y reportes';


-- =====================================================
-- PASO 3: Otorgar permisos al rol ADMIN
-- =====================================================

-- ADMIN tiene acceso completo a todas las tablas
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ecommerce_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ecommerce_admin;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO ecommerce_admin;

-- Permisos futuros para objetos nuevos
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
    GRANT ALL ON TABLES TO ecommerce_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
    GRANT ALL ON SEQUENCES TO ecommerce_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
    GRANT EXECUTE ON FUNCTIONS TO ecommerce_admin;


-- =====================================================
-- PASO 4: Otorgar permisos al rol MANAGER
-- =====================================================

-- MANAGER: Acceso completo a productos, categorías y pedidos
GRANT SELECT, INSERT, UPDATE, DELETE ON products TO ecommerce_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON categories TO ecommerce_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON orders TO ecommerce_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON order_items TO ecommerce_manager;

-- MANAGER: Lectura de clientes
GRANT SELECT ON customers TO ecommerce_manager;

-- MANAGER: Lectura de usuarios (no puede modificar)
GRANT SELECT ON users TO ecommerce_manager;

-- MANAGER: Solo lectura de auditoría
GRANT SELECT ON audit_log TO ecommerce_manager;

-- MANAGER: Permisos en secuencias
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO ecommerce_manager;

-- MANAGER: Ejecutar funciones de reportes
GRANT EXECUTE ON FUNCTION get_sales_total TO ecommerce_manager;
GRANT EXECUTE ON FUNCTION get_low_stock_products TO ecommerce_manager;
GRANT EXECUTE ON FUNCTION get_total_inventory_value TO ecommerce_manager;
GRANT EXECUTE ON FUNCTION get_customer_stats TO ecommerce_manager;
GRANT EXECUTE ON FUNCTION get_top_selling_products TO ecommerce_manager;
GRANT EXECUTE ON FUNCTION get_daily_sales_report TO ecommerce_manager;
GRANT EXECUTE ON FUNCTION search_products TO ecommerce_manager;
GRANT EXECUTE ON FUNCTION calculate_conversion_rate TO ecommerce_manager;


-- =====================================================
-- PASO 5: Otorgar permisos al rol EMPLOYEE
-- =====================================================

-- EMPLOYEE: Lectura de productos y categorías
GRANT SELECT ON products TO ecommerce_employee;
GRANT SELECT ON categories TO ecommerce_employee;

-- EMPLOYEE: Acceso completo a clientes
GRANT SELECT, INSERT, UPDATE ON customers TO ecommerce_employee;

-- EMPLOYEE: Acceso completo a pedidos y order_items
GRANT SELECT, INSERT, UPDATE, DELETE ON orders TO ecommerce_employee;
GRANT SELECT, INSERT, UPDATE, DELETE ON order_items TO ecommerce_employee;

-- EMPLOYEE: Solo lectura de usuarios
GRANT SELECT ON users TO ecommerce_employee;

-- EMPLOYEE: No acceso a audit_log

-- EMPLOYEE: Permisos en secuencias necesarias
GRANT USAGE, SELECT ON SEQUENCE orders_id_seq TO ecommerce_employee;
GRANT USAGE, SELECT ON SEQUENCE order_items_id_seq TO ecommerce_employee;
GRANT USAGE, SELECT ON SEQUENCE customers_id_seq TO ecommerce_employee;

-- EMPLOYEE: Funciones básicas
GRANT EXECUTE ON FUNCTION check_stock_availability TO ecommerce_employee;
GRANT EXECUTE ON FUNCTION calculate_volume_discount TO ecommerce_employee;
GRANT EXECUTE ON FUNCTION get_customer_stats TO ecommerce_employee;
GRANT EXECUTE ON FUNCTION search_products TO ecommerce_employee;


-- =====================================================
-- PASO 6: Otorgar permisos al rol READONLY
-- =====================================================

-- READONLY: Solo SELECT en todas las tablas principales
GRANT SELECT ON products TO ecommerce_readonly;
GRANT SELECT ON categories TO ecommerce_readonly;
GRANT SELECT ON customers TO ecommerce_readonly;
GRANT SELECT ON orders TO ecommerce_readonly;
GRANT SELECT ON order_items TO ecommerce_readonly;
GRANT SELECT ON users TO ecommerce_readonly;

-- READONLY: No acceso a audit_log (información sensible)

-- READONLY: Ejecutar todas las funciones de consulta
GRANT EXECUTE ON FUNCTION get_sales_total TO ecommerce_readonly;
GRANT EXECUTE ON FUNCTION get_low_stock_products TO ecommerce_readonly;
GRANT EXECUTE ON FUNCTION get_total_inventory_value TO ecommerce_readonly;
GRANT EXECUTE ON FUNCTION get_customer_stats TO ecommerce_readonly;
GRANT EXECUTE ON FUNCTION get_top_selling_products TO ecommerce_readonly;
GRANT EXECUTE ON FUNCTION get_daily_sales_report TO ecommerce_readonly;
GRANT EXECUTE ON FUNCTION search_products TO ecommerce_readonly;
GRANT EXECUTE ON FUNCTION calculate_conversion_rate TO ecommerce_readonly;
GRANT EXECUTE ON FUNCTION get_product_age TO ecommerce_readonly;


-- =====================================================
-- PASO 7: Configurar Row Level Security (RLS) - AVANZADO
-- =====================================================

-- Habilitar RLS en tabla de pedidos
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Política: Los empleados solo pueden ver sus propios pedidos
CREATE POLICY employee_own_orders ON orders
    FOR SELECT
    TO ecommerce_employee
    USING (created_by = current_setting('app.current_user_id')::INTEGER);

-- Política: Los managers y admins pueden ver todos los pedidos
CREATE POLICY manager_all_orders ON orders
    FOR ALL
    TO ecommerce_manager, ecommerce_admin
    USING (true);


-- Habilitar RLS en tabla de clientes
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;

-- Política: Todos pueden ver todos los clientes
CREATE POLICY all_view_customers ON customers
    FOR SELECT
    TO ecommerce_employee, ecommerce_manager, ecommerce_admin
    USING (true);

-- Política: Solo managers y admins pueden modificar clientes
CREATE POLICY manager_modify_customers ON customers
    FOR ALL
    TO ecommerce_manager, ecommerce_admin
    USING (true);


-- =====================================================
-- PASO 8: Crear vistas para reportes seguros
-- =====================================================

-- Vista: Resumen de productos (sin costos para employees)
CREATE OR REPLACE VIEW vw_products_summary AS
SELECT 
    p.id,
    p.name,
    p.sku,
    p.price,
    p.stock_quantity,
    p.is_active,
    c.name AS category_name
FROM products p
LEFT JOIN categories c ON p.category_id = c.id;

GRANT SELECT ON vw_products_summary TO ecommerce_employee, ecommerce_manager, ecommerce_admin, ecommerce_readonly;


-- Vista: Resumen de pedidos
CREATE OR REPLACE VIEW vw_orders_summary AS
SELECT 
    o.id,
    o.order_number,
    o.status,
    o.total,
    o.created_at,
    (c.first_name || ' ' || c.last_name) AS customer_name,
    c.email AS customer_email,
    u.full_name AS created_by_name
FROM orders o
INNER JOIN customers c ON o.customer_id = c.id
LEFT JOIN users u ON o.created_by = u.id;

GRANT SELECT ON vw_orders_summary TO ecommerce_employee, ecommerce_manager, ecommerce_admin, ecommerce_readonly;


-- Vista: Top clientes (solo para managers y admins)
CREATE OR REPLACE VIEW vw_top_customers AS
SELECT 
    c.id,
    (c.first_name || ' ' || c.last_name) AS customer_name,
    c.email,
    c.city,
    c.total_spent,
    c.order_count
FROM customers c
WHERE c.is_active = true
ORDER BY c.total_spent DESC
LIMIT 100;

GRANT SELECT ON vw_top_customers TO ecommerce_manager, ecommerce_admin, ecommerce_readonly;


-- Vista: Dashboard metrics
CREATE OR REPLACE VIEW vw_dashboard_metrics AS
SELECT 
    (SELECT COUNT(*) FROM customers WHERE is_active = true) AS total_customers,
    (SELECT COUNT(*) FROM products WHERE is_active = true) AS total_products,
    (SELECT COUNT(*) FROM orders WHERE status != 'cancelled') AS total_orders,
    (SELECT COALESCE(SUM(total), 0) FROM orders WHERE status != 'cancelled') AS total_revenue,
    (SELECT COUNT(*) FROM products WHERE stock_quantity < min_stock_level) AS products_low_stock;

GRANT SELECT ON vw_dashboard_metrics TO ecommerce_employee, ecommerce_manager, ecommerce_admin, ecommerce_readonly;


-- =====================================================
-- PASO 9: Configurar límites de conexión por rol
-- =====================================================

ALTER ROLE ecommerce_admin CONNECTION LIMIT 10;
ALTER ROLE ecommerce_manager CONNECTION LIMIT 20;
ALTER ROLE ecommerce_employee CONNECTION LIMIT 50;
ALTER ROLE ecommerce_readonly CONNECTION LIMIT 30;


-- =====================================================
-- PASO 10: Logging y Auditoría
-- =====================================================

-- Configurar logging para acciones de admin
ALTER ROLE ecommerce_admin SET log_statement = 'all';
ALTER ROLE ecommerce_manager SET log_statement = 'mod';
ALTER ROLE ecommerce_employee SET log_statement = 'ddl';


-- =====================================================
-- FIN DE CONFIGURACIÓN DE PERMISOS
-- =====================================================

-- Verificación: Listar todos los roles creados
SELECT 
    rolname AS role_name,
    rolcanlogin AS can_login,
    rolconnlimit AS connection_limit
FROM pg_roles
WHERE rolname LIKE 'ecommerce_%'
ORDER BY rolname;

-- Verificación: Listar permisos por tabla
SELECT 
    grantee,
    table_name,
    privilege_type
FROM information_schema.table_privileges
WHERE grantee LIKE 'ecommerce_%'
ORDER BY grantee, table_name, privilege_type;

-- Información de uso
COMMENT ON ROLE ecommerce_admin IS 'Usuario: admin@ecommerce.com | Password: admin_secure_2024';
COMMENT ON ROLE ecommerce_manager IS 'Usuario: manager@ecommerce.com | Password: manager_secure_2024';
COMMENT ON ROLE ecommerce_employee IS 'Usuario: employee@ecommerce.com | Password: employee_secure_2024';
COMMENT ON ROLE ecommerce_readonly IS 'Usuario: reports@ecommerce.com | Password: readonly_secure_2024';

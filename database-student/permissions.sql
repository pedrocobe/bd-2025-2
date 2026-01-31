-- =====================================================
-- PERMISOS Y ROLES - E-COMMERCE EXAM
-- =====================================================

-- PASO 1: Eliminar roles si existen
DROP ROLE IF EXISTS db_admin;
DROP ROLE IF EXISTS db_manager;
DROP ROLE IF EXISTS db_employee;
DROP ROLE IF EXISTS db_readonly;

-- PASO 2: Crear los 4 roles

-- ROL 1: db_admin - Administrador con acceso total
CREATE ROLE db_admin WITH LOGIN PASSWORD 'admin123';

-- ROL 2: db_manager - Gerente con acceso de lectura/escritura
CREATE ROLE db_manager WITH LOGIN PASSWORD 'manager123';

-- ROL 3: db_employee - Empleado con acceso limitado
CREATE ROLE db_employee WITH LOGIN PASSWORD 'employee123';

-- ROL 4: db_readonly - Usuario de solo lectura
CREATE ROLE db_readonly WITH LOGIN PASSWORD 'readonly123';

-- =====================================================
-- PASO 3: ASIGNAR PERMISOS
-- =====================================================

-- PERMISOS PARA db_admin (ACCESO TOTAL)
GRANT ALL PRIVILEGES ON DATABASE ecommerce_exam TO db_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO db_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO db_admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO db_admin;

-- PERMISOS PARA db_manager (LECTURA/ESCRITURA COMPLETA)
GRANT CONNECT ON DATABASE ecommerce_exam TO db_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO db_manager;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO db_manager;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO db_manager;

-- PERMISOS PARA db_employee (ACCESO LIMITADO)
GRANT CONNECT ON DATABASE ecommerce_exam TO db_employee;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO db_employee;
GRANT INSERT, UPDATE ON products, customers, orders, order_items TO db_employee;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO db_employee;

-- PERMISOS PARA db_readonly (SOLO LECTURA)
GRANT CONNECT ON DATABASE ecommerce_exam TO db_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO db_readonly;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO db_readonly;

-- =====================================================
-- PASO 4: REVOCAR PERMISOS (seguridad adicional)
-- =====================================================

-- REVOCACIONES PARA db_employee
REVOKE DELETE ON ALL TABLES IN SCHEMA public FROM db_employee;

-- REVOCACIONES PARA db_readonly
REVOKE INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public FROM db_readonly;

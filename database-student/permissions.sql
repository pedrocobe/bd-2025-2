-- =====================================================
-- PERMISOS Y ROLES - E-COMMERCE EXAM
-- =====================================================
-- INSTRUCCIONES:
-- 1. Crea 4 roles de base de datos con diferentes niveles de acceso
-- 2. Asigna permisos apropiados a cada rol usando GRANT
-- 3. Revoca permisos innecesarios usando REVOKE
-- 4. Demuestra conocimiento de control de acceso en PostgreSQL
-- 
-- IMPORTANTE:
-- - El backend se conecta con el usuario 'postgres' (superusuario)
-- - Estos roles son para DEMOSTRAR tu conocimiento de seguridad en BD
-- - NO afectan la conexión del sistema
-- =====================================================

-- =====================================================
-- PASO 1: Eliminar roles si existen
-- =====================================================
DROP ROLE IF EXISTS db_readonly;
DROP ROLE IF EXISTS db_employee;
DROP ROLE IF EXISTS db_manager;
DROP ROLE IF EXISTS db_admin;

-- =====================================================
-- PASO 2: Crear los 4 roles
-- =====================================================

-- ROL 1: db_admin - Administrador con acceso total
CREATE ROLE db_admin WITH LOGIN PASSWORD 'admin123';

-- ROL 2: db_manager - Gerente con acceso de lectura/escritura
CREATE ROLE db_manager WITH LOGIN PASSWORD 'manager123';

-- ROL 3: db_employee - Empleado con acceso limitado
CREATE ROLE db_employee WITH LOGIN PASSWORD 'employee123';

-- ROL 4: db_readonly - Usuario de solo lectura para reportes
CREATE ROLE db_readonly WITH LOGIN PASSWORD 'readonly123';

-- =====================================================
-- PASO 3: ASIGNAR PERMISOS
-- =====================================================

-- =====================================================
-- PERMISOS PARA db_admin (ACCESO TOTAL)
-- =====================================================
GRANT ALL PRIVILEGES ON DATABASE ecommerce_exam TO db_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO db_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO db_admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO db_admin;

-- =====================================================
-- PERMISOS PARA db_manager (LECTURA/ESCRITURA COMPLETA)
-- =====================================================
GRANT CONNECT ON DATABASE ecommerce_exam TO db_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO db_manager;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO db_manager;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO db_manager;

-- =====================================================
-- PERMISOS PARA db_employee (ACCESO LIMITADO)
-- =====================================================
GRANT CONNECT ON DATABASE ecommerce_exam TO db_employee;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO db_employee;
GRANT INSERT, UPDATE ON products, customers, orders, order_items TO db_employee;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO db_employee;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO db_employee;

-- =====================================================
-- PERMISOS PARA db_readonly (SOLO LECTURA)
-- =====================================================
GRANT CONNECT ON DATABASE ecommerce_exam TO db_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO db_readonly;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO db_readonly;

-- =====================================================
-- PASO 4: REVOCAR PERMISOS (seguridad adicional)
-- =====================================================

-- Revocar DELETE para db_employee (solo puede leer/crear/editar, no eliminar)
REVOKE DELETE ON ALL TABLES IN SCHEMA public FROM db_employee;

-- Revocar INSERT, UPDATE, DELETE para db_readonly (solo lectura)
REVOKE INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public FROM db_readonly;

-- =====================================================
-- VERIFICACIÓN (opcional)
-- =====================================================
-- Para verificar que los roles fueron creados correctamente:
-- SELECT rolname FROM pg_roles WHERE rolname LIKE 'db_%';
--
-- Para ver permisos de un rol específico:
-- SELECT grantee, privilege_type, table_name 
-- FROM information_schema.table_privileges 
-- WHERE grantee = 'db_admin';

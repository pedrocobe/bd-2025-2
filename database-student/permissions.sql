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


-- PASO 1: ELIMINAR ROLES SI EXISTEN
DROP ROLE IF EXISTS db_admin;
DROP ROLE IF EXISTS db_manager;
DROP ROLE IF EXISTS db_employee;
DROP ROLE IF EXISTS db_readonly;

-- PASO 2: CREAR ROLES
-- Rol administrador: acceso total (db_admin)
CREATE ROLE db_admin
WITH LOGIN PASSWORD 'admin123';
-- Rol gerente: lectura y escritura (db_manager)
CREATE ROLE db_manager
WITH LOGIN PASSWORD 'manager123';
-- Rol empleado: acceso limitado (db_employee)
CREATE ROLE db_employee
WITH LOGIN PASSWORD 'employee123';
-- Rol solo lectura: reportes (db_readonly)
CREATE ROLE db_readonly
WITH LOGIN PASSWORD 'readonly123';


-- PASO 3: ASIGNACIÓN DE PERMISOS
-- PERMISOS db_admin (Avveso total)
GRANT ALL PRIVILEGES ON DATABASE ecommerce_exam TO db_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO db_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO db_admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO db_admin;

-- PERMISOS db_manager (Lectura/Escritura completa)
GRANT CONNECT ON DATABASE ecommerce_exam TO db_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO db_manager;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO db_manager;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO db_manager;

-- PERMISOS db_employee (Acceso limitado)
-- Puede conectarse
GRANT CONNECT ON DATABASE ecommerce_exam TO db_employee;
-- Puede leer todas las tablas
GRANT SELECT ON ALL TABLES IN SCHEMA public TO db_employee;
-- Puede insertar y actualizar solo ciertas tablas
GRANT INSERT, UPDATE ON products, customers, orders, order_items TO db_employee;
-- Puede usar secuencias para inserts
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO db_employee;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO db_employee;


-- PERMISOS db_readonly (Solo lectura)
GRANT CONNECT ON DATABASE ecommerce_exam TO db_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO db_readonly;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO db_readonly;

-- PASO 4: REVOCAR PERMISOS (Seguridad)
-- El empleado no puede eliminar datos(Puede leer/crear/editar, no eliminar)
REVOKE DELETE ON ALL TABLES IN SCHEMA public FROM db_employee;

-- El usuario readonly no puede modificar datos(Solo lectura)
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
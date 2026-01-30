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

-- PASO 1: Eliminar roles si existen (para evitar errores al ejecutar múltiples veces)
-- TODO: DROP ROLE IF EXISTS para cada uno de los 4 roles

DROP ROLE IF EXISTS db_readonly;
DROP ROLE IF EXISTS db_employee;
DROP ROLE IF EXISTS db_manager;
DROP ROLE IF EXISTS db_admin;



-- PASO 2: Crear los 4 roles
--
-- ROL 1: db_admin
-- Descripción: Administrador con acceso total
-- Debe poder: LOGIN con password 'admin123'
--
-- TODO: CREATE ROLE db_admin WITH LOGIN PASSWORD 'admin123';

CREATE ROLE db_admin WITH LOGIN PASSWORD 'admin123';



-- ROL 2: db_manager  
-- Descripción: Gerente con acceso de lectura/escritura
-- Debe poder: LOGIN con password 'manager123'
--
-- TODO: CREATE ROLE db_manager WITH LOGIN PASSWORD 'manager123';

CREATE ROLE db_manager WITH LOGIN PASSWORD 'manager123';



-- ROL 3: db_employee
-- Descripción: Empleado con acceso limitado
-- Debe poder: LOGIN con password 'employee123'
--
-- TODO: CREATE ROLE db_employee WITH LOGIN PASSWORD 'employee123';

CREATE ROLE db_employee WITH LOGIN PASSWORD 'employee123';



-- ROL 4: db_readonly
-- Descripción: Usuario de solo lectura (para reportes)
-- Debe poder: LOGIN con password 'readonly123'
--
-- TODO: CREATE ROLE db_readonly WITH LOGIN PASSWORD 'readonly123';

CREATE ROLE db_readonly WITH LOGIN PASSWORD 'readonly123';



-- =====================================================
-- PASO 3: ASIGNAR PERMISOS
-- =====================================================

-- PERMISOS PARA db_admin (ACCESO TOTAL)
-- Debe tener:
-- - ALL PRIVILEGES en la base de datos ecommerce_exam
-- - ALL PRIVILEGES en todas las tablas del schema public
-- - ALL PRIVILEGES en todas las secuencias (sequences)
-- - ALL PRIVILEGES en todas las funciones
--
-- Comandos necesarios:
-- GRANT ALL PRIVILEGES ON DATABASE ecommerce_exam TO db_admin;
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO db_admin;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO db_admin;
-- GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO db_admin;
--
-- TODO: Escribe los GRANT para db_admin

GRANT ALL PRIVILEGES ON DATABASE ecommerce_exam TO db_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO db_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO db_admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO db_admin;



-- PERMISOS PARA db_manager (LECTURA/ESCRITURA COMPLETA)
-- Debe tener:
-- - CONNECT a la base de datos
-- - SELECT, INSERT, UPDATE, DELETE en todas las tablas
-- - USAGE y SELECT en todas las sequences (para usar serial)
-- - EXECUTE en todas las funciones
--
-- Comandos necesarios:
-- GRANT CONNECT ON DATABASE ecommerce_exam TO db_manager;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO db_manager;
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO db_manager;
-- GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO db_manager;
--
-- TODO: Escribe los GRANT para db_manager

GRANT CONNECT ON DATABASE ecommerce_exam TO db_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO db_manager;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO db_manager;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO db_manager;



-- PERMISOS PARA db_employee (ACCESO LIMITADO)
-- Debe tener:
-- - CONNECT a la base de datos
-- - SELECT en todas las tablas (puede leer todo)
-- - INSERT, UPDATE solo en: products, customers, orders, order_items
-- - NO puede DELETE de ninguna tabla
-- - USAGE, SELECT en sequences (para inserts)
--
-- Comandos necesarios:
-- GRANT CONNECT ON DATABASE ecommerce_exam TO db_employee;
-- GRANT SELECT ON ALL TABLES IN SCHEMA public TO db_employee;
-- GRANT INSERT, UPDATE ON products, customers, orders, order_items TO db_employee;
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO db_employee;
--
-- TODO: Escribe los GRANT para db_employee

GRANT CONNECT ON DATABASE ecommerce_exam TO db_employee;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO db_employee;
GRANT INSERT, UPDATE ON products, customers, orders, order_items TO db_employee;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO db_employee;



-- PERMISOS PARA db_readonly (SOLO LECTURA)
-- Debe tener:
-- - CONNECT a la base de datos
-- - SELECT en todas las tablas (solo lectura)
-- - EXECUTE en funciones (para ejecutar reportes)
-- - NO puede INSERT, UPDATE, DELETE en ninguna tabla
--
-- Comandos necesarios:
-- GRANT CONNECT ON DATABASE ecommerce_exam TO db_readonly;
-- GRANT SELECT ON ALL TABLES IN SCHEMA public TO db_readonly;
-- GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO db_readonly;
--
-- TODO: Escribe los GRANT para db_readonly

GRANT CONNECT ON DATABASE ecommerce_exam TO db_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO db_readonly;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO db_readonly;



-- =====================================================
-- PASO 4: REVOCAR PERMISOS (seguridad adicional)
-- =====================================================

-- REVOCACIONES PARA db_employee
-- Asegurarse explícitamente que NO pueda:
-- - DELETE de ninguna tabla
--
-- REVOKE DELETE ON ALL TABLES IN SCHEMA public FROM db_employee;
--
-- TODO: Escribe el REVOKE para db_employee

REVOKE DELETE ON ALL TABLES IN SCHEMA public FROM db_employee;



-- REVOCACIONES PARA db_readonly
-- Asegurarse explícitamente que NO pueda:
-- - INSERT, UPDATE, DELETE de ninguna tabla
--
-- REVOKE INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public FROM db_readonly;
--
-- TODO: Escribe el REVOKE para db_readonly

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

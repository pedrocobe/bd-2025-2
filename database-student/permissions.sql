-- PERMISOS Y ROLES - E-COMMERCE EXAM

-- PASO 1: Eliminar roles si existen
DROP ROLE IF EXISTS db_admin;
DROP ROLE IF EXISTS db_manager;
DROP ROLE IF EXISTS db_employee;
DROP ROLE IF EXISTS db_readonly;

-- PASO 2: Crear los roles

-- ROL 1: Administrador
CREATE ROLE db_admin
WITH LOGIN PASSWORD 'admin123';

-- ROL 2: Gerente
CREATE ROLE db_manager
WITH LOGIN PASSWORD 'manager123';

-- ROL 3: Empleado
CREATE ROLE db_employee
WITH LOGIN PASSWORD 'employee123';

-- ROL 4: Solo lectura
CREATE ROLE db_readonly
WITH LOGIN PASSWORD 'readonly123';

-- PASO 3: Asignar permisos

-- db_admin: ACCESO TOTAL
GRANT ALL PRIVILEGES ON DATABASE ecommerce_exam TO db_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO db_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO db_admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO db_admin;

-- db_manager: LECTURA / ESCRITURA
GRANT CONNECT ON DATABASE ecommerce_exam TO db_manager;
GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA public TO db_manager;
GRANT USAGE, SELECT
ON ALL SEQUENCES IN SCHEMA public TO db_manager;
GRANT EXECUTE
ON ALL FUNCTIONS IN SCHEMA public TO db_manager;

-- db_employee: ACCESO LIMITADO
GRANT CONNECT ON DATABASE ecommerce_exam TO db_employee;
GRANT SELECT
ON ALL TABLES IN SCHEMA public TO db_employee;

GRANT INSERT, UPDATE
ON products, customers, orders, order_items
TO db_employee;

GRANT USAGE, SELECT
ON ALL SEQUENCES IN SCHEMA public TO db_employee;

-- db_readonly: SOLO LECTURA
GRANT CONNECT ON DATABASE ecommerce_exam TO db_readonly;
GRANT SELECT
ON ALL TABLES IN SCHEMA public TO db_readonly;
GRANT EXECUTE
ON ALL FUNCTIONS IN SCHEMA public TO db_readonly;

-- PASO 4: Revocar permisos (seguridad adicional)

-- db_employee NO puede borrar
REVOKE DELETE
ON ALL TABLES IN SCHEMA public
FROM db_employee;

-- db_readonly NO puede modificar nada
REVOKE INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA public
FROM db_readonly;

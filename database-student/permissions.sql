-- ROLES
DROP ROLE IF EXISTS db_admin;
DROP ROLE IF EXISTS db_manager;
DROP ROLE IF EXISTS db_employee;
DROP ROLE IF EXISTS db_readonly;

CREATE ROLE db_admin LOGIN PASSWORD 'admin123';
CREATE ROLE db_manager LOGIN PASSWORD 'manager123';
CREATE ROLE db_employee LOGIN PASSWORD 'employee123';
CREATE ROLE db_readonly LOGIN PASSWORD 'readonly123';

-- ACCESO A BASE DE DATOS
GRANT CONNECT ON DATABASE ecommerce_exam TO db_admin;
GRANT CONNECT ON DATABASE ecommerce_exam TO db_manager;
GRANT CONNECT ON DATABASE ecommerce_exam TO db_employee;
GRANT CONNECT ON DATABASE ecommerce_exam TO db_readonly;

-- PERMISOS EN ESQUEMA
GRANT USAGE ON SCHEMA public TO db_admin, db_manager, db_employee, db_readonly;

-- db_admin → TODO
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO db_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO db_admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO db_admin;

-- db_manager → CRUD COMPLETO
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO db_manager;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO db_manager;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO db_manager;

-- db_employee → OPERATIVO

-- Lectura general
GRANT SELECT ON ALL TABLES IN SCHEMA public TO db_employee;

-- Escritura limitada
GRANT INSERT, UPDATE ON
    products,
    customers,
    orders,
    order_items
TO db_employee;

-- Necesario para SERIAL
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO db_employee;

-- Seguridad
REVOKE DELETE ON ALL TABLES IN SCHEMA public FROM db_employee;

-- db_readonly → SOLO LECTURA
GRANT SELECT ON ALL TABLES IN SCHEMA public TO db_readonly;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO db_readonly;

REVOKE INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public FROM db_readonly;

-- DEFAULT PRIVILEGES
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO db_manager;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO db_employee, db_readonly;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT USAGE, SELECT ON SEQUENCES TO db_manager, db_employee;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT EXECUTE ON FUNCTIONS TO db_manager, db_readonly;
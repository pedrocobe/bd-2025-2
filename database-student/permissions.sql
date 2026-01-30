-- =====================================================
-- PERMISOS Y ROLES - E-COMMERCE EXAM
-- =====================================================

-- PASO 1: Eliminar roles si existen
DROP ROLE IF EXISTS db_admin;
DROP ROLE IF EXISTS db_manager;
DROP ROLE IF EXISTS db_employee;
DROP ROLE IF EXISTS db_readonly;

-- PASO 2: Crear los 4 roles
-- ROL 1: db_admin (Admin total)
CREATE ROLE db_admin WITH LOGIN PASSWORD 'admin123';

-- ROL 2: db_manager (Gerente)
CREATE ROLE db_manager WITH LOGIN PASSWORD 'manager123';

-- ROL 3: db_employee (Empleado)
CREATE ROLE db_employee WITH LOGIN PASSWORD 'employee123';

-- ROL 4: db_readonly (Reportes)
CREATE ROLE db_readonly WITH LOGIN PASSWORD 'readonly123';


-- =====================================================
-- PASO 3: ASIGNAR PERMISOS
-- =====================================================

-- -----------------------------------------------------
-- PERMISOS PARA db_admin (ACCESO TOTAL)
-- -----------------------------------------------------
GRANT CONNECT ON DATABASE ecommerce_exam TO db_admin;
GRANT USAGE ON SCHEMA public TO db_admin;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO db_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO db_admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO db_admin;


-- -----------------------------------------------------
-- PERMISOS PARA db_manager (LECTURA/ESCRITURA COMPLETA)
-- -----------------------------------------------------
GRANT CONNECT ON DATABASE ecommerce_exam TO db_manager;
GRANT USAGE ON SCHEMA public TO db_manager;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO db_manager;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO db_manager;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO db_manager;


-- -----------------------------------------------------
-- PERMISOS PARA db_employee (ACCESO LIMITADO)
-- -----------------------------------------------------
GRANT CONNECT ON DATABASE ecommerce_exam TO db_employee;
GRANT USAGE ON SCHEMA public TO db_employee;

-- Puede leer todo
GRANT SELECT ON ALL TABLES IN SCHEMA public TO db_employee;

-- Solo puede modificar tablas operativas
GRANT INSERT, UPDATE ON products, customers, orders, order_items TO db_employee;

-- Necesario para poder hacer INSERTs (usar los IDs autoincrementales)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO db_employee;


-- -----------------------------------------------------
-- PERMISOS PARA db_readonly (SOLO LECTURA)
-- -----------------------------------------------------
GRANT CONNECT ON DATABASE ecommerce_exam TO db_readonly;
GRANT USAGE ON SCHEMA public TO db_readonly;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO db_readonly;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO db_readonly;


-- =====================================================
-- PASO 4: REVOCAR PERMISOS (Cierre de seguridad)
-- =====================================================

-- REVOCACIONES PARA db_employee
-- Nos aseguramos que NUNCA pueda borrar nada
REVOKE DELETE ON ALL TABLES IN SCHEMA public FROM db_employee;

-- REVOCACIONES PARA db_readonly
-- Nos aseguramos que sea puramente lectura
REVOKE INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public FROM db_readonly;
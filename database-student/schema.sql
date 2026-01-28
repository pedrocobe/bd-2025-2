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


-- PASO 3: Crea índices para optimizar búsquedas
-- Identifica columnas que se usarán frecuentemente en WHERE, JOIN u ORDER BY
-- Usa CREATE INDEX idx_nombre ON tabla(columna)


-- PASO 4: Agrega comentarios descriptivos
-- Usa COMMENT ON TABLE nombre_tabla IS 'Descripción'
-- Esto ayuda a documentar tu base de datos

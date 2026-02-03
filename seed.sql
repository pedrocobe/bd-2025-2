-- =====================================================
-- DATOS DE PRUEBA - E-COMMERCE EXAM
-- =====================================================
-- INSTRUCCIONES:
-- 1. Inserta datos de prueba para validar tu sistema
-- 2. Asegúrate de seguir el orden correcto (respetando FKs)
-- 3. Los datos deben ser realistas y variados
-- =====================================================

-- ORDEN SUGERIDO (importante para respetar foreign keys):
-- 1. Users (no dependen de nadie)
-- 2. Categories (las principales primero, luego las subcategorías)
-- 3. Products (dependen de categories y users)
-- 4. Customers (no dependen de nadie)
-- 5. Orders (dependen de customers y users)
-- 6. Order_items (dependen de orders y products)

-- TODO: Inserta datos suficientes para probar:
-- - 4 usuarios mínimo (diferentes roles: admin, manager, employee)
INSERT INTO users (username, email, full_name, role, is_active) VALUES
('juan_admin', 'juan@ecommerce.com', 'Juan Pérez', 'admin', true),
('maria_manager', 'maria@ecommerce.com', 'María García', 'manager', true),
('carlos_emp', 'carlos@ecommerce.com', 'Carlos López', 'employee', true),
('ana_emp', 'ana@ecommerce.com', 'Ana Martínez', 'employee', true);
-- - 10-15 categorías (algunas con jerarquía padre-hijo)
INSERT INTO categories (name, description, parent_id) VALUES
('Tecnología', 'Dispositivos electrónicos y gadgets', NULL), -- ID 1
('Hogar', 'Artículos para casa y cocina', NULL),            -- ID 2
('Moda', 'Ropa y accesorios', NULL),                        -- ID 3
('Computación', 'Laptops y periféricos', 1),                -- ID 4
('Telefonía', 'Smartphones y accesorios', 1),               -- ID 5
('Muebles', 'Sofás y mesas', 2),                           -- ID 6
('Electrodomésticos', 'Línea blanca y pequeños aparatos', 2),-- ID 7
('Casual', 'Ropa de diario', 3),                           -- ID 8
('Deporte', 'Ropa para ejercicio', 3),                      -- ID 9
('Audio', 'Audífonos y parlantes', 1);                      -- ID 10
-- - 20-30 productos variados en diferentes categorías
INSERT INTO products (sku, name, description, category_id, price, cost, stock_quantity, is_active, min_stock_level, created_by) VALUES
('TECH-001', 'MacBook Air M2','Producto recomendado', 4, 1200.00, 1200.00, 15, true, 2, 1),
('TECH-002', 'iPhone 15 Pro','Producto recomendado', 5, 999.00, 999.00, 20, true, 2, 1),
('TECH-003', 'Teclado Mecánico RGB','Producto recomendado', 4, 85.00, 85.00, 50, true, 2, 1),
('TECH-004', 'Mouse Inalámbrico','Producto recomendado', 4, 45.00, 45.00, 100, true, 2, 1),
('TECH-005', 'Audífonos Sony WH-1000XM5','Producto recomendado', 10, 350.00, 350.00, 12, true, 2, 1),
('HOME-001', 'Cafetera Espresso', 'Producto recomendado',7, 180.00, 180.00, 8, true, 2, 1),
('HOME-002', 'Licuadora Ninja','Producto recomendado', 7, 120.00, 120.00, 25, true, 2, 1),
('HOME-003', 'Silla Ergonómica','Producto recomendado', 6, 250.00, 250.00, 10, true, 2, 1),
('FASH-001', 'Camiseta Algodón Black','Producto recomendado', 6, 25.00, 25.00, 200, true, 2, 1),
('FASH-002', 'Jeans Slim Fit','Producto recomendado', 8, 55.00, 55.00, 15, true, 2, 1),
('FASH-003', 'Zapatillas Running','Producto recomendado', 9, 95.00, 95.00, 40, true, 2, 1),
('TECH-006', 'Monitor 4K 27','Producto recomendado', 4, 400.00, 400.00, 15, true, 2, 1),
('HOME-004', 'Set de Cuchillos Pro','Producto recomendado', 7, 90.00, 90.00, 30, true, 2, 1),
('TECH-007', 'iPad Pro 11"','Producto recomendado', 5, 850.00, 850.00, 18, true, 2, 1),
('FASH-004', 'Sudadera con Capucha','Producto recomendado', 8, 40.00, 40.00, 80, true, 2, 1),
('TECH-008', 'Cargador USB-C 65W','Producto recomendado', 5, 35.00, 35.00, 500, true, 2, 1),
('HOME-005', 'Lámpara de Escritorio','Producto recomendado', 6, 30.00, 30.00, 60, true, 2, 1),
('FASH-005', 'Gorra Deportiva','Producto recomendado', 9, 20.00, 20.00, 100, true, 2, 1),
('TECH-009', 'SSD Externo 1TB','Producto recomendado', 4, 110.00, 110.00, 45, true, 2, 1),
('HOME-006', 'Mesa de Centro Madera','Producto recomendado', 6, 150.00, 150.00, 5, true, 2, 1);
-- - 10 clientes con información completa
INSERT INTO customers (first_name, last_name, email, city) VALUES
('Roberto', 'Gómez', 'roberto@gmail.com', 'Quito'),
('Lucía', 'Fernández', 'lucia@yahoo.com', 'Guayaquil'),
('Andrés', 'Castro', 'andres@outlook.com', 'Manta'),
('Isabel', 'Ruiz', 'isabel@gmail.com', 'Cuenca'),
('Marcos', 'Peña', 'marcos@empresa.com', 'Ambato'),
('Elena', 'Sanz', 'elena@gmail.com', 'Loja'),
('Ricardo', 'Díaz', 'ricardo@gmail.com', 'Manta'),
('Carmen', 'Vega', 'carmen@live.com', 'Quito'),
('Hugo', 'Torres', 'hugo@gmail.com', 'Esmeraldas'),
('Patricia', 'Luna', 'patricia@gmail.com', 'Ibarra');
-- - 8 pedidos en diferentes estados
INSERT INTO orders (customer_id, status, total) VALUES
(1, 'delivered', 0), (2, 'paid', 0), (3, 'pending', 0), (4, 'shipped', 0),
(5, 'delivered', 0), (1, 'cancelled', 0), (7, 'paid', 0), (8, 'pending', 0);
-- - Múltiples items por cada pedido
-- Pedido 1 (Roberto)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(1, 1, 1, 1200.00, 1200.00),
(1, 4, 2, 45.00, 90.00);

-- Pedido 2 (Lucía)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(2, 2, 1, 999.00, 999.00),
(2, 16, 1, 35.00, 35.00);

-- Pedido 3 (Andrés)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(3, 10, 2, 55.00, 110.00);

-- Pedido 4 (Isabel)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(4, 5, 1, 350.00, 350.00),
(4, 19, 1, 110.00, 110.00);

-- Pedido 5 (Marcos)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(5, 6, 1, 180.00, 180.00);

-- Pedido 7 (Ricardo)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(7, 11, 2, 95.00, 190.00),
(7, 18, 1, 20.00, 20.00);

-- IMPORTANTE: Para las contraseñas, usa el hash bcrypt de "password123":
-- $2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ

-- Recuerda:
-- - Usar comillas simples para strings
-- - Separar valores con comas
-- - Terminar statements con punto y coma
-- - Puedes insertar múltiples registros en un solo INSERT

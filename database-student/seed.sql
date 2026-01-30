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
-- - 10-15 categorías (algunas con jerarquía padre-hijo)
-- - 20-30 productos variados en diferentes categorías
-- - 10 clientes con información completa
-- - 8 pedidos en diferentes estados
-- - Múltiples items por cada pedido

-- IMPORTANTE: Para las contraseñas, usa el hash bcrypt de "password123":
-- $2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ

-- Recuerda:
-- - Usar comillas simples para strings
-- - Separar valores con comas
-- - Terminar statements con punto y coma
-- - Puedes insertar múltiples registros en un solo INSERT


-- =====================================================
-- 1) USERS
-- =====================================================
INSERT INTO users (id, username, email, password_hash, full_name, role, is_active, created_at, last_login)
VALUES
	(1, 'admin', 'admin@ecommerce.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Administrador del Sistema', 'admin', TRUE, CURRENT_TIMESTAMP - INTERVAL '20 days', CURRENT_TIMESTAMP - INTERVAL '1 day'),
	(2, 'manager', 'manager@ecommerce.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'María García Gerente', 'manager', TRUE, CURRENT_TIMESTAMP - INTERVAL '18 days', CURRENT_TIMESTAMP - INTERVAL '2 days'),
	(3, 'employee1', 'employee1@ecommerce.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Juan Pérez Empleado', 'employee', TRUE, CURRENT_TIMESTAMP - INTERVAL '16 days', CURRENT_TIMESTAMP - INTERVAL '3 days'),
	(4, 'employee2', 'employee2@ecommerce.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Ana López Empleada', 'employee', TRUE, CURRENT_TIMESTAMP - INTERVAL '14 days', CURRENT_TIMESTAMP - INTERVAL '4 days');


-- =====================================================
-- 2) CATEGORIES (con jerarquía)
-- =====================================================
INSERT INTO categories (id, name, description, parent_id, is_active)
VALUES
	(1,  'Electrónica', 'Dispositivos electrónicos', NULL, TRUE),
	(2,  'Ropa', 'Ropa y accesorios', NULL, TRUE),
	(3,  'Hogar', 'Artículos para el hogar', NULL, TRUE),
	(4,  'Deportes', 'Artículos deportivos', NULL, TRUE),
	(5,  'Libros', 'Libros y publicaciones', NULL, TRUE),
	(6,  'Computadoras', 'Laptops y PCs', 1, TRUE),
	(7,  'Celulares', 'Smartphones y tablets', 1, TRUE),
	(8,  'Audio', 'Audífonos y bocinas', 1, TRUE),
	(9,  'Accesorios', 'Accesorios de moda', 2, TRUE),
	(10, 'Cocina', 'Artículos de cocina', 3, TRUE),
	(11, 'Fitness', 'Equipamiento fitness', 4, TRUE),
	(12, 'Ficción', 'Novelas y ficción', 5, TRUE);


-- =====================================================
-- 3) PRODUCTS
-- =====================================================
INSERT INTO products (id, name, description, sku, category_id, price, cost, stock_quantity, min_stock_level, is_active, created_by, created_at)
VALUES
	(1,  'Laptop Dell XPS 13', 'Laptop ultradelgada con procesador Intel i7', 'DELL-XPS13-001', 6, 1299.99, 900.00, 50, 5, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '10 days'),
	(2,  'MacBook Pro 14"', 'MacBook Pro con chip M3', 'APPLE-MBP14-001', 6, 1999.99, 1400.00, 2, 3, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '10 days'),
	(3,  'iPhone 15 Pro', 'iPhone con cámara profesional', 'APPLE-IP15P-001', 7, 1199.99, 850.00, 60, 5, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '9 days'),
	(4,  'Samsung Galaxy S24', 'Smartphone Android premium', 'SAMS-S24-001', 7, 999.99, 700.00, 75, 8, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '9 days'),
	(5,  'AirPods Pro', 'Audífonos inalámbricos con cancelación de ruido', 'APPLE-APP-001', 8, 249.99, 150.00, 120, 10, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '8 days'),
	(6,  'Bocina JBL Flip 6', 'Bocina portátil resistente al agua', 'JBL-FLIP6-001', 8, 129.99, 80.00, 90, 10, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '8 days'),
	(7,  'Teclado Mecánico', 'Teclado mecánico RGB', 'KB-MECH-001', 6, 89.99, 45.00, 70, 10, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '7 days'),
	(8,  'Mouse Inalámbrico', 'Mouse inalámbrico ergonómico', 'MOUSE-WL-001', 6, 39.99, 18.00, 150, 20, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '7 days'),
	(9,  'Monitor 27" 2K', 'Monitor 27 pulgadas resolución 2K', 'MON-27-2K-001', 6, 259.99, 180.00, 3, 5, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '7 days'),
	(10, 'Cargador USB-C 65W', 'Cargador rápido USB-C', 'CHG-USBC-65W-001', 7, 29.99, 12.00, 200, 30, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '6 days'),
	(11, 'Funda iPhone 15', 'Funda protectora para iPhone 15', 'CASE-IP15-001', 7, 19.99, 6.00, 250, 40, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '6 days'),
	(12, 'Audífonos Sony WH-1000XM5', 'Audífonos con cancelación de ruido', 'SONY-WHXM5-001', 8, 349.99, 240.00, 35, 5, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '6 days'),
	(13, 'Camiseta Deportiva', 'Camiseta transpirable', 'TEE-SPORT-001', 2, 24.99, 9.00, 120, 20, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '6 days'),
	(14, 'Pantalón Jeans', 'Jeans clásico', 'JEANS-001', 2, 49.99, 22.00, 80, 15, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '6 days'),
	(15, 'Gorra', 'Gorra ajustable', 'CAP-001', 9, 14.99, 5.00, 100, 20, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '5 days'),
	(16, 'Zapatillas Running', 'Zapatillas para correr', 'RUN-SHOES-001', 4, 79.99, 42.00, 60, 10, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '5 days'),
	(17, 'Mancuernas 10kg', 'Par de mancuernas 10kg', 'DUMB-10KG-001', 11, 59.99, 32.00, 45, 8, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '5 days'),
	(18, 'Mat de Yoga', 'Mat antideslizante', 'YOGA-MAT-001', 11, 21.99, 8.00, 110, 20, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '5 days'),
	(19, 'Sartén Antiadherente', 'Sartén 28cm antiadherente', 'PAN-28-001', 10, 34.99, 16.00, 75, 10, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '4 days'),
	(20, 'Juego de Cuchillos', 'Set de cuchillos de cocina', 'KNIFE-SET-001', 10, 44.99, 20.00, 50, 8, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '4 days'),
	(21, 'Cafetera', 'Cafetera automática', 'COFFEE-001', 10, 99.99, 62.00, 25, 5, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '4 days'),
	(22, 'Libro: SQL para Todos', 'Guía práctica de SQL', 'BOOK-SQL-001', 5, 18.99, 6.50, 140, 20, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '4 days'),
	(23, 'Libro: El Principito', 'Clásico de la literatura', 'BOOK-FIC-001', 12, 9.99, 2.50, 180, 30, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '3 days'),
	(24, 'Libro: Clean Code', 'Buenas prácticas de programación', 'BOOK-CC-001', 5, 29.99, 12.00, 65, 10, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '3 days'),
	(25, 'Smartwatch', 'Reloj inteligente', 'WATCH-001', 7, 199.99, 120.00, 55, 8, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '3 days');


-- =====================================================
-- 4) CUSTOMERS
-- =====================================================
INSERT INTO customers (id, first_name, last_name, email, phone, address, city, country, postal_code, is_active, created_at)
VALUES
	(1, 'Carlos', 'Rodríguez', 'carlos.rodriguez@email.com', '+52-555-1234', 'Av. Reforma 123', 'Ciudad de México', 'México', '01000', TRUE, CURRENT_TIMESTAMP - INTERVAL '25 days'),
	(2, 'Laura', 'Martínez', 'laura.martinez@email.com', '+52-555-5678', 'Calle Juárez 456', 'Guadalajara', 'México', '44100', TRUE, CURRENT_TIMESTAMP - INTERVAL '24 days'),
	(3, 'Pedro', 'Sánchez', 'pedro.sanchez@email.com', '+52-555-9012', 'Blvd. Díaz Ordaz 789', 'Monterrey', 'México', '64000', TRUE, CURRENT_TIMESTAMP - INTERVAL '23 days'),
	(4, 'Sofía', 'Herrera', 'sofia.herrera@email.com', '+52-555-1111', 'Av. Universidad 100', 'Quito', 'Ecuador', '170102', TRUE, CURRENT_TIMESTAMP - INTERVAL '22 days'),
	(5, 'Diego', 'Vega', 'diego.vega@email.com', '+52-555-2222', 'Calle 9 de Octubre 200', 'Guayaquil', 'Ecuador', '090150', TRUE, CURRENT_TIMESTAMP - INTERVAL '21 days'),
	(6, 'Valentina', 'Castro', 'valentina.castro@email.com', '+52-555-3333', 'Av. Los Shyris 321', 'Quito', 'Ecuador', '170135', TRUE, CURRENT_TIMESTAMP - INTERVAL '20 days'),
	(7, 'Andrés', 'Mendoza', 'andres.mendoza@email.com', '+52-555-4444', 'Calle Larga 55', 'Cuenca', 'Ecuador', '010101', TRUE, CURRENT_TIMESTAMP - INTERVAL '19 days'),
	(8, 'Mariana', 'Paredes', 'mariana.paredes@email.com', '+52-555-5555', 'Av. Amazonas 987', 'Quito', 'Ecuador', '170143', TRUE, CURRENT_TIMESTAMP - INTERVAL '18 days'),
	(9, 'Luis', 'Gómez', 'luis.gomez@email.com', '+52-555-6666', 'Av. Principal 12', 'Manta', 'Ecuador', '130802', TRUE, CURRENT_TIMESTAMP - INTERVAL '17 days'),
	(10, 'Camila', 'Reyes', 'camila.reyes@email.com', '+52-555-7777', 'Calle Central 77', 'Portoviejo', 'Ecuador', '130101', TRUE, CURRENT_TIMESTAMP - INTERVAL '16 days');

-- Estadísticas iniciales (se recalculan por función más adelante cuando USE_MOCKS=false)
UPDATE customers SET total_spent = 3527.72, order_count = 2 WHERE id = 1;
UPDATE customers SET total_spent = 1236.37, order_count = 1 WHERE id = 2;
UPDATE customers SET total_spent = 2805.98, order_count = 1 WHERE id = 3;
UPDATE customers SET total_spent = 183.81,  order_count = 1 WHERE id = 4;
UPDATE customers SET total_spent = 0,       order_count = 0 WHERE id = 5;
UPDATE customers SET total_spent = 203.61,  order_count = 1 WHERE id = 6;
UPDATE customers SET total_spent = 398.77,  order_count = 1 WHERE id = 7;


-- =====================================================
-- 5) ORDERS
-- =====================================================
-- Nota: order_number se genera con trigger si es NULL.
-- En seed.sql aún no existen triggers, por eso se insertan order_number y totales manualmente.
INSERT INTO orders (id, customer_id, order_number, status, subtotal, tax, shipping_cost, total, shipping_address, shipping_city, shipping_country, created_by, shipped_at, delivered_at, created_at)
VALUES
	(1, 1, 'ORD-2026-0001', 'delivered', 1609.96, 257.59, 50.00, 1917.55, 'Av. Reforma 123', 'Ciudad de México', 'México', 3, CURRENT_TIMESTAMP - INTERVAL '9 days', CURRENT_TIMESTAMP - INTERVAL '7 days', CURRENT_TIMESTAMP - INTERVAL '10 days'),
	(2, 2, 'ORD-2026-0002', 'delivered', 1039.97, 166.40, 30.00, 1236.37, 'Calle Juárez 456', 'Guadalajara', 'México', 3, CURRENT_TIMESTAMP - INTERVAL '8 days', CURRENT_TIMESTAMP - INTERVAL '6 days', CURRENT_TIMESTAMP - INTERVAL '9 days'),
	(3, 3, 'ORD-2026-0003', 'shipped', 2349.98, 376.00, 80.00, 2805.98, 'Blvd. Díaz Ordaz 789', 'Monterrey', 'México', 4, CURRENT_TIMESTAMP - INTERVAL '4 days', NULL, CURRENT_TIMESTAMP - INTERVAL '6 days'),
	(4, 1, 'ORD-2026-0004', 'processing', 1344.97, 215.20, 50.00, 1610.17, 'Av. Reforma 123', 'Ciudad de México', 'México', 4, NULL, NULL, CURRENT_TIMESTAMP - INTERVAL '4 days'),
	(5, 4, 'ORD-2026-0005', 'pending', 123.97, 19.84, 40.00, 183.81, 'Av. Universidad 100', 'Quito', 'Ecuador', 3, NULL, NULL, CURRENT_TIMESTAMP - INTERVAL '3 days'),
	(6, 5, 'ORD-2026-0006', 'cancelled', 99.97, 16.00, 20.00, 135.97, 'Calle 9 de Octubre 200', 'Guayaquil', 'Ecuador', 3, NULL, NULL, CURRENT_TIMESTAMP - INTERVAL '2 days'),
	(7, 6, 'ORD-2026-0007', 'delivered', 153.97, 24.64, 25.00, 203.61, 'Av. Los Shyris 321', 'Quito', 'Ecuador', 4, CURRENT_TIMESTAMP - INTERVAL '6 days', CURRENT_TIMESTAMP - INTERVAL '5 days', CURRENT_TIMESTAMP - INTERVAL '7 days'),
	(8, 7, 'ORD-2026-0008', 'processing', 304.97, 48.80, 45.00, 398.77, 'Calle Larga 55', 'Cuenca', 'Ecuador', 4, NULL, NULL, CURRENT_TIMESTAMP - INTERVAL '1 day');


-- =====================================================
-- 6) ORDER_ITEMS
-- =====================================================
-- unit_price se registra al momento de la compra.
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal)
VALUES
	-- Order 1
	(1, 1, 1, 1299.99, 1299.99),
	(1, 5, 1, 249.99, 249.99),
	(1, 10, 2, 29.99, 59.98),

	-- Order 2
	(2, 4, 1, 999.99, 999.99),
	(2, 11, 2, 19.99, 39.98),

	-- Order 3
	(3, 2, 1, 1999.99, 1999.99),
	(3, 12, 1, 349.99, 349.99),

	-- Order 4
	(4, 3, 1, 1199.99, 1199.99),
	(4, 6, 1, 129.99, 129.99),
	(4, 15, 1, 14.99, 14.99),

	-- Order 5
	(5, 16, 1, 79.99, 79.99),
	(5, 18, 2, 21.99, 43.98),

	-- Order 6 (cancelled)
	(6, 13, 2, 24.99, 49.98),
	(6, 14, 1, 49.99, 49.99),

	-- Order 7
	(7, 21, 1, 99.99, 99.99),
	(7, 22, 1, 18.99, 18.99),
	(7, 19, 1, 34.99, 34.99),

	-- Order 8
	(8, 25, 1, 199.99, 199.99),
	(8, 17, 1, 59.99, 59.99),
	(8, 20, 1, 44.99, 44.99);



-- =====================================================
-- ACTUALIZAR SECUENCIAS (importante para tests)
-- =====================================================
SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));
SELECT setval('categories_id_seq', (SELECT MAX(id) FROM categories));
SELECT setval('products_id_seq', (SELECT MAX(id) FROM products));
SELECT setval('customers_id_seq', (SELECT MAX(id) FROM customers));
SELECT setval('orders_id_seq', (SELECT MAX(id) FROM orders));
SELECT setval('order_items_id_seq', (SELECT MAX(id) FROM order_items));


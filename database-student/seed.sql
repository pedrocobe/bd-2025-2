

-- 1) USERS
INSERT INTO users (id, username, email, password_hash, full_name, role, is_active, created_at, last_login)
VALUES
  (1, 'admin', 'admin@ecommerce.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Admin BD7', 'admin', TRUE, CURRENT_TIMESTAMP - INTERVAL '30 days', CURRENT_TIMESTAMP - INTERVAL '2 days'),
  (2, 'manager', 'manager@ecommerce.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Manager BD7', 'manager', TRUE, CURRENT_TIMESTAMP - INTERVAL '28 days', CURRENT_TIMESTAMP - INTERVAL '3 days'),
  (3, 'employee1', 'employee1@ecommerce.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Empleado BD7 1', 'employee', TRUE, CURRENT_TIMESTAMP - INTERVAL '26 days', CURRENT_TIMESTAMP - INTERVAL '4 days'),
  (4, 'employee2', 'employee2@ecommerce.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Empleado BD7 2', 'employee', TRUE, CURRENT_TIMESTAMP - INTERVAL '24 days', CURRENT_TIMESTAMP - INTERVAL '5 days');

-- 2) CATEGORIES
INSERT INTO categories (id, name, description, parent_id, is_active)
VALUES
  (1, 'Brasil Tech', 'Electrónica y gadgets BD7', NULL, TRUE),
  (2, 'Moda BR', 'Ropa y accesorios BD7', NULL, TRUE),
  (3, 'Casa BR', 'Hogar y cocina BD7', NULL, TRUE),
  (4, 'Aventura BR', 'Deportes y exterior BD7', NULL, TRUE),
  (5, 'Livros BR', 'Libros y lectura BD7', NULL, TRUE),
  (6, 'Notebooks BR', 'Portátiles BD7', 1, TRUE),
  (7, 'Celulares BR', 'Smartphones BD7', 1, TRUE),
  (8, 'Audio BR', 'Audio BD7', 1, TRUE),
  (9, 'Accesorios Moda BR', 'Complementos', 2, TRUE),
  (10,'Cocina BR', 'Utensilios de cocina', 3, TRUE),
  (11,'Fitness BR', 'Deporte y fitness', 4, TRUE),
  (12,'Ficción BR', 'Novelas', 5, TRUE);

-- 3) PRODUCTS
INSERT INTO products (id, name, description, sku, category_id, price, cost, stock_quantity, min_stock_level, is_active, created_by, created_at)
VALUES
  (1, 'Amazônia Laptop', 'Laptop ligera BD7', 'BD7-NB-001', 6, 1399.00, 850.00, 25, 4, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '20 days'),
  (2, 'Ipanema Pro', 'Laptop potente BD7', 'BD7-LTP-002', 6, 1899.00, 1250.00, 5, 3, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '18 days'),
  (3, 'RioPhone X', 'Smartphone BD7', 'BD7-PH-003', 7, 899.00, 580.00, 70, 6, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '17 days'),
  (4, 'Samba S', 'Smartphone resistente BD7', 'BD7-PH-004', 7, 649.00, 440.00, 60, 7, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '16 days'),
  (5, 'Bossa Ear', 'Audífonos BD7', 'BD7-AUD-005', 8, 199.00, 120.00, 55, 9, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '15 days'),
  (6, 'Tropical Speaker', 'Bocina BD7', 'BD7-SPK-006', 8, 139.00, 80.00, 40, 8, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '14 days'),
  (7, 'Carioca KB', 'Teclado compacto', 'BD7-KB-007', 6, 79.00, 40.00, 80, 10, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '13 days'),
  (8, 'Maré Mouse', 'Mouse ergonómico', 'BD7-MSE-008', 6, 34.00, 16.00, 150, 20, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '12 days'),
  (9, 'Vista QHD', 'Monitor 27" QHD', 'BD7-MON-009', 6, 279.00, 185.00, 6, 5, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '11 days'),
  (10, 'Turbo Charge', 'Cargador 65W', 'BD7-CHG-010', 7, 34.00, 13.00, 160, 30, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '10 days'),
  (11, 'Protec Case', 'Funda resistente', 'BD7-CASE-011', 7, 21.00, 7.50, 200, 40, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '9 days'),
  (12, 'Silence Pro', 'Auriculares ANC', 'BD7-PRO-012', 8, 329.00, 220.00, 28, 6, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '8 days'),
  (13, 'Camisa Praia', 'Camiseta veraniega', 'BD7-TEE-013', 2, 22.00, 8.00, 130, 20, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '8 days'),
  (14, 'Jeans Forte', 'Jeans durable', 'BD7-JEANS-014', 2, 54.00, 24.00, 65, 15, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '7 days'),
  (15, 'Boné Mar', 'Gorra ventilada', 'BD7-CAP-015', 9, 13.50, 5.50, 120, 20, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '6 days'),
  (16, 'Trail BD7', 'Zapatillas montaña', 'BD7-RUN-016', 4, 109.00, 55.00, 48, 10, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '6 days'),
  (17, 'Mancuernas BR', 'Set 10kg', 'BD7-DUMB-017', 11, 69.00, 36.00, 28, 8, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '5 days'),
  (18, 'Yoga BR', 'Esterilla premium', 'BD7-YOGA-018', 11, 29.00, 11.00, 90, 20, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '5 days'),
  (19, 'Frigideira Pro', 'Sartén 28cm', 'BD7-PAN-019', 10, 54.00, 22.00, 46, 10, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '4 days'),
  (20, 'Cutlery Set', 'Juego de cuchillos', 'BD7-KNIFE-020', 10, 64.00, 28.00, 30, 8, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '4 days'),
  (21, 'Coffee BD7', 'Cafetera automática', 'BD7-COF-021', 10, 129.00, 75.00, 12, 5, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '3 days'),
  (22, 'SQL Pocket BR', 'Guía práctica SQL', 'BD7-BOOK-022', 5, 17.99, 6.50, 120, 20, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '3 days'),
  (23, 'Principe BR', 'Edición BR', 'BD7-BOOK-023', 12, 10.50, 3.50, 145, 30, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '2 days'),
  (24, 'Clean Code BR', 'Buenas prácticas adaptadas', 'BD7-BOOK-024', 5, 31.00, 12.50, 52, 10, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '2 days'),
  (25, 'Relógio BD7', 'Smartwatch BR', 'BD7-WATCH-025', 7, 189.00, 115.00, 40, 8, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '2 days');

-- 4) CUSTOMERS
INSERT INTO customers (id, first_name, last_name, email, phone, address, city, country, postal_code, is_active, created_at)
VALUES
  (1, 'Lucas', 'Silva', 'lucas.silva@bd7.example', '+55-11-90000-0001', 'Rua das Flores 10', 'São Paulo', 'Brasil', '01000-000', TRUE, CURRENT_TIMESTAMP - INTERVAL '30 days'),
  (2, 'Mariana', 'Souza', 'mariana.souza@bd7.example', '+55-11-90000-0002', 'Av. Paulista 100', 'São Paulo', 'Brasil', '01310-100', TRUE, CURRENT_TIMESTAMP - INTERVAL '28 days'),
  (3, 'Gabriel', 'Oliveira', 'gabriel.oliveira@bd7.example', '+55-11-90000-0003', 'Rua Augusta 200', 'São Paulo', 'Brasil', '01305-000', TRUE, CURRENT_TIMESTAMP - INTERVAL '26 days'),
  (4, 'Julia', 'Pereira', 'julia.pereira@bd7.example', '+55-11-90000-0004', 'Rua José 33', 'São Paulo', 'Brasil', '01401-000', TRUE, CURRENT_TIMESTAMP - INTERVAL '24 days'),
  (5, 'Mateus', 'Gomes', 'mateus.gomes@bd7.example', '+55-11-90000-0005', 'Av. Brasil 45', 'Rio de Janeiro', 'Brasil', '20000-000', TRUE, CURRENT_TIMESTAMP - INTERVAL '22 days'),
  (6, 'Ana', 'Costa', 'ana.costa@bd7.example', '+55-11-90000-0006', 'Rua das Palmeiras 7', 'Rio de Janeiro', 'Brasil', '20010-010', TRUE, CURRENT_TIMESTAMP - INTERVAL '20 days'),
  (7, 'Rafael', 'Almeida', 'rafael.almeida@bd7.example', '+55-11-90000-0007', 'Rua Mar 9', 'Salvador', 'Brasil', '40000-000', TRUE, CURRENT_TIMESTAMP - INTERVAL '18 days'),
  (8, 'Beatriz', 'Fernandes', 'beatriz.fernandes@bd7.example', '+55-11-90000-0008', 'Rua Larga 15', 'Salvador', 'Brasil', '40010-110', TRUE, CURRENT_TIMESTAMP - INTERVAL '16 days'),
  (9, 'Pedro', 'Ribeiro', 'pedro.ribeiro@bd7.example', '+55-11-90000-0009', 'Praça Central 1', 'Belo Horizonte', 'Brasil', '30000-000', TRUE, CURRENT_TIMESTAMP - INTERVAL '14 days'),
  (10,'Carolina','Medeiros','carolina.medeiros@bd7.example', '+55-11-90000-0010', 'Rua Nova 22', 'Belo Horizonte', 'Brasil', '30100-200', TRUE, CURRENT_TIMESTAMP - INTERVAL '12 days');

-- Estadísticas iniciales
UPDATE customers SET total_spent = 350.00, order_count = 1 WHERE id = 1;
UPDATE customers SET total_spent = 199.00, order_count = 1 WHERE id = 2;
UPDATE customers SET total_spent = 899.00, order_count = 1 WHERE id = 3;
UPDATE customers SET total_spent = 0.00, order_count = 0 WHERE id = 4;
UPDATE customers SET total_spent = 129.00, order_count = 1 WHERE id = 5;
UPDATE customers SET total_spent = 49.00, order_count = 1 WHERE id = 6;
UPDATE customers SET total_spent = 64.00, order_count = 1 WHERE id = 7;
UPDATE customers SET total_spent = 0.00, order_count = 0 WHERE id = 8;
UPDATE customers SET total_spent = 189.00, order_count = 1 WHERE id = 9;
UPDATE customers SET total_spent = 31.50, order_count = 1 WHERE id = 10;

-- 5) ORDERS
INSERT INTO orders (id, customer_id, order_number, status, subtotal, tax, shipping_cost, total, shipping_address, shipping_city, shipping_country, created_by, shipped_at, delivered_at, created_at)
VALUES
  (1, 1, 'BR-ORD-7001', 'delivered', 350.00, 52.50, 10.00, 412.50, 'Rua das Flores 10', 'São Paulo', 'Brasil', 3, CURRENT_TIMESTAMP - INTERVAL '20 days', CURRENT_TIMESTAMP - INTERVAL '18 days', CURRENT_TIMESTAMP - INTERVAL '21 days'),
  (2, 2, 'BR-ORD-7002', 'delivered', 199.00, 29.85, 8.00, 236.85, 'Av. Paulista 100', 'São Paulo', 'Brasil', 3, CURRENT_TIMESTAMP - INTERVAL '18 days', CURRENT_TIMESTAMP - INTERVAL '16 days', CURRENT_TIMESTAMP - INTERVAL '19 days'),
  (3, 3, 'BR-ORD-7003', 'shipped', 899.00, 134.85, 15.00, 1048.85, 'Rua Augusta 200', 'São Paulo', 'Brasil', 4, CURRENT_TIMESTAMP - INTERVAL '12 days', NULL, CURRENT_TIMESTAMP - INTERVAL '14 days');

-- 6) ORDER_ITEMS
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal)
VALUES
  (1, 25, 1, 129.00, 129.00),
  (1, 22, 1, 17.99, 17.99),
  (2, 5, 1, 199.00, 199.00),
  (3, 2, 1, 1899.00, 1899.00);

-- ACTUALIZAR SECUENCIAS
SELECT setval('users_id_seq', (SELECT COALESCE(MAX(id),0) FROM users));
SELECT setval('categories_id_seq', (SELECT COALESCE(MAX(id),0) FROM categories));
SELECT setval('products_id_seq', (SELECT COALESCE(MAX(id),0) FROM products));
SELECT setval('customers_id_seq', (SELECT COALESCE(MAX(id),0) FROM customers));
SELECT setval('orders_id_seq', (SELECT COALESCE(MAX(id),0) FROM orders));
SELECT setval('order_items_id_seq', (SELECT COALESCE(MAX(id),0) FROM order_items));
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
-- Variante: insertar categorías usando VALUES como tabla derivada
INSERT INTO categories (id, name, description, parent_id, is_active)
SELECT v.id, v.name, v.description, v.parent_id, v.is_active
FROM (VALUES
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
	(12, 'Ficción', 'Novelas y ficción', 5, TRUE)
) AS v(id, name, description, parent_id, is_active);

DELETE FROM categories WHERE id BETWEEN 1 AND 12;
INSERT INTO categories (id, name, description, parent_id, is_active)
VALUES
    (1, 'Tech Gear BD4', 'Gadgets y periféricos BD4', NULL, TRUE),
    (2, 'Fashion BD4', 'Ropa tendencia BD4', NULL, TRUE),
    (3, 'Home BD4', 'Hogar y lifestyle BD4', NULL, TRUE),
    (4, 'Outdoor BD4', 'Equipo outdoor y camping', NULL, TRUE),
    (5, 'Books BD4', 'Lectura y estudio BD4', NULL, TRUE),
    (6, 'Laptops BD4', 'Portátiles y powerbanks', 1, TRUE),
    (7, 'Mobiles BD4', 'Teléfonos y accesorios', 1, TRUE),
    (8, 'Audio BD4', 'Audio para música y pro', 1, TRUE),
    (9, 'Accs BD4', 'Complementos moda BD4', 2, TRUE),
    (10,'Kitchen BD4', 'Cocina y gadgets culinarios', 3, TRUE),
    (11,'Gym BD4', 'Accesorios para gimnasio', 4, TRUE),
    (12,'Fiction BD4', 'Novelas y cuentos BD4', 5, TRUE);


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

DELETE FROM products WHERE id BETWEEN 1 AND 25;
INSERT INTO products (id, name, description, sku, category_id, price, cost, stock_quantity, min_stock_level, is_active, created_by, created_at)
VALUES
	(1, 'ZenBook BD4', 'Ultrabook Zen BD4', 'BD4-NB-001', 6, 1249.00, 820.00, 28, 5, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '14 days'),
	(2, 'ProBook BD4', 'Laptop profesional BD4', 'BD4-LTP-002', 6, 1799.00, 1250.00, 6, 3, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '13 days'),
	(3, 'Pixel One BD4', 'Smartphone Pixel edición BD4', 'BD4-PH-003', 7, 999.00, 640.00, 48, 5, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '12 days'),
	(4, 'Nova S BD4', 'Android Nova S BD4', 'BD4-PH-004', 7, 729.00, 500.00, 60, 8, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '12 days'),
	(5, 'Studio Buds BD4', 'Earbuds para estudio BD4', 'BD4-AUD-005', 8, 219.00, 130.00, 75, 10, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '11 days'),
	(6, 'WaveSpeaker BD4', 'Bocina portátil Wave BD4', 'BD4-SPK-006', 8, 139.00, 78.00, 70, 10, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '11 days'),
	(7, 'TKL Premium BD4', 'Teclado mecánico premium BD4', 'BD4-KB-007', 6, 109.00, 55.00, 60, 10, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '10 days'),
	(8, 'ErgoGrip BD4', 'Mouse vertical ergonómico BD4', 'BD4-MSE-008', 6, 49.00, 22.00, 110, 20, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '10 days'),
	(9, 'ProView 27 BD4', 'Monitor 27" QHD BD4', 'BD4-MON-009', 6, 279.00, 175.00, 8, 5, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '9 days'),
	(10, 'PowerCharge BD4', 'Cargador 65W BD4', 'BD4-CHG-010', 7, 27.00, 11.00, 160, 30, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '9 days'),
	(11, 'ShellCase BD4', 'Funda protectora Shell BD4', 'BD4-CASE-011', 7, 20.00, 7.50, 220, 40, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '9 days'),
	(12, 'NoisePro BD4', 'Auriculares con noise-cancel BD4', 'BD4-PRO-012', 8, 359.00, 235.00, 28, 5, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '8 days'),
	(13, 'Active Tee BD4', 'Camiseta deportiva BD4', 'BD4-TEE-013', 2, 25.50, 9.50, 100, 20, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '8 days'),
	(14, 'Urban Jean BD4', 'Jeans slim BD4', 'BD4-JEANS-014', 2, 52.00, 23.00, 65, 15, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '8 days'),
	(15, 'Cap Sport BD4', 'Gorra deportiva BD4', 'BD4-CAP-015', 9, 15.00, 5.50, 85, 20, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '7 days'),
	(16, 'RunMax BD4', 'Zapatillas running RunMax', 'BD4-RUN-016', 4, 109.00, 55.00, 45, 10, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '7 days'),
	(17, 'Dumbbells BD4', 'Mancuernas set BD4', 'BD4-DUMB-017', 11, 69.00, 36.00, 32, 8, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '7 days'),
	(18, 'YogaMat Pro BD4', 'Esterilla pro BD4', 'BD4-YOGA-018', 11, 24.00, 9.00, 75, 20, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '7 days'),
	(19, 'PanChef BD4', 'Sartén antiadherente BD4', 'BD4-PAN-019', 10, 44.00, 18.50, 55, 10, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '6 days'),
	(20, 'Knives Pro BD4', 'Set cuchillos pro BD4', 'BD4-KNIFE-020', 10, 54.00, 23.00, 30, 8, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '6 days'),
	(21, 'Barista BD4', 'Cafetera express BD4', 'BD4-COF-021', 10, 139.00, 78.00, 12, 5, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '6 days'),
	(22, 'SQL Pocket BD4', 'Guía SQL BD4', 'BD4-BOOK-022', 5, 17.50, 6.00, 110, 20, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '5 days'),
	(23, 'Principe BD4', 'Edición ilustrada BD4', 'BD4-BOOK-023', 12, 10.50, 2.50, 140, 30, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '5 days'),
	(24, 'CodeCraft BD4', 'Clean Code + ejemplos BD4', 'BD4-BOOK-024', 5, 33.00, 14.00, 45, 10, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '5 days'),
	(25, 'Smart Wrist BD4', 'Reloj inteligente avanzado BD4', 'BD4-WATCH-025', 7, 219.00, 130.00, 38, 8, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '5 days');


-- =====================================================
-- 4) CUSTOMERS
-- =====================================================
INSERT INTO customers (id, first_name, last_name, email, phone, address, city, country, postal_code, is_active, created_at)
VALUES
	(1, 'Oliver', 'Reed', 'oliver.reed@bd4.example', '+34-600-100-001', 'Calle Montaña 1', 'Bilbao', 'Spain', '48001', TRUE, CURRENT_TIMESTAMP - INTERVAL '25 days'),
	(2, 'Emma', 'Blake', 'emma.blake@bd4.example', '+34-600-100-002', 'Paseo Marítimo 12', 'Bilbao', 'Spain', '48002', TRUE, CURRENT_TIMESTAMP - INTERVAL '24 days'),
	(3, 'Liam', 'Hart', 'liam.hart@bd4.example', '+34-600-100-003', 'Av. Sendero 45', 'Bilbao', 'Spain', '48003', TRUE, CURRENT_TIMESTAMP - INTERVAL '23 days'),
	(4, 'Ava', 'Cole', 'ava.cole@bd4.example', '+34-600-100-004', 'Plaza del Sol 7', 'Bilbao', 'Spain', '48004', TRUE, CURRENT_TIMESTAMP - INTERVAL '22 days'),
	(5, 'Noah', 'Cruz', 'noah.cruz@bd4.example', '+34-600-100-005', 'Camino Alto 9', 'Bilbao', 'Spain', '48005', TRUE, CURRENT_TIMESTAMP - INTERVAL '21 days'),
	(6, 'Mia', 'Stone', 'mia.stone@bd4.example', '+34-600-100-006', 'Barrio Verde 3', 'Bilbao', 'Spain', '48006', TRUE, CURRENT_TIMESTAMP - INTERVAL '20 days'),
	(7, 'Ethan', 'Ford', 'ethan.ford@bd4.example', '+34-600-100-007', 'Rincón del Viento 20', 'Bilbao', 'Spain', '48007', TRUE, CURRENT_TIMESTAMP - INTERVAL '19 days'),
	(8, 'Zoe', 'Parker', 'zoe.parker@bd4.example', '+34-600-100-008', 'Calle Roble 14', 'Bilbao', 'Spain', '48008', TRUE, CURRENT_TIMESTAMP - INTERVAL '18 days'),
	(9, 'Lucas', 'Reyes', 'lucas.reyes@bd4.example', '+34-600-100-009', 'Camino de la Ría 6', 'Bilbao', 'Spain', '48009', TRUE, CURRENT_TIMESTAMP - INTERVAL '17 days'),
	(10, 'Chloe', 'Wood', 'chloe.wood@bd4.example', '+34-600-100-010', 'Puente Nuevo 2', 'Bilbao', 'Spain', '48010', TRUE, CURRENT_TIMESTAMP - INTERVAL '16 days');

-- Estadísticas iniciales (se recalculan por función más adelante cuando USE_MOCKS=false)
UPDATE customers SET total_spent = 340.00, order_count = 2 WHERE id = 1;
UPDATE customers SET total_spent = 120.50, order_count = 1 WHERE id = 2;
UPDATE customers SET total_spent = 210.00, order_count = 1 WHERE id = 3;
UPDATE customers SET total_spent = 75.75,  order_count = 1 WHERE id = 4;
UPDATE customers SET total_spent = 5.00,   order_count = 0 WHERE id = 5;
UPDATE customers SET total_spent = 400.10, order_count = 1 WHERE id = 6;
UPDATE customers SET total_spent = 60.60,  order_count = 1 WHERE id = 7;


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


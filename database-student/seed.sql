-- =====================================================
-- DATOS DE PRUEBA - E-COMMERCE EXAM
-- =====================================================
-- Datos realistas para probar el sistema completo
-- =====================================================

-- =====================================================
-- 1. INSERTAR USUARIOS
-- =====================================================
-- Password para todos: "password123"
-- Hash bcrypt: $2b$10$YourHashedPasswordHere (en produccion usar hash real)
SET client_encoding = 'UTF8';

INSERT INTO users (username, email, password_hash, full_name, role, is_active) VALUES
('admin', 'admin@ecommerce.com', '$2b$10$K7L/gHFEZfZ0/sCHJ.yGAOxbQmz2.wlR5TJJq5Z7B3iGKJ5sJZK7S', 'Carlos Administrador', 'admin', true),
('manager1', 'maria.manager@ecommerce.com', '$2b$10$K7L/gHFEZfZ0/sCHJ.yGAOxbQmz2.wlR5TJJq5Z7B3iGKJ5sJZK7S', 'Maria Garcia', 'manager', true),
('employee1', 'juan.ventas@ecommerce.com', '$2b$10$K7L/gHFEZfZ0/sCHJ.yGAOxbQmz2.wlR5TJJq5Z7B3iGKJ5sJZK7S', 'Juan Perez', 'employee', true),
('employee2', 'ana.soporte@ecommerce.com', '$2b$10$K7L/gHFEZfZ0/sCHJ.yGAOxbQmz2.wlR5TJJq5Z7B3iGKJ5sJZK7S', 'Ana Lopez', 'employee', true),
('manager2', 'pedro.supervisor@ecommerce.com', '$2b$10$K7L/gHFEZfZ0/sCHJ.yGAOxbQmz2.wlR5TJJq5Z7B3iGKJ5sJZK7S', 'Pedro Ramirez', 'manager', true),
('employee3', 'lucia.bodega@ecommerce.com', '$2b$10$K7L/gHFEZfZ0/sCHJ.yGAOxbQmz2.wlR5TJJq5Z7B3iGKJ5sJZK7S', 'Lucia Morales', 'employee', false);

-- =====================================================
-- 2. INSERTAR CATEGORIAS (CON JERARQUIA)
-- =====================================================

-- Categorias principales (sin parent_id)
INSERT INTO categories (name, description, parent_id, is_active) VALUES
('Electronica', 'Productos electronicos y tecnologia', NULL, true),
('Hogar y Cocina', 'Articulos para el hogar', NULL, true),
('Deportes', 'Articulos deportivos y fitness', NULL, true),
('Libros', 'Libros y material de lectura', NULL, true),
('Ropa', 'Ropa y accesorios', NULL, true);

-- Subcategorias de Electronica (parent_id = 1)
INSERT INTO categories (name, description, parent_id, is_active) VALUES
('Computadoras', 'Laptops y PCs de escritorio', 1, true),
('Smartphones', 'Telefonos moviles y accesorios', 1, true),
('Audio', 'Audifonos, bocinas y equipos de audio', 1, true),
('Camaras', 'Camaras fotograficas y videocamaras', 1, true);

-- Subcategorias de Hogar y Cocina (parent_id = 2)
INSERT INTO categories (name, description, parent_id, is_active) VALUES
('Electrodomesticos', 'Refrigeradores, lavadoras, etc', 2, true),
('Muebles', 'Muebles para el hogar', 2, true),
('Decoracion', 'Articulos decorativos', 2, true);

-- Subcategorias de Deportes (parent_id = 3)
INSERT INTO categories (name, description, parent_id, is_active) VALUES
('Fitness', 'Equipos de gimnasio y ejercicio', 3, true),
('Deportes al aire libre', 'Camping, escalada, ciclismo', 3, true);

-- Subcategorias de Ropa (parent_id = 5)
INSERT INTO categories (name, description, parent_id, is_active) VALUES
('Ropa de Hombre', 'Ropa y accesorios para hombre', 5, true),
('Ropa de Mujer', 'Ropa y accesorios para mujer', 5, true);

-- =====================================================
-- 3. INSERTAR PRODUCTOS
-- =====================================================

-- Productos de Computadoras (category_id = 6)
INSERT INTO products (name, description, sku, category_id, price, cost, stock_quantity, min_stock_level, is_active, created_by) VALUES
('Laptop Dell XPS 13', 'Laptop ultraligera con procesador Intel i7', 'DELL-XPS13-001', 6, 1299.99, 950.00, 15, 5, true, 1),
('MacBook Pro 14"', 'MacBook Pro con chip M3', 'APPLE-MBP14-001', 6, 1999.99, 1500.00, 8, 3, true, 1),
('PC Gamer RGB', 'Computadora de escritorio para gaming', 'PC-GAMER-001', 6, 1499.99, 1100.00, 12, 5, true, 1),
('Laptop HP Pavilion', 'Laptop para uso general', 'HP-PAV15-001', 6, 699.99, 500.00, 25, 10, true, 1);

-- Productos de Smartphones (category_id = 7)
INSERT INTO products (name, description, sku, category_id, price, cost, stock_quantity, min_stock_level, is_active, created_by) VALUES
('iPhone 15 Pro', 'iPhone 15 Pro 256GB', 'IPHONE-15PRO-256', 7, 1099.99, 850.00, 20, 8, true, 1),
('Samsung Galaxy S24', 'Samsung Galaxy S24 128GB', 'SAMSUNG-S24-128', 7, 899.99, 650.00, 30, 10, true, 1),
('Google Pixel 8', 'Google Pixel 8 256GB', 'GOOGLE-PIX8-256', 7, 699.99, 500.00, 18, 8, true, 1),
('Xiaomi Redmi Note 13', 'Smartphone economico', 'XIAOMI-RN13-128', 7, 299.99, 200.00, 45, 15, true, 1);

-- Productos de Audio (category_id = 8)
INSERT INTO products (name, description, sku, category_id, price, cost, stock_quantity, min_stock_level, is_active, created_by) VALUES
('AirPods Pro 2', 'Audifonos inalambricos con cancelacion de ruido', 'APPLE-APP2-001', 8, 249.99, 180.00, 35, 12, true, 1),
('Sony WH-1000XM5', 'Audifonos over-ear premium', 'SONY-WH1000XM5', 8, 399.99, 280.00, 22, 8, true, 1),
('JBL Flip 6', 'Bocina Bluetooth portatil', 'JBL-FLIP6-001', 8, 129.99, 85.00, 40, 15, true, 1),
('Bose QuietComfort', 'Audifonos con cancelacion de ruido', 'BOSE-QC45-001', 8, 329.99, 230.00, 18, 8, true, 1);

-- Productos de Electrodomesticos (category_id = 10)
INSERT INTO products (name, description, sku, category_id, price, cost, stock_quantity, min_stock_level, is_active, created_by) VALUES
('Refrigerador Samsung', 'Refrigerador de 2 puertas 500L', 'SAMSUNG-REF500', 10, 899.99, 650.00, 8, 3, true, 1),
('Lavadora LG 15kg', 'Lavadora automatica carga frontal', 'LG-LAV15KG-001', 10, 649.99, 450.00, 10, 4, true, 1),
('Microondas Panasonic', 'Microondas 1.2 cu ft', 'PANA-MICRO12', 10, 149.99, 95.00, 25, 10, true, 1);

-- Productos de Fitness (category_id = 13)
INSERT INTO products (name, description, sku, category_id, price, cost, stock_quantity, min_stock_level, is_active, created_by) VALUES
('Mancuernas Ajustables', 'Set de mancuernas 5-25kg', 'FIT-MANC-SET', 13, 199.99, 130.00, 15, 5, true, 1),
('Caminadora Electrica', 'Caminadora plegable con pantalla LCD', 'FIT-CAM-LCD', 13, 599.99, 400.00, 6, 2, true, 1),
('Tapete de Yoga', 'Tapete antideslizante 6mm', 'FIT-YOGA-MAT', 13, 29.99, 15.00, 50, 20, true, 1),
('Bicicleta Estatica', 'Bicicleta de spinning profesional', 'FIT-BICI-SPIN', 13, 449.99, 300.00, 8, 3, true, 1);

-- Productos de Libros (category_id = 4)
INSERT INTO products (name, description, sku, category_id, price, cost, stock_quantity, min_stock_level, is_active, created_by) VALUES
('Cien Anos de Soledad', 'Gabriel Garcia Marquez - Novela', 'LIBRO-100ANOS', 4, 24.99, 12.00, 100, 30, true, 1),
('El Principito', 'Antoine de Saint-Exupery', 'LIBRO-PRINCIP', 4, 18.99, 9.00, 120, 40, true, 1),
('1984', 'George Orwell - Distopia', 'LIBRO-1984', 4, 22.99, 11.00, 80, 25, true, 1);

-- Productos de Ropa de Hombre (category_id = 15)
INSERT INTO products (name, description, sku, category_id, price, cost, stock_quantity, min_stock_level, is_active, created_by) VALUES
('Camisa Formal Blanca', 'Camisa de vestir manga larga', 'ROPA-CAM-BL-M', 15, 39.99, 20.00, 60, 20, true, 1),
('Jeans Levi''s 501', 'Jeans clasicos corte recto', 'ROPA-JEANS-501', 15, 79.99, 45.00, 45, 15, true, 1),
('Chaqueta de Cuero', 'Chaqueta de cuero genuino', 'ROPA-CHAQ-CUERO', 15, 199.99, 120.00, 12, 5, true, 1);

-- Productos de Ropa de Mujer (category_id = 16)
INSERT INTO products (name, description, sku, category_id, price, cost, stock_quantity, min_stock_level, is_active, created_by) VALUES
('Vestido Elegante Negro', 'Vestido de noche talla unica', 'ROPA-VEST-NEG-F', 16, 89.99, 50.00, 25, 10, true, 1),
('Blusa de Seda', 'Blusa manga corta varios colores', 'ROPA-BLUS-SEDA', 16, 49.99, 28.00, 40, 15, true, 1),
('Pantalon Yoga', 'Pantalon deportivo elastico', 'ROPA-PANT-YOGA', 16, 34.99, 18.00, 55, 20, true, 1);

-- Productos con stock bajo (para probar alertas)
INSERT INTO products (name, description, sku, category_id, price, cost, stock_quantity, min_stock_level, is_active, created_by) VALUES
('Teclado Mecanico RGB', 'Teclado gaming switches azules', 'TECH-KEYB-RGB', 6, 129.99, 80.00, 3, 10, true, 1),
('Mouse Inalambrico', 'Mouse ergonomico recargable', 'TECH-MOUSE-WIFI', 6, 49.99, 28.00, 4, 15, true, 1);

-- =====================================================
-- 4. INSERTAR CLIENTES
-- =====================================================

INSERT INTO customers (first_name, last_name, email, phone, address, city, country, postal_code, is_active) VALUES
('Roberto', 'Gonzalez', 'roberto.gonzalez@email.com', '+593-99-123-4567', 'Av. 10 de Agosto N35-17', 'Quito', 'Ecuador', '170501', true),
('Laura', 'Martinez', 'laura.martinez@email.com', '+593-98-234-5678', 'Calle Olmedo 234', 'Guayaquil', 'Ecuador', '090313', true),
('Diego', 'Fernandez', 'diego.fernandez@email.com', '+593-97-345-6789', 'Av. Solano 567', 'Cuenca', 'Ecuador', '010150', true),
('Carmen', 'Rodriguez', 'carmen.rodriguez@email.com', '+593-96-456-7890', 'Calle Bolivar 890', 'Quito', 'Ecuador', '170502', true),
('Fernando', 'Sanchez', 'fernando.sanchez@email.com', '+593-95-567-8901', 'Av. 9 de Octubre 123', 'Guayaquil', 'Ecuador', '090314', true),
('Patricia', 'Ramirez', 'patricia.ramirez@email.com', '+593-94-678-9012', 'Calle Larga 456', 'Cuenca', 'Ecuador', '010151', true),
('Miguel', 'Torres', 'miguel.torres@email.com', '+593-93-789-0123', 'Av. Amazonas N24-156', 'Quito', 'Ecuador', '170143', true),
('Isabel', 'Flores', 'isabel.flores@email.com', '+593-92-890-1234', 'Calle Escobedo 789', 'Guayaquil', 'Ecuador', '090315', true),
('Ricardo', 'Vargas', 'ricardo.vargas@email.com', '+593-91-901-2345', 'Av. Espana 321', 'Cuenca', 'Ecuador', '010152', true),
('Sandra', 'Morales', 'sandra.morales@email.com', '+593-90-012-3456', 'Calle Garcia Moreno 654', 'Quito', 'Ecuador', '170144', true),
('Luis', 'Castro', 'luis.castro@email.com', '+593-89-123-4567', 'Av. Malecon 987', 'Guayaquil', 'Ecuador', '090316', true),
('Elena', 'Ruiz', 'elena.ruiz@email.com', '+593-88-234-5678', 'Calle Benigno Malo 159', 'Cuenca', 'Ecuador', '010153', true);

-- =====================================================
-- 5. INSERTAR PEDIDOS (ORDERS)
-- =====================================================

-- Pedidos completados (delivered)
INSERT INTO orders (order_number, customer_id, status, subtotal, tax, shipping_cost, total, shipping_address, shipping_city, shipping_country, created_by, created_at, delivered_at) VALUES
('ORD-2024-001', 1, 'delivered', 1499.98, 179.99, 15.00, 1694.97, 'Av. 10 de Agosto N35-17', 'Quito', 'Ecuador', 3, '2024-02-01 10:30:00', '2024-02-05 14:20:00'),
('ORD-2024-002', 2, 'delivered', 2399.93, 287.99, 20.00, 2707.97, 'Calle Olmedo 234', 'Guayaquil', 'Ecuador', 3, '2024-02-03 14:15:00', '2024-02-08 16:45:00'),
('ORD-2024-003', 3, 'delivered', 769.98, 92.39, 12.00, 907.96, 'Av. Solano 567', 'Cuenca', 'Ecuador', 3, '2024-02-05 09:45:00', '2024-02-10 11:30:00');

-- Pedidos enviados (shipped)
INSERT INTO orders (order_number, customer_id, status, subtotal, tax, shipping_cost, total, shipping_address, shipping_city, shipping_country, created_by, created_at, shipped_at) VALUES
('ORD-2024-004', 4, 'shipped', 1149.98, 137.99, 15.00, 1302.97, 'Calle Bolivar 890', 'Quito', 'Ecuador', 3, '2024-02-08 11:20:00', '2024-02-10 09:15:00'),
('ORD-2024-005', 5, 'shipped', 529.98, 63.59, 10.00, 603.57, 'Av. 9 de Octubre 123', 'Guayaquil', 'Ecuador', 3, '2024-02-12 16:30:00', '2024-02-13 10:00:00');

-- Pedidos en procesamiento (processing)
INSERT INTO orders (order_number, customer_id, status, subtotal, tax, shipping_cost, total, shipping_address, shipping_city, shipping_country, created_by, created_at) VALUES
('ORD-2024-006', 6, 'processing', 899.98, 107.99, 15.00, 1022.97, 'Calle Larga 456', 'Cuenca', 'Ecuador', 3, '2024-02-14 10:00:00'),
('ORD-2024-007', 7, 'processing', 2699.98, 323.99, 25.00, 3048.97, 'Av. Amazonas N24-156', 'Quito', 'Ecuador', 3, '2024-02-15 13:45:00');

-- Pedidos pendientes (pending)
INSERT INTO orders (order_number, customer_id, status, subtotal, tax, shipping_cost, total, shipping_address, shipping_city, shipping_country, created_by, created_at) VALUES
('ORD-2024-008', 8, 'pending', 379.97, 45.59, 8.00, 433.56, 'Calle Escobedo 789', 'Guayaquil', 'Ecuador', 3, '2024-02-16 09:30:00'),
('ORD-2024-009', 9, 'pending', 1049.98, 125.99, 15.00, 1190.97, 'Av. Espana 321', 'Cuenca', 'Ecuador', 3, '2024-02-17 14:20:00');

-- Pedido cancelado (cancelled)
INSERT INTO orders (order_number, customer_id, status, subtotal, tax, shipping_cost, total, shipping_address, shipping_city, shipping_country, created_by, created_at) VALUES
('ORD-2024-010', 10, 'cancelled', 699.99, 83.99, 12.00, 795.98, 'Calle Garcia Moreno 654', 'Quito', 'Ecuador', 3, '2024-02-18 11:00:00');

-- =====================================================
-- 6. INSERTAR ORDER_ITEMS (Detalles de pedidos)
-- =====================================================

-- Items para ORD-2024-001 (order_id = 1)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(1, 1, 1, 1299.99, 1299.99),  -- Laptop Dell XPS 13
(1, 13, 2, 99.99, 199.99);     -- JBL Flip 6

-- Items para ORD-2024-002 (order_id = 2)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(2, 2, 1, 1999.99, 1999.99),  -- MacBook Pro 14"
(2, 9, 1, 249.99, 249.99),    -- AirPods Pro 2
(2, 29, 5, 29.99, 149.95);    -- Cien Anos de Soledad

-- Items para ORD-2024-003 (order_id = 3)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(3, 6, 1, 899.99, 899.99),    -- Samsung Galaxy S24
(4, 11, 1, 129.99, 129.99);   -- JBL Flip 6

-- Items para ORD-2024-004 (order_id = 4)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(4, 5, 1, 1099.99, 1099.99),  -- iPhone 15 Pro
(4, 19, 1, 49.99, 49.99);     -- Mouse Inalambrico

-- Items para ORD-2024-005 (order_id = 5)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(5, 10, 1, 399.99, 399.99),   -- Sony WH-1000XM5
(5, 21, 1, 129.99, 129.99);   -- Teclado Mecanico RGB

-- Items para ORD-2024-006 (order_id = 6)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(6, 15, 1, 899.99, 899.99);   -- Refrigerador Samsung

-- Items para ORD-2024-007 (order_id = 7)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(7, 3, 1, 1499.99, 1499.99),  -- PC Gamer RGB
(7, 22, 1, 599.99, 599.99),   -- Caminadora Electrica
(7, 24, 1, 599.99, 599.99);   -- Bicicleta Estatica

-- Items para ORD-2024-008 (order_id = 8)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(8, 26, 3, 79.99, 239.97),    -- Jeans Levi's 501
(8, 28, 2, 49.99, 99.98),     -- Blusa de Seda
(8, 23, 1, 29.99, 29.99);     -- Tapete de Yoga

-- Items para ORD-2024-009 (order_id = 9)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(9, 20, 1, 449.99, 449.99),   -- Bicicleta Estatica
(9, 25, 1, 199.99, 199.99),   -- Mancuernas Ajustables
(9, 10, 1, 399.99, 399.99);   -- Sony WH-1000XM5

-- Items para ORD-2024-010 (order_id = 10) - Pedido cancelado
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(10, 4, 1, 699.99, 699.99);   -- Laptop HP Pavilion

-- =====================================================
-- 7. ACTUALIZAR ESTADISTICAS DE CLIENTES
-- =====================================================
-- Nota: Esto normalmente lo harian triggers, pero lo hacemos manualmente para tener datos iniciales

-- Cliente 1 - Roberto Gonzalez (1 pedido entregado)
UPDATE customers SET total_spent = 1694.97, order_count = 1 WHERE id = 1;

-- Cliente 2 - Laura Martinez (1 pedido entregado)
UPDATE customers SET total_spent = 2707.97, order_count = 1 WHERE id = 2;

-- Cliente 3 - Diego Fernandez (1 pedido entregado)
UPDATE customers SET total_spent = 907.96, order_count = 1 WHERE id = 3;

-- Cliente 4 - Carmen Rodriguez (1 pedido enviado)
UPDATE customers SET total_spent = 1302.97, order_count = 1 WHERE id = 4;

-- Cliente 5 - Fernando Sanchez (1 pedido enviado)
UPDATE customers SET total_spent = 603.57, order_count = 1 WHERE id = 5;

-- Cliente 6 - Patricia Ramirez (1 pedido en procesamiento)
UPDATE customers SET total_spent = 1022.97, order_count = 1 WHERE id = 6;

-- Cliente 7 - Miguel Torres (1 pedido en procesamiento)
UPDATE customers SET total_spent = 3048.97, order_count = 1 WHERE id = 7;

-- Cliente 8 - Isabel Flores (1 pedido pendiente)
UPDATE customers SET total_spent = 433.56, order_count = 1 WHERE id = 8;

-- Cliente 9 - Ricardo Vargas (1 pedido pendiente)
UPDATE customers SET total_spent = 1190.97, order_count = 1 WHERE id = 9;

-- Cliente 10 - Sandra Morales (1 pedido cancelado - no cuenta)
UPDATE customers SET total_spent = 0, order_count = 0 WHERE id = 10;

-- Clientes 11 y 12 sin pedidos aun
UPDATE customers SET total_spent = 0, order_count = 0 WHERE id IN (11, 12);

-- =====================================================
-- VERIFICACION DE DATOS INSERTADOS
-- =====================================================

-- Verificar conteos
SELECT 'Users' AS tabla, COUNT(*) AS registros FROM users
UNION ALL
SELECT 'Categories', COUNT(*) FROM categories
UNION ALL
SELECT 'Products', COUNT(*) FROM products
UNION ALL
SELECT 'Customers', COUNT(*) FROM customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders
UNION ALL
SELECT 'Order Items', COUNT(*) FROM order_items;

-- =====================================================
-- FIN DE SEED DATA
-- =====================================================

-- =====================================================
-- DATOS DE PRUEBA - E-COMMERCE EXAM - TECNOLOGÍA ECUADOR
-- =====================================================
-- INSTRUCCIONES:
-- 1. Inserta datos de prueba para validar tu sistema
-- 2. Asegúrate de seguir el orden correcto (respetando FKs)
-- 3. Los datos son de tecnología y ubicaciones de Ecuador
-- =====================================================

-- ORDEN SUGERIDO (importante para respetar foreign keys):
-- 1. Users (no dependen de nadie)
-- 2. Categories (las principales primero, luego las subcategorías)
-- 3. Products (dependen de categories y users)
-- 4. Customers (no dependen de nadie)
-- 5. Orders (dependen de customers y users)
-- 6. Order_items (dependen de orders y products)

-- =====================================================
-- 1. INSERTAR USUARIOS (4 usuarios con diferentes roles)
-- =====================================================
INSERT INTO users (username, email, password_hash, full_name, role, is_active, created_at, last_login) VALUES
('admin', 'admin@techstore-ec.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Administrador TechStore', 'admin', true, '2025-01-01 10:00:00', '2025-01-28 08:30:00'),
('manager1', 'manager@techstore-ec.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Marco Vásquez Manager', 'manager', true, '2025-01-02 10:00:00', '2025-01-27 14:20:00'),
('employee1', 'employee1@techstore-ec.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Juan Moreno Empleado', 'employee', true, '2025-01-03 10:00:00', '2025-01-28 09:00:00'),
('employee2', 'employee2@techstore-ec.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Patricia Sáenz Empleada', 'employee', true, '2025-01-04 10:00:00', '2025-01-26 16:45:00');

-- =====================================================
-- 2. INSERTAR CATEGORÍAS (solo tecnología con jerarquía)
-- =====================================================
-- Categorías principales de tecnología
INSERT INTO categories (name, description, parent_id, is_active, created_at) VALUES
('Tecnología', 'Productos tecnológicos y electrónicos', NULL, true, '2025-01-01 10:00:00'),
('Accesorios Tecnológicos', 'Accesorios diversos para dispositivos', NULL, true, '2025-01-01 10:00:00');

-- Subcategorías de Tecnología (parent_id = 1)
INSERT INTO categories (name, description, parent_id, is_active, created_at) VALUES
('Computadoras', 'Laptops, PCs, Desktops', 1, true, '2025-01-01 10:00:00'),
('Celulares y Tablets', 'Smartphones, tablets y dispositivos móviles', 1, true, '2025-01-01 10:00:00'),
('Audio', 'Audífonos, bocinas, sistemas de audio', 1, true, '2025-01-01 10:00:00'),
('Monitores y Pantallas', 'Monitores LCD, LED, pantallas', 1, true, '2025-01-01 10:00:00'),
('Periféricos', 'Teclados, mouses, webcams, impresoras', 1, true, '2025-01-01 10:00:00');

-- Subcategorías de Accesorios (parent_id = 2)
INSERT INTO categories (name, description, parent_id, is_active, created_at) VALUES
('Cables y Conectores', 'Cables USB, HDMI, cargadores, adaptadores', 2, true, '2025-01-01 10:00:00'),
('Protección', 'Protectores de pantalla, fundas, mochilas', 2, true, '2025-01-01 10:00:00'),
('Memoria y Almacenamiento', 'USB, microSD, SSD, HDD externo', 2, true, '2025-01-01 10:00:00');

-- =====================================================
-- 3. INSERTAR PRODUCTOS (solo tecnología - 25+ productos)
-- =====================================================
INSERT INTO products (name, description, sku, category_id, price, cost, stock_quantity, min_stock_level, is_active, created_by, created_at) VALUES
-- Computadoras (category_id = 3)
('Laptop Dell XPS 15', 'Laptop ultradelgada con procesador Intel i9', 'DELL-XPS15-001', 3, 2299.99, 1600.00, 15, 5, true, 1, '2025-01-10 10:00:00'),
('MacBook Pro 16"', 'MacBook Pro con chip M3 Max 36GB RAM', 'APPLE-MBP16-001', 3, 3499.99, 2400.00, 8, 3, true, 1, '2025-01-10 11:00:00'),
('ASUS VivoBook 16', 'Laptop ASUS procesador Ryzen 7', 'ASUS-VB16-001', 3, 1199.99, 800.00, 20, 5, true, 1, '2025-01-10 12:00:00'),
('Lenovo ThinkPad X1', 'Laptop ejecutiva con procesador Intel i7', 'LENOVO-TP-X1', 3, 1899.99, 1300.00, 12, 4, true, 1, '2025-01-10 13:00:00'),
('HP Pavilion 15', 'Laptop HP con procesador AMD Ryzen 5', 'HP-PAV15-001', 3, 799.99, 550.00, 18, 5, true, 1, '2025-01-10 14:00:00'),

-- Celulares y Tablets (category_id = 4)
('iPhone 15 Pro Max', 'iPhone con cámara profesional 48MP', 'APPLE-IP15PM-001', 4, 1599.99, 1100.00, 25, 5, true, 1, '2025-01-11 10:00:00'),
('Samsung Galaxy S24 Ultra', 'Smartphone Android premium con S Pen', 'SAMS-S24U-001', 4, 1499.99, 1000.00, 30, 8, true, 1, '2025-01-11 11:00:00'),
('Google Pixel 8 Pro', 'Smartphone con IA avanzada y cámara 50MP', 'GOOG-PIX8P-001', 4, 1099.99, 750.00, 20, 5, true, 1, '2025-01-11 12:00:00'),
('OnePlus 12', 'Smartphone rápido con pantalla 120Hz', 'ONEP-12-001', 4, 849.99, 580.00, 22, 5, true, 1, '2025-01-11 13:00:00'),
('iPad Pro 12.9"', 'Tablet Apple con chip M4 y pantalla ProMotion', 'APPLE-IPAD12-001', 4, 1299.99, 900.00, 14, 3, true, 1, '2025-01-11 14:00:00'),
('Samsung Galaxy Tab S9', 'Tablet Samsung con procesador Snapdragon 8', 'SAMS-TABS9-001', 4, 849.99, 600.00, 16, 4, true, 1, '2025-01-11 15:00:00'),

-- Audio (category_id = 5)
('AirPods Pro 2', 'Audífonos inalámbricos con cancelación activa', 'APPLE-APP2-001', 5, 349.99, 220.00, 40, 10, true, 1, '2025-01-12 10:00:00'),
('Sony WH-1000XM5', 'Auriculares premium con cancelación de ruido', 'SONY-WH1000X5', 5, 499.99, 340.00, 15, 5, true, 1, '2025-01-12 11:00:00'),
('JBL Flip 6', 'Bocina portátil Bluetooth resistente agua', 'JBL-FLIP6-001', 5, 199.99, 120.00, 35, 10, true, 1, '2025-01-12 12:00:00'),
('Beats Studio Pro', 'Auriculares profesionales Bluetooth', 'BEATS-SP-001', 5, 599.99, 400.00, 10, 3, true, 1, '2025-01-12 13:00:00'),
('Bose QuietComfort 45', 'Auriculares con excelente cancelación', 'BOSE-QC45-001', 5, 449.99, 300.00, 12, 4, true, 1, '2025-01-12 14:00:00'),

-- Monitores y Pantallas (category_id = 6)
('LG UltraWide 34"', 'Monitor ultrawide 3440x1440 IPS 100Hz', 'LG-UW34-001', 6, 799.99, 550.00, 8, 2, true, 1, '2025-01-13 10:00:00'),
('Dell UltraSharp 27"', 'Monitor profesional 4K IPS', 'DELL-US27-001', 6, 599.99, 400.00, 10, 3, true, 1, '2025-01-13 11:00:00'),
('ASUS ProArt 32"', 'Monitor para creadores 4K Thunderbolt', 'ASUS-PA32-001', 6, 1299.99, 900.00, 6, 2, true, 1, '2025-01-13 12:00:00'),

-- Periféricos (category_id = 7)
('Logitech MX Master 3S', 'Mouse inalámbrico profesional', 'LOGI-MXM3S-001', 7, 99.99, 60.00, 50, 15, true, 1, '2025-01-14 10:00:00'),
('Corsair K95 Platinum', 'Teclado mecánico RGB programable', 'CORS-K95-001', 7, 199.99, 120.00, 25, 5, true, 1, '2025-01-14 11:00:00'),
('Logitech Webcam HD', 'Webcam 1080p con micrófono integrado', 'LOGI-WC-001', 7, 79.99, 45.00, 40, 10, true, 1, '2025-01-14 12:00:00'),
('HP LaserJet Pro M404n', 'Impresora láser monocromática red', 'HP-LJ404-001', 7, 399.99, 250.00, 8, 2, true, 1, '2025-01-14 13:00:00'),

-- Cables y Conectores (category_id = 8)
('Cable USB-C 2m', 'Cable de carga rápida 100W USB-C', 'ACCES-USC-001', 8, 24.99, 10.00, 120, 30, true, 1, '2025-01-15 10:00:00'),
('Cargador rápido 65W GaN', 'Cargador universal compacto 65W', 'ACCES-CHG-001', 8, 59.99, 30.00, 60, 15, true, 1, '2025-01-15 11:00:00'),
('Hub USB-C 7 puertos', 'Hub multifunción con HDMI, USB-A, SD', 'ACCES-HUB-001', 8, 89.99, 50.00, 30, 8, true, 1, '2025-01-15 12:00:00'),
('Cable HDMI 2.1 8K', 'Cable HDMI 2.1 certificado 48Gbps', 'ACCES-HDMI-001', 8, 34.99, 15.00, 80, 20, true, 1, '2025-01-15 13:00:00'),

-- Protección (category_id = 9)
('Funda iPad Pro 12.9"', 'Funda de cuero con soporte inteligente', 'PROT-IPAD-001', 9, 49.99, 25.00, 35, 10, true, 1, '2025-01-16 10:00:00'),
('Protector pantalla vidrio', 'Protector vidrio templado 9H universal', 'PROT-SCR-001', 9, 14.99, 5.00, 150, 50, true, 1, '2025-01-16 11:00:00'),
('Mochila para laptop 17"', 'Mochila impermeable con compartimentos', 'PROT-BAG-001', 9, 79.99, 40.00, 25, 5, true, 1, '2025-01-16 12:00:00'),

-- Memoria y Almacenamiento (category_id = 10)
('SSD Kingston 1TB', 'SSD 1TB NVMe M.2 velocidad 4700MB/s', 'STOR-SSD1TB-001', 10, 89.99, 50.00, 40, 10, true, 1, '2025-01-17 10:00:00'),
('Samsung T7 Shield 2TB', 'SSD externo 2TB resistente golpes', 'STOR-T7SH-001', 10, 249.99, 150.00, 20, 5, true, 1, '2025-01-17 11:00:00'),
('USB Kingston DataTraveler 256GB', 'USB 3.2 Gen1 256GB rápido', 'STOR-USB-001', 10, 34.99, 15.00, 80, 20, true, 1, '2025-01-17 12:00:00'),
('MicroSD SanDisk 512GB', 'MicroSD UHS-I 512GB para cámaras', 'STOR-MSDXC-001', 10, 59.99, 30.00, 50, 15, true, 1, '2025-01-17 13:00:00');

-- =====================================================
-- 4. INSERTAR CLIENTES (10 clientes de Ecuador)
-- =====================================================
INSERT INTO customers (first_name, last_name, email, phone, address, city, country, postal_code, is_active, total_spent, order_count, created_at) VALUES
('Carlos', 'Rodríguez', 'carlos.rodriguez@email.com', '+593-99-123-4567', 'Calle Mariano Samaniego 123', 'Quito', 'Ecuador', '170501', true, 3579.93, 3, '2025-01-05 10:00:00'),
('Laura', 'Martínez', 'laura.martinez@email.com', '+593-98-456-7890', 'Avenida 9 de Octubre 456', 'Guayaquil', 'Ecuador', '090210', true, 1399.98, 2, '2025-01-06 10:00:00'),
('Pedro', 'Sánchez', 'pedro.sanchez@email.com', '+593-96-789-0123', 'Calle Larga 789', 'Cuenca', 'Ecuador', '010110', true, 2852.35, 1, '2025-01-07 10:00:00'),
('María', 'González', 'maria.gonzalez@email.com', '+593-99-234-5678', 'Avenida América 999', 'Quito', 'Ecuador', '170102', true, 0.00, 0, '2025-01-08 10:00:00'),
('José', 'López', 'jose.lopez@email.com', '+593-98-321-0987', 'Calle Pichincha 321', 'Ibarra', 'Ecuador', '100401', true, 0.00, 0, '2025-01-09 10:00:00'),
('Ana', 'Flores', 'ana.flores@email.com', '+593-99-654-3210', 'Avenida España 654', 'Machala', 'Ecuador', '070101', true, 0.00, 0, '2025-01-10 10:00:00'),
('Miguel', 'Torres', 'miguel.torres@email.com', '+593-96-987-6543', 'Calle Sucre 987', 'Ambato', 'Ecuador', '180150', true, 0.00, 0, '2025-01-11 10:00:00'),
('Sofia', 'Ramírez', 'sofia.ramirez@email.com', '+593-98-147-2589', 'Avenida Real 555', 'Manta', 'Ecuador', '130101', true, 0.00, 0, '2025-01-12 10:00:00'),
('Diego', 'Morales', 'diego.morales@email.com', '+593-99-369-2580', 'Calle 10 de Agosto 111', 'Riobamba', 'Ecuador', '060150', true, 0.00, 0, '2025-01-13 10:00:00'),
('Lucia', 'Castro', 'lucia.castro@email.com', '+593-96-258-1470', 'Calle García Moreno 222', 'Latacunga', 'Ecuador', '050101', true, 0.00, 0, '2025-01-14 10:00:00');

-- =====================================================
-- 5. INSERTAR ÓRDENES
-- =====================================================
INSERT INTO orders (customer_id, user_id, order_number, status, subtotal, tax, shipping_cost, total, shipping_address, shipping_city, shipping_country, shipping_postal_code, created_at, shipped_at, delivered_at) VALUES
(1, 1, 'ORD-2025-001', 'delivered', 1549.97, 247.99, 50.00, 1847.96, 'Calle Mariano Samaniego 123', 'Quito', 'Ecuador', '170501', '2025-01-15 10:30:00', '2025-01-16 14:00:00', '2025-01-18 10:00:00'),
(2, 2, 'ORD-2025-002', 'delivered', 999.99, 159.99, 30.00, 1189.98, 'Avenida 9 de Octubre 456', 'Guayaquil', 'Ecuador', '090210', '2025-01-16 14:20:00', '2025-01-17 10:00:00', '2025-01-19 15:30:00'),
(3, 1, 'ORD-2025-003', 'shipped', 2389.96, 382.39, 80.00, 2852.35, 'Calle Larga 789', 'Cuenca', 'Ecuador', '010110', '2025-01-18 09:15:00', '2025-01-20 11:00:00', NULL),
(1, 3, 'ORD-2025-004', 'processing', 1449.98, 231.99, 50.00, 1731.97, 'Calle Mariano Samaniego 123', 'Quito', 'Ecuador', '170501', '2025-01-22 11:30:00', NULL, NULL),
(2, 2, 'ORD-2025-005', 'pending', 799.99, 128.00, 30.00, 957.99, 'Avenida 9 de Octubre 456', 'Guayaquil', 'Ecuador', '090210', '2025-01-25 15:00:00', NULL, NULL);

-- =====================================================
-- 6. INSERTAR ORDER_ITEMS (detalles de cada orden)
-- =====================================================
-- Orden 1 (ORD-2025-001) - Customer: Carlos Rodríguez
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal, created_at) VALUES
(1, 1, 1, 1299.99, 1299.99, '2025-01-15 10:30:00'),
(1, 8, 2, 124.99, 249.98, '2025-01-15 10:30:00');

-- Orden 2 (ORD-2025-002) - Customer: Laura Martínez
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal, created_at) VALUES
(2, 4, 1, 999.99, 999.99, '2025-01-16 14:20:00');

-- Orden 3 (ORD-2025-003) - Customer: Pedro Sánchez
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal, created_at) VALUES
(3, 2, 1, 1999.99, 1999.99, '2025-01-18 09:15:00'),
(3, 5, 2, 194.99, 389.98, '2025-01-18 09:15:00');

-- Orden 4 (ORD-2025-004) - Customer: Carlos Rodríguez
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal, created_at) VALUES
(4, 3, 2, 699.99, 1399.98, '2025-01-22 11:30:00'),
(4, 12, 1, 49.99, 49.99, '2025-01-22 11:30:00');

-- Orden 5 (ORD-2025-005) - Customer: Laura Martínez
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal, created_at) VALUES
(5, 6, 1, 799.99, 799.99, '2025-01-25 15:00:00');

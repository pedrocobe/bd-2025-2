-- =====================================================
-- DATOS DE PRUEBA - E-COMMERCE EXAM (CORREGIDO)
-- =====================================================

-- Limpiar datos existentes
TRUNCATE TABLE audit_log, order_items, orders, customers, products, categories, users RESTART IDENTITY CASCADE;

-- =====================================================
-- 1. USERS
-- =====================================================
INSERT INTO users (username, email, password_hash, full_name, role, is_active) VALUES
('admin', 'admin@ecommerce.com', '$2b$10$K7L/gMNLHwYK3pqR8YqHKOZ8ZqZ8ZqZ8ZqZ8ZqZ8ZqZ8ZqZ8ZqZ8Zq', 'Administrador Principal', 'admin', true),
('manager1', 'manager@ecommerce.com', '$2b$10$K7L/gMNLHwYK3pqR8YqHKOZ8ZqZ8ZqZ8ZqZ8ZqZ8ZqZ8ZqZ8ZqZ8Zq', 'Carlos Martínez', 'manager', true),
('employee1', 'employee1@ecommerce.com', '$2b$10$K7L/gMNLHwYK3pqR8YqHKOZ8ZqZ8ZqZ8ZqZ8ZqZ8ZqZ8ZqZ8ZqZ8Zq', 'Ana García', 'employee', true),
('employee2', 'employee2@ecommerce.com', '$2b$10$K7L/gMNLHwYK3pqR8YqHKOZ8ZqZ8ZqZ8ZqZ8ZqZ8ZqZ8ZqZ8ZqZ8Zq', 'Luis Rodríguez', 'employee', true),
('employee3', 'employee3@ecommerce.com', '$2b$10$K7L/gMNLHwYK3pqR8YqHKOZ8ZqZ8ZqZ8ZqZ8ZqZ8ZqZ8ZqZ8ZqZ8Zq', 'María López', 'employee', false);

-- =====================================================
-- 2. CATEGORIES
-- =====================================================
INSERT INTO categories (name, description, parent_id) VALUES
('Electrónica', 'Dispositivos y aparatos electrónicos', NULL),
('Ropa', 'Prendas de vestir y accesorios', NULL),
('Hogar', 'Artículos para el hogar', NULL),
('Deportes', 'Artículos deportivos y fitness', NULL),
('Libros', 'Libros físicos y digitales', NULL);

INSERT INTO categories (name, description, parent_id) VALUES
('Computadoras', 'Laptops, desktops y tablets', 1),
('Celulares', 'Smartphones y accesorios', 1),
('Audio', 'Audífonos, bocinas y equipos de sonido', 1),
('Hombre', 'Ropa para hombre', 2),
('Mujer', 'Ropa para mujer', 2),
('Niños', 'Ropa infantil', 2),
('Cocina', 'Utensilios y electrodomésticos de cocina', 3),
('Muebles', 'Muebles para el hogar', 3),
('Gimnasio', 'Equipo para gimnasio', 4);

-- =====================================================
-- 3. PRODUCTS
-- =====================================================
INSERT INTO products (name, description, sku, price, cost, stock_quantity, min_stock_level, category_id, is_active) VALUES
-- Computadoras (category_id: 6)
('Laptop Dell Inspiron 15', 'Laptop con procesador Intel Core i5, 8GB RAM, 256GB SSD', 'DELL-INS-001', 699.99, 500.00, 15, 10, 6, true),
('MacBook Air M2', 'MacBook Air con chip M2, 8GB RAM, 256GB SSD', 'APPLE-MBA-001', 1199.99, 900.00, 8, 5, 6, true),
('iPad Pro 11"', 'iPad Pro de 11 pulgadas, 128GB', 'APPLE-IPD-001', 799.99, 600.00, 12, 10, 6, true),

-- Celulares (category_id: 7)
('iPhone 15 Pro', 'iPhone 15 Pro 256GB, Titanio Natural', 'APPLE-IP15-001', 1099.99, 800.00, 20, 10, 7, true),
('Samsung Galaxy S24', 'Samsung Galaxy S24 5G, 128GB', 'SAMS-S24-001', 899.99, 650.00, 25, 15, 7, true),
('Xiaomi Redmi Note 13', 'Xiaomi Redmi Note 13 Pro, 256GB', 'XIAO-RN13-001', 299.99, 200.00, 40, 20, 7, true),

-- Audio (category_id: 8)
('AirPods Pro 2', 'AirPods Pro de 2da generación con USB-C', 'APPLE-APP-001', 249.99, 180.00, 30, 15, 8, true),
('Sony WH-1000XM5', 'Audífonos con cancelación de ruido premium', 'SONY-WH5-001', 399.99, 280.00, 18, 10, 8, true),
('JBL Flip 6', 'Bocina Bluetooth portátil resistente al agua', 'JBL-FLP6-001', 129.99, 80.00, 35, 20, 8, true),

-- Ropa Hombre (category_id: 9)
('Camisa Formal Azul', 'Camisa de vestir azul marino, algodón 100%', 'CLOTH-SH-001', 49.99, 25.00, 50, 25, 9, true),
('Jeans Levi''s 501', 'Jeans clásicos Levi''s 501, corte regular', 'LEVIS-501-001', 79.99, 45.00, 60, 30, 9, true),
('Chaqueta de Cuero', 'Chaqueta de cuero genuino color negro', 'JACKET-LTH-001', 199.99, 120.00, 15, 10, 9, true),

-- Ropa Mujer (category_id: 10)
('Vestido Floral', 'Vestido floral de verano, tela ligera', 'DRESS-FLR-001', 59.99, 30.00, 40, 20, 10, true),
('Blusa Blanca Elegante', 'Blusa blanca de seda, ideal para oficina', 'BLOUSE-WHT-001', 69.99, 35.00, 45, 25, 10, true),

-- Cocina (category_id: 12)
('Licuadora Oster', 'Licuadora de 10 velocidades, 600W', 'OSTER-BLD-001', 89.99, 50.00, 25, 15, 12, true),
('Juego de Sartenes', 'Set de 3 sartenes antiadherentes', 'KITCHEN-PAN-001', 119.99, 70.00, 20, 10, 12, true),
('Cafetera Nespresso', 'Cafetera de cápsulas Nespresso', 'NESPRESSO-001', 149.99, 90.00, 18, 10, 12, true),

-- Muebles (category_id: 13)
('Sofá 3 Plazas Gris', 'Sofá moderno de 3 plazas, tela gris', 'SOFA-3P-001', 599.99, 350.00, 8, 5, 13, true),
('Mesa de Centro', 'Mesa de centro de madera y vidrio', 'TABLE-CTR-001', 199.99, 120.00, 12, 8, 13, true),

-- Gimnasio (category_id: 14)
('Mancuernas Ajustables', 'Par de mancuernas ajustables 5-25kg', 'GYM-DUMB-001', 199.99, 120.00, 15, 10, 14, true),
('Caminadora Eléctrica', 'Caminadora plegable con pantalla LCD', 'GYM-TREAD-001', 499.99, 300.00, 6, 5, 14, true),
('Yoga Mat Premium', 'Tapete de yoga antideslizante 6mm', 'GYM-YOGA-001', 39.99, 20.00, 50, 25, 14, true),

-- Libros (category_id: 5)
('Cien Años de Soledad', 'Gabriel García Márquez - Novela clásica', 'BOOK-GGM-001', 19.99, 10.00, 100, 50, 5, true),
('El Principito', 'Antoine de Saint-Exupéry - Libro ilustrado', 'BOOK-ASE-001', 14.99, 8.00, 80, 40, 5, true),
('1984', 'George Orwell - Distopía clásica', 'BOOK-GO-001', 16.99, 9.00, 75, 35, 5, true);

-- =====================================================
-- 4. CUSTOMERS
-- =====================================================
INSERT INTO customers (first_name, last_name, email, phone, address, city, country) VALUES
('Juan', 'Pérez', 'juan.perez@email.com', '+593-98-765-4321', 'Av. Amazonas N24-03', 'Quito', 'Ecuador'),
('María', 'González', 'maria.gonzalez@email.com', '+593-99-123-4567', 'Calle 10 de Agosto 234', 'Quito', 'Ecuador'),
('Carlos', 'Ramírez', 'carlos.ramirez@email.com', '+593-98-234-5678', 'Av. 6 de Diciembre 456', 'Quito', 'Ecuador'),
('Ana', 'Martínez', 'ana.martinez@email.com', '+593-99-345-6789', 'Calle Venezuela 789', 'Quito', 'Ecuador'),
('Luis', 'Fernández', 'luis.fernandez@email.com', '+593-98-456-7890', 'Av. Naciones Unidas 123', 'Quito', 'Ecuador'),
('Laura', 'Torres', 'laura.torres@email.com', '+593-99-567-8901', 'Calle Shyris 456', 'Quito', 'Ecuador'),
('Pedro', 'Sánchez', 'pedro.sanchez@email.com', '+593-98-678-9012', 'Av. República 789', 'Quito', 'Ecuador'),
('Sofia', 'López', 'sofia.lopez@email.com', '+593-99-789-0123', 'Calle Colón 321', 'Quito', 'Ecuador'),
('Diego', 'Vargas', 'diego.vargas@email.com', '+593-98-890-1234', 'Av. Patria 654', 'Quito', 'Ecuador'),
('Carmen', 'Morales', 'carmen.morales@email.com', '+593-99-901-2345', 'Calle Orellana 987', 'Quito', 'Ecuador');

-- =====================================================
-- 5. ORDERS
-- =====================================================
INSERT INTO orders (customer_id, order_date, total_amount, status, shipping_address, notes) VALUES
(1, '2026-01-20 10:30:00', 1949.97, 'delivered', 'Av. Amazonas N24-03, Quito, Ecuador', 'Entrega rápida solicitada'),
(2, '2026-01-21 14:15:00', 349.98, 'delivered', 'Calle 10 de Agosto 234, Quito, Ecuador', NULL),
(3, '2026-01-22 09:45:00', 1099.99, 'shipped', 'Av. 6 de Diciembre 456, Quito, Ecuador', 'Cliente prefiere entrega por la tarde'),
(4, '2026-01-23 16:20:00', 101.96, 'processing', 'Calle Venezuela 789, Quito, Ecuador', NULL),
(5, '2026-01-24 11:00:00', 1499.98, 'processing', 'Av. Naciones Unidas 123, Quito, Ecuador', 'Enviar factura electrónica'),
(6, '2026-01-25 13:30:00', 179.97, 'pending', 'Calle Shyris 456, Quito, Ecuador', NULL),
(7, '2026-01-26 15:45:00', 199.99, 'pending', 'Av. República 789, Quito, Ecuador', 'Empacar con cuidado'),
(8, '2026-01-27 10:00:00', 1299.98, 'cancelled', 'Calle Colón 321, Quito, Ecuador', 'Cliente canceló por error en dirección');

-- =====================================================
-- 6. ORDER_ITEMS
-- =====================================================

-- Pedido 1 (customer 1) - 3 items
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(1, 2, 1, 1199.99, 1199.99),  -- MacBook Air
(1, 7, 2, 249.99, 499.98),    -- AirPods Pro (x2)
(1, 9, 1, 129.99, 129.99);    -- JBL Flip 6 (producto 9 existe)

-- Pedido 2 (customer 2) - 2 items
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(2, 6, 1, 299.99, 299.99),    -- Xiaomi Redmi Note
(2, 9, 1, 49.99, 49.99);      -- JBL (ajustado)

-- Pedido 3 (customer 3) - 1 item
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(3, 4, 1, 1099.99, 1099.99);  -- iPhone 15 Pro

-- Pedido 4 (customer 4) - 3 items (LIBROS: productos 23, 24, 25)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(4, 23, 2, 19.99, 39.98),     -- Cien Años de Soledad (x2)
(4, 24, 3, 14.99, 44.97),     -- El Principito (x3)
(4, 25, 1, 16.99, 16.99);     -- 1984

-- Pedido 5 (customer 5) - 2 items
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(5, 5, 1, 899.99, 899.99),    -- Samsung Galaxy
(5, 1, 1, 699.99, 699.99);    -- Laptop Dell (en vez de Sony)

-- Pedido 6 (customer 6) - 3 items
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(6, 13, 1, 59.99, 59.99),     -- Vestido Floral
(6, 14, 1, 69.99, 69.99),     -- Blusa Blanca
(6, 10, 1, 49.99, 49.99);     -- Camisa Formal

-- Pedido 7 (customer 7) - 1 item
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(7, 20, 1, 199.99, 199.99);   -- Mancuernas

-- Pedido 8 (customer 8) - CANCELADO - 2 items
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(8, 1, 1, 699.99, 699.99),    -- Laptop Dell
(8, 18, 1, 599.99, 599.99);   -- Sofá

-- =====================================================
-- VERIFICACIÓN
-- =====================================================
SELECT 'Users:' as tabla, COUNT(*) as total FROM users
UNION ALL
SELECT 'Categories:', COUNT(*) FROM categories
UNION ALL
SELECT 'Products:', COUNT(*) FROM products
UNION ALL
SELECT 'Customers:', COUNT(*) FROM customers
UNION ALL
SELECT 'Orders:', COUNT(*) FROM orders
UNION ALL
SELECT 'Order Items:', COUNT(*) FROM order_items;
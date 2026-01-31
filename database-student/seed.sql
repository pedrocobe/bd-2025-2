-- =====================================================
-- DATOS DE PRUEBA - E-COMMERCE EXAM
-- =====================================================
SET client_encoding = 'UTF8';

-- 1. USUARIOS (4 usuarios con diferentes roles)
INSERT INTO users (username, email, password_hash, full_name, role, is_active) VALUES
('admin', 'admin@ecommerce.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Administrator User', 'admin', true),
('manager1', 'manager@ecommerce.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Maria Garcia', 'manager', true),
('employee1', 'employee1@ecommerce.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Carlos Lopez', 'employee', true),
('employee2', 'employee2@ecommerce.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Ana Martinez', 'employee', true);

-- 2. CATEGORIAS (15 categorias con jerarquia padre-hijo)
INSERT INTO categories (name, description, parent_id, is_active) VALUES
-- Categorias principales (sin parent_id)
('Electronics', 'Electronic devices and accessories', NULL, true),
('Clothing', 'Fashion and apparel', NULL, true),
('Home & Garden', 'Home improvement and garden supplies', NULL, true),
('Sports', 'Sports equipment and fitness', NULL, true),
('Books', 'Books and educational materials', NULL, true),

-- Subcategorias de Electronics
('Laptops', 'Portable computers', 1, true),
('Smartphones', 'Mobile phones and accessories', 1, true),
('Tablets', 'Tablet computers', 1, true),

-- Subcategorias de Clothing
('Men Fashion', 'Clothing for men', 2, true),
('Women Fashion', 'Clothing for women', 2, true),

-- Subcategorias de Home & Garden
('Furniture', 'Home furniture', 3, true),
('Kitchen', 'Kitchen appliances and tools', 3, true),

-- Subcategorias de Sports
('Gym Equipment', 'Fitness and gym equipment', 4, true),
('Outdoor Sports', 'Outdoor activities equipment', 4, true),

-- Subcategoria de Books
('Technical Books', 'Programming and technology books', 5, true);

-- 3. PRODUCTOS (30 productos variados)
INSERT INTO products (name, description, sku, category_id, price, cost, stock_quantity, min_stock_level, is_active, created_by) VALUES
-- Electronics - Laptops
('Dell XPS 15', 'High performance laptop with Intel i7', 'LAP-DELL-001', 6, 1299.99, 900.00, 25, 5, true, 1),
('MacBook Pro 14', 'Apple M3 chip, 16GB RAM', 'LAP-APPLE-001', 6, 1999.99, 1500.00, 15, 3, true, 1),
('HP Pavilion', 'Budget friendly laptop for students', 'LAP-HP-001', 6, 699.99, 450.00, 40, 10, true, 1),

-- Electronics - Smartphones
('iPhone 15 Pro', 'Latest Apple smartphone', 'PHONE-APPLE-001', 7, 999.99, 700.00, 50, 10, true, 1),
('Samsung Galaxy S24', 'Android flagship phone', 'PHONE-SAM-001', 7, 899.99, 600.00, 45, 10, true, 1),
('Google Pixel 8', 'Pure Android experience', 'PHONE-GOOGLE-001', 7, 699.99, 480.00, 30, 8, true, 1),

-- Electronics - Tablets
('iPad Air', 'Apple tablet with M2 chip', 'TAB-APPLE-001', 8, 599.99, 420.00, 35, 8, true, 1),
('Samsung Galaxy Tab', 'Android tablet for work and play', 'TAB-SAM-001', 8, 449.99, 310.00, 28, 6, true, 1),

-- Clothing - Men
('Nike T-Shirt', 'Cotton sports t-shirt', 'CLOTH-NIKE-001', 9, 29.99, 12.00, 100, 20, true, 2),
('Levis Jeans', 'Classic denim jeans 501', 'CLOTH-LEVI-001', 9, 79.99, 35.00, 75, 15, true, 2),
('Adidas Sneakers', 'Running shoes for men', 'SHOE-ADIDAS-001', 9, 89.99, 40.00, 60, 12, true, 2),

-- Clothing - Women
('Zara Dress', 'Summer floral dress', 'CLOTH-ZARA-001', 10, 49.99, 20.00, 55, 10, true, 2),
('H&M Blouse', 'Elegant blouse for office', 'CLOTH-HM-001', 10, 34.99, 15.00, 80, 15, true, 2),
('Nike Leggings', 'Yoga and fitness leggings', 'CLOTH-NIKE-002', 10, 44.99, 18.00, 90, 20, true, 2),

-- Home & Garden - Furniture
('IKEA Desk', 'Modern office desk', 'FURN-IKEA-001', 11, 199.99, 120.00, 20, 5, true, 3),
('Office Chair', 'Ergonomic swivel chair', 'FURN-CHAIR-001', 11, 149.99, 80.00, 30, 8, true, 3),
('Bookshelf', 'Wooden bookshelf 5 levels', 'FURN-SHELF-001', 11, 89.99, 45.00, 25, 5, true, 3),

-- Home & Garden - Kitchen
('KitchenAid Mixer', 'Professional stand mixer', 'KITCH-MIXER-001', 12, 299.99, 180.00, 18, 4, true, 3),
('Blender Pro', 'High power blender 1000W', 'KITCH-BLEND-001', 12, 79.99, 40.00, 35, 8, true, 3),
('Coffee Maker', 'Programmable coffee machine', 'KITCH-COFFEE-001', 12, 59.99, 30.00, 40, 10, true, 3),

-- Sports - Gym Equipment
('Dumbbells Set', 'Adjustable dumbbells 5-25kg', 'GYM-DUMB-001', 13, 149.99, 80.00, 22, 5, true, 4),
('Yoga Mat', 'Premium non-slip yoga mat', 'GYM-YOGA-001', 13, 29.99, 12.00, 70, 15, true, 4),
('Resistance Bands', 'Set of 5 resistance bands', 'GYM-BAND-001', 13, 24.99, 10.00, 85, 20, true, 4),

-- Sports - Outdoor
('Mountain Bike', '21-speed mountain bicycle', 'SPORT-BIKE-001', 14, 399.99, 250.00, 12, 3, true, 4),
('Camping Tent', '4-person waterproof tent', 'SPORT-TENT-001', 14, 159.99, 90.00, 15, 4, true, 4),
('Soccer Ball', 'Professional size 5 soccer ball', 'SPORT-BALL-001', 14, 34.99, 15.00, 50, 12, true, 4),

-- Books - Technical
('Clean Code', 'Robert Martin programming book', 'BOOK-PROG-001', 15, 44.99, 25.00, 45, 10, true, 1),
('Python Crash Course', 'Learn Python programming', 'BOOK-PYTHON-001', 15, 39.99, 22.00, 38, 8, true, 1),
('Design Patterns', 'Gang of Four classic book', 'BOOK-DESIGN-001', 15, 49.99, 28.00, 30, 8, true, 1),
('JavaScript Guide', 'Modern JavaScript development', 'BOOK-JS-001', 15, 42.99, 24.00, 35, 8, true, 1);

-- 4. CLIENTES (10 clientes - SIN TILDES)
INSERT INTO customers (first_name, last_name, email, phone, address, city, country, postal_code, is_active) VALUES
('Juan', 'Perez', 'juan.perez@email.com', '+593987654321', 'Av. Principal 123', 'Quito', 'Ecuador', '170101', true),
('Maria', 'Gonzalez', 'maria.gonzalez@email.com', '+593987654322', 'Calle Secundaria 456', 'Guayaquil', 'Ecuador', '090101', true),
('Carlos', 'Rodriguez', 'carlos.rodriguez@email.com', '+593987654323', 'Av. Libertad 789', 'Cuenca', 'Ecuador', '010101', true),
('Ana', 'Martinez', 'ana.martinez@email.com', '+593987654324', 'Calle 10 de Agosto 321', 'Quito', 'Ecuador', '170102', true),
('Luis', 'Hernandez', 'luis.hernandez@email.com', '+593987654325', 'Av. 9 de Octubre 654', 'Guayaquil', 'Ecuador', '090102', true),
('Sofia', 'Lopez', 'sofia.lopez@email.com', '+593987654326', 'Calle Bolivar 147', 'Cuenca', 'Ecuador', '010102', true),
('Diego', 'Garcia', 'diego.garcia@email.com', '+593987654327', 'Av. America 258', 'Quito', 'Ecuador', '170103', true),
('Valentina', 'Fernandez', 'valentina.fernandez@email.com', '+593987654328', 'Calle Rocafuerte 369', 'Guayaquil', 'Ecuador', '090103', true),
('Andres', 'Diaz', 'andres.diaz@email.com', '+593987654329', 'Av. Ordonez Lasso 741', 'Cuenca', 'Ecuador', '010103', true),
('Camila', 'Torres', 'camila.torres@email.com', '+593987654330', 'Calle Amazonas 852', 'Quito', 'Ecuador', '170104', true);

-- 5. PEDIDOS (8 pedidos en diferentes estados - con campos completos)
INSERT INTO orders (order_number, customer_id, status, subtotal, tax, shipping_cost, total, shipping_address, shipping_city, shipping_country, created_by, created_at) VALUES
('ORD-2025-001', 1, 'delivered', 1389.97, 166.79, 5.00, 1561.76, 'Av. Principal 123', 'Quito', 'Ecuador', 2, '2025-01-15 10:30:00'),
('ORD-2025-002', 2, 'shipped', 1089.98, 130.79, 5.00, 1225.77, 'Calle Secundaria 456', 'Guayaquil', 'Ecuador', 2, '2025-01-20 14:15:00'),
('ORD-2025-003', 3, 'processing', 429.97, 51.59, 5.00, 486.56, 'Av. Libertad 789', 'Cuenca', 'Ecuador', 3, '2025-01-25 09:45:00'),
('ORD-2025-004', 4, 'delivered', 224.96, 26.99, 5.00, 256.95, 'Calle 10 de Agosto 321', 'Quito', 'Ecuador', 3, '2025-01-10 16:20:00'),
('ORD-2025-005', 5, 'pending', 84.98, 10.19, 5.00, 100.17, 'Av. 9 de Octubre 654', 'Guayaquil', 'Ecuador', 2, '2025-01-28 11:00:00'),
('ORD-2025-006', 1, 'delivered', 839.92, 100.79, 5.00, 945.71, 'Av. Principal 123', 'Quito', 'Ecuador', 2, '2025-01-22 13:30:00'),
('ORD-2025-007', 6, 'cancelled', 399.99, 47.99, 5.00, 452.98, 'Calle Bolivar 147', 'Cuenca', 'Ecuador', 4, '2025-01-18 15:45:00'),
('ORD-2025-008', 7, 'delivered', 439.97, 52.79, 5.00, 497.76, 'Av. America 258', 'Quito', 'Ecuador', 3, '2025-01-12 10:00:00');

-- 6. ORDER_ITEMS (Multiples items por pedido)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
-- Pedido 1 (delivered)
(1, 1, 1, 1299.99, 1299.99),
(1, 9, 2, 29.99, 59.98),
(1, 22, 1, 29.99, 29.99),

-- Pedido 2 (shipped)
(2, 4, 1, 999.99, 999.99),
(2, 11, 1, 89.99, 89.99),

-- Pedido 3 (processing)
(3, 15, 1, 199.99, 199.99),
(3, 16, 1, 149.99, 149.99),
(3, 19, 1, 79.99, 79.99),

-- Pedido 4 (delivered)
(4, 12, 2, 49.99, 99.98),
(4, 13, 1, 34.99, 34.99),
(4, 14, 2, 44.99, 89.98),

-- Pedido 5 (pending)
(5, 27, 1, 44.99, 44.99),
(5, 28, 1, 39.99, 39.99),

-- Pedido 6 (delivered)
(6, 21, 5, 149.99, 749.95),
(6, 22, 3, 29.99, 89.97),

-- Pedido 7 (cancelled)
(7, 24, 1, 399.99, 399.99),

-- Pedido 8 (delivered)
(8, 18, 1, 299.99, 299.99),
(8, 19, 1, 79.99, 79.99),
(8, 20, 1, 59.99, 59.99);

-- 7. ACTUALIZAR ESTADISTICAS DE CLIENTES
UPDATE customers SET total_spent = 1561.76, order_count = 1 WHERE id = 1;
UPDATE customers SET total_spent = 1225.77, order_count = 1 WHERE id = 2;
UPDATE customers SET total_spent = 486.56, order_count = 1 WHERE id = 3;
UPDATE customers SET total_spent = 256.95, order_count = 1 WHERE id = 4;
UPDATE customers SET total_spent = 100.17, order_count = 1 WHERE id = 5;
UPDATE customers SET total_spent = 945.71, order_count = 1 WHERE id = 1; -- Juan tiene 2 pedidos
UPDATE customers SET total_spent = 0, order_count = 0 WHERE id = 6; -- Pedido cancelado
UPDATE customers SET total_spent = 497.76, order_count = 1 WHERE id = 7;
UPDATE customers SET total_spent = 0, order_count = 0 WHERE id IN (8, 9, 10);

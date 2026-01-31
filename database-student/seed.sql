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
-- 1. Insertar usuarios (4 usuarios con roles variados)
INSERT INTO users (username, email, password_hash, full_name, role) VALUES
('admin', 'admin@example.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Admin User', 'admin'),
('manager', 'manager@example.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Manager User', 'manager'),
('employee1', 'employee1@example.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Employee One', 'employee'),
('employee2', 'employee2@example.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Employee Two', 'employee');

-- 2. Insertar categorías (12 categorías con jerarquía)
INSERT INTO categories (name, parent_id, description) VALUES
('Electronics', NULL, 'Electronic devices and accessories'),
('Computers', 1, 'Computers and laptops'),
('Phones', 1, 'Mobile phones and tablets'),
('Audio', 1, 'Audio equipment'),
('Clothing', NULL, 'Apparel and fashion'),
('Men', 5, 'Men''s clothing'),
('Women', 5, 'Women''s clothing'),
('Accessories', 5, 'Fashion accessories'),
('Home', NULL, 'Home appliances and furniture'),
('Kitchen', 9, 'Kitchen appliances'),
('Furniture', 9, 'Home furniture'),
('Books', NULL, 'Books and literature');

-- 3. Insertar productos (25 productos variados)
INSERT INTO products (name, sku, description, price, cost, stock_quantity, category_id) VALUES
('Laptop Pro', 'LAP001', 'High-end laptop', 999.99, 800.00, 50, 2),
('Smartphone X', 'PHN001', 'Latest smartphone', 599.99, 400.00, 100, 3),
('T-Shirt Basic', 'TSH001', 'Cotton t-shirt', 19.99, 10.00, 200, 6),
('Dress Summer', 'DRS001', 'Summer dress', 49.99, 30.00, 150, 7),
('Monitor 4K', 'MON001', '4K UHD monitor', 199.99, 150.00, 30, 2),
('Headphones Wireless', 'HDP001', 'Bluetooth headphones', 99.99, 60.00, 80, 4),
('Jeans Slim', 'JNS001', 'Slim fit jeans', 39.99, 25.00, 120, 6),
('Skirt Midi', 'SKT001', 'Midi skirt', 29.99, 20.00, 100, 7),
('Tablet Fire', 'TBL001', 'Android tablet', 299.99, 200.00, 60, 3),
('Keyboard Mechanical', 'KEY001', 'Mechanical keyboard', 49.99, 30.00, 90, 2),
('Blender Pro', 'BLD001', 'Kitchen blender', 79.99, 50.00, 40, 10),
('Sofa Comfort', 'SOF001', 'Comfortable sofa', 499.99, 300.00, 20, 11),
('Novel Adventure', 'BOK001', 'Adventure novel', 14.99, 8.00, 300, 12),
('Smartwatch', 'WAT001', 'Fitness smartwatch', 149.99, 100.00, 70, 1),
('Sneakers Running', 'SNK001', 'Running sneakers', 59.99, 40.00, 110, 8),
('Microwave Oven', 'MIC001', 'Compact microwave', 89.99, 60.00, 50, 10),
('Desk Chair', 'CHR001', 'Ergonomic chair', 129.99, 80.00, 35, 11),
('Earbuds True Wireless', 'EAR001', 'True wireless earbuds', 79.99, 50.00, 90, 4),
('Backpack Travel', 'BKP001', 'Travel backpack', 39.99, 25.00, 80, 8),
('Coffee Maker', 'COF001', 'Drip coffee maker', 49.99, 30.00, 60, 10),
('Bed Frame', 'BED001', 'Wooden bed frame', 299.99, 200.00, 25, 11),
('Sci-Fi Book', 'BOK002', 'Science fiction book', 19.99, 10.00, 250, 12),
('Charger Fast', 'CHG001', 'Fast charger', 29.99, 15.00, 150, 1),
('Hat Summer', 'HAT001', 'Summer hat', 14.99, 8.00, 100, 8),
('Toaster 4-Slice', 'TOS001', '4-slice toaster', 39.99, 25.00, 45, 10);

-- 4. Insertar clientes (10 clientes con información completa)
INSERT INTO customers (full_name, email, phone, address) VALUES
('John Doe', 'john@example.com', '1234567890', '123 Main St, City A'),
('Jane Smith', 'jane@example.com', '0987654321', '456 Elm St, City B'),
('Alice Johnson', 'alice@example.com', '1112223334', '789 Oak St, City C'),
('Bob Brown', 'bob@example.com', '4445556667', '101 Pine St, City D'),
('Carol Davis', 'carol@example.com', '7778889990', '202 Maple St, City E'),
('David Evans', 'david@example.com', '3334445556', '303 Birch St, City F'),
('Eve Foster', 'eve@example.com', '6667778889', '404 Cedar St, City G'),
('Frank Green', 'frank@example.com', '9990001112', '505 Walnut St, City H'),
('Grace Harris', 'grace@example.com', '2223334445', '606 Chestnut St, City I'),
('Henry Irving', 'henry@example.com', '5556667778', '707 Spruce St, City J');

-- 5. Insertar pedidos (8 pedidos en diferentes estados)
INSERT INTO orders (customer_id, user_id, status, total_amount, discount, tax, shipping_address, order_date) VALUES
(1, 3, 'pending', 0.00, 0.00, 0.00, '123 Main St, City A', CURRENT_TIMESTAMP - INTERVAL '1 day'),
(2, 4, 'processing', 0.00, 10.00, 5.00, '456 Elm St, City B', CURRENT_TIMESTAMP - INTERVAL '2 days'),
(3, 3, 'shipped', 0.00, 0.00, 0.00, '789 Oak St, City C', CURRENT_TIMESTAMP - INTERVAL '3 days'),
(4, 4, 'delivered', 0.00, 5.00, 2.50, '101 Pine St, City D', CURRENT_TIMESTAMP - INTERVAL '4 days'),
(5, 3, 'cancelled', 0.00, 0.00, 0.00, '202 Maple St, City E', CURRENT_TIMESTAMP - INTERVAL '5 days'),
(6, 4, 'pending', 0.00, 15.00, 7.50, '303 Birch St, City F', CURRENT_TIMESTAMP - INTERVAL '6 days'),
(7, 3, 'processing', 0.00, 0.00, 0.00, '404 Cedar St, City G', CURRENT_TIMESTAMP - INTERVAL '7 days'),
(8, 4, 'shipped', 0.00, 20.00, 10.00, '505 Walnut St, City H', CURRENT_TIMESTAMP - INTERVAL '8 days');

-- 6. Insertar items de pedidos (múltiples por pedido, actualiza total_amount manualmente si no hay triggers)
-- Pedido 1: 3 items
INSERT INTO order_items (order_id, product_id, quantity, price, subtotal) VALUES
(1, 1, 1, 999.99, 999.99),
(1, 3, 2, 19.99, 39.98),
(1, 6, 1, 99.99, 99.99);
UPDATE orders SET total_amount = (SELECT SUM(subtotal) FROM order_items WHERE order_id = 1) WHERE id = 1;

-- Pedido 2: 4 items
INSERT INTO order_items (order_id, product_id, quantity, price, subtotal) VALUES
(2, 2, 1, 599.99, 599.99),
(2, 4, 1, 49.99, 49.99),
(2, 7, 3, 39.99, 119.97),
(2, 9, 1, 299.99, 299.99);
UPDATE orders SET total_amount = (SELECT SUM(subtotal) FROM order_items WHERE order_id = 2) WHERE id = 2;

-- Pedido 3: 2 items
INSERT INTO order_items (order_id, product_id, quantity, price, subtotal) VALUES
(3, 5, 1, 199.99, 199.99),
(3, 8, 2, 29.99, 59.98);
UPDATE orders SET total_amount = (SELECT SUM(subtotal) FROM order_items WHERE order_id = 3) WHERE id = 3;

-- Pedido 4: 3 items
INSERT INTO order_items (order_id, product_id, quantity, price, subtotal) VALUES
(4, 10, 1, 49.99, 49.99),
(4, 11, 1, 79.99, 79.99),
(4, 12, 1, 499.99, 499.99);
UPDATE orders SET total_amount = (SELECT SUM(subtotal) FROM order_items WHERE order_id = 4) WHERE id = 4;

-- Pedido 5: 2 items
INSERT INTO order_items (order_id, product_id, quantity, price, subtotal) VALUES
(5, 13, 2, 14.99, 29.98),
(5, 14, 1, 149.99, 149.99);
UPDATE orders SET total_amount = (SELECT SUM(subtotal) FROM order_items WHERE order_id = 5) WHERE id = 5;

-- Pedido 6: 4 items
INSERT INTO order_items (order_id, product_id, quantity, price, subtotal) VALUES
(6, 15, 1, 59.99, 59.99),
(6, 16, 1, 89.99, 89.99),
(6, 17, 1, 129.99, 129.99),
(6, 18, 2, 79.99, 159.98);
UPDATE orders SET total_amount = (SELECT SUM(subtotal) FROM order_items WHERE order_id = 6) WHERE id = 6;

-- Pedido 7: 3 items
INSERT INTO order_items (order_id, product_id, quantity, price, subtotal) VALUES
(7, 19, 1, 39.99, 39.99),
(7, 20, 1, 49.99, 49.99),
(7, 21, 1, 299.99, 299.99);
UPDATE orders SET total_amount = (SELECT SUM(subtotal) FROM order_items WHERE order_id = 7) WHERE id = 7;

-- Pedido 8: 2 items
INSERT INTO order_items (order_id, product_id, quantity, price, subtotal) VALUES
(8, 22, 3, 19.99, 59.97),
(8, 23, 1, 29.99, 29.99);
UPDATE orders SET total_amount = (SELECT SUM(subtotal) FROM order_items WHERE order_id = 8) WHERE id = 8;

-- Actualizar estadísticas de clientes si no hay triggers
DO $$
BEGIN
    PERFORM update_customer_stats(id) FROM customers;
END $$;

-- IMPORTANTE: Para las contraseñas, usa el hash bcrypt de "password123":
-- $2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ

-- Recuerda:
-- - Usar comillas simples para strings
-- - Separar valores con comas
-- - Terminar statements con punto y coma
-- - Puedes insertar múltiples registros en un solo INSERT


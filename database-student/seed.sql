TRUNCATE TABLE audit_log RESTART IDENTITY CASCADE;
TRUNCATE TABLE order_items RESTART IDENTITY CASCADE;
TRUNCATE TABLE orders RESTART IDENTITY CASCADE;
TRUNCATE TABLE customers RESTART IDENTITY CASCADE;
TRUNCATE TABLE products RESTART IDENTITY CASCADE;
TRUNCATE TABLE categories RESTART IDENTITY CASCADE;
TRUNCATE TABLE users RESTART IDENTITY CASCADE;

INSERT INTO users (username, email, password_hash, full_name, role) VALUES
('admin', 'admin@tienda.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Administrador Principal', 'admin'),
('gerente', 'gerente@tienda.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Juan Pérez', 'manager'),
('vendedor1', 'vendedor1@tienda.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Ana López', 'employee'),
('vendedor2', 'vendedor2@tienda.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Carlos Ruíz', 'employee');

INSERT INTO categories (name, description, parent_id) VALUES
('Electrónica', 'Dispositivos electrónicos y gadgets', NULL),
('Ropa', 'Ropa para damas y caballeros', NULL),
('Hogar', 'Artículos para el hogar y decoración', NULL);

INSERT INTO categories (name, description, parent_id) VALUES
('Computadoras', 'Laptops y Desktops', 1),
('Celulares', 'Smartphones y accesorios', 1),
('Hombre', 'Moda masculina', 2),
('Mujer', 'Moda femenina', 2);

INSERT INTO products (name, description, sku, category_id, price, cost, stock_quantity) VALUES
('Laptop Gamer X1', 'Laptop de alto rendimiento para juegos', 'LAP-001', 4, 1500.00, 1000.00, 10),
('MacBook Pro M2', 'Apple MacBook Pro 13 pulgadas', 'LAP-002', 4, 2000.00, 1600.00, 15),
('iPhone 15', 'Apple iPhone 15 128GB', 'PHN-001', 5, 999.99, 800.00, 25),
('Samsung Galaxy S24', 'Samsung Galaxy S24 Ultra', 'PHN-002', 5, 1100.00, 850.00, 20),
('Camiseta Básica', 'Camiseta de algodón 100%', 'CLO-M-001', 6, 15.00, 5.00, 100),
('Jeans Slim Fit', 'Pantalones vaqueros ajustados', 'CLO-M-002', 6, 45.00, 20.00, 50),
('Blusa Elegante', 'Blusa de seda para oficina', 'CLO-W-001', 7, 35.00, 15.00, 60),
('Vestido Verano', 'Vestido ligero con estampado floral', 'CLO-W-002', 7, 55.00, 25.00, 40),
('Lámpara de Mesa', 'Lámpara LED con intensidad ajustable', 'HOM-001', 3, 30.00, 12.00, 30),
('Juego de Sábanas', 'Sábanas matrimoniales de algodón', 'HOM-002', 3, 40.00, 18.00, 25);

INSERT INTO customers (first_name, last_name, email, city, country) VALUES
('María', 'García', 'maria.garcia@gmail.com', 'Madrid', 'España'),
('Pedro', 'Martínez', 'pedro.mtz@hotmail.com', 'Barcelona', 'España'),
('Laura', 'Sánchez', 'laura.sanchez@yahoo.com', 'Valencia', 'España'),
('Javier', 'Rodríguez', 'javi.rod@gmail.com', 'Sevilla', 'España'),
('Sofía', 'Hernández', 'sofia.h@outlook.com', 'Bilbao', 'España');

INSERT INTO orders (order_number, customer_id, status, subtotal, tax, shipping_cost, total, created_by, created_at)
VALUES ('ORD-2024-001', 1, 'delivered', 1515.00, 242.40, 10.00, 1767.40, 3, NOW() - INTERVAL '5 days');

INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(1, 1, 1, 1500.00, 1500.00), -- Laptop
(1, 5, 1, 15.00, 15.00);     -- Camiseta

INSERT INTO orders (order_number, customer_id, status, subtotal, tax, shipping_cost, total, created_by, created_at)
VALUES ('ORD-2024-002', 2, 'processing', 999.99, 159.99, 15.00, 1174.98, 3, NOW() - INTERVAL '2 days');

INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(2, 3, 1, 999.99, 999.99);   -- iPhone

INSERT INTO orders (order_number, customer_id, status, subtotal, tax, shipping_cost, total, created_by, created_at)
VALUES ('ORD-2024-003', 3, 'pending', 135.00, 21.60, 5.00, 161.60, 4, NOW() - INTERVAL '1 hour');

INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(3, 8, 1, 55.00, 55.00),     -- Vestido
(3, 10, 2, 40.00, 80.00);    -- Sábanas x2

UPDATE customers SET total_spent = 1767.40, order_count = 1 WHERE id = 1;
UPDATE customers SET total_spent = 1174.98, order_count = 1 WHERE id = 2;
UPDATE customers SET total_spent = 161.60, order_count = 1 WHERE id = 3;

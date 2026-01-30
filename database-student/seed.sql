-- =====================================================
-- DATOS DE PRUEBA - E-COMMERCE EXAM
-- =====================================================
-- INSTRUCCIONES:
-- 1. Inserta datos de prueba para validar tu sistema
-- 2. Asegúrate de seguir el orden correcto (respetando FKs)
-- 3. Los datos deben ser realistas y variados
-- =====================================================


-- LIMPIAR DATOS POR SI ACASO
TRUNCATE TABLE order_items CASCADE;
TRUNCATE TABLE orders CASCADE;
TRUNCATE TABLE customers CASCADE;
TRUNCATE TABLE products CASCADE;
TRUNCATE TABLE categories CASCADE;
TRUNCATE TABLE users CASCADE;

-- 1. INSERTAR USUARIOS
INSERT INTO users (id, username, email, password_hash, full_name, role) VALUES
(1, 'admin', 'admin@ecommerce.com','$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ','Administrador General', 'admin'),
(2, 'manager', 'manager@ecommerce.com','$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ','Gerente Rodrigo Vera', 'manager'),
(3, 'employee1', 'employee1@ecommerce.com','$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ','Empleado Jhofre Lino', 'employee'),
(4, 'employee2', 'employee2@ecommerce.com','$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ','Empleado Amy Cevallos', 'employee');

-- 2. INSERTAR CATEGORÍAS
-- Categorías principales
INSERT INTO categories (id, name, description, parent_id) VALUES
(1, 'Tecnología', 'Productos electrónicos', NULL),
(2, 'Ropa', 'Moda para hombres y mujeres', NULL),
(3, 'Hogar', 'Artículos para el hogar', NULL),
(4, 'Deportes', 'Productos deportivos', NULL),
-- Subcategorías
(5, 'Laptops', 'Computadoras portátiles', 1),
(6, 'Celulares', 'Smartphones', 1),
(7, 'Audio', 'Audífonos y parlantes', 1),
(8, 'Ropa Hombre', 'Moda masculina', 2),
(9, 'Ropa Mujer', 'Moda femenina', 2),
(10, 'Cocina', 'Electrodomésticos', 3),
(11, 'Muebles', 'Muebles del hogar', 3);

-- 3. PRODUCTS
-- 15 productos variados
INSERT INTO products
(id, name, sku, category_id, price, cost, stock_quantity, description) VALUES
-- Laptops
(1, 'Laptop Pro X', 'LAP-001', 5, 1200.00, 800.00, 10, 'Laptop profesional'),
(2, 'Laptop Air', 'LAP-002', 5, 999.99, 700.00, 8, 'Laptop liviana'),
(3, 'Laptop Gamer', 'LAP-003', 5, 2500.00, 1800.00, 5, 'Laptop gaming'),
-- Smartphones
(4, 'iPhone 14', 'PHN-001', 6, 999.99, 700.00, 15, 'Apple smartphone'),
(5, 'Samsung S23', 'PHN-002', 6, 899.99, 650.00, 20, 'Samsung smartphone'),
(6, 'Android Pro', 'PHN-003', 6, 750.00, 500.00, 25, 'Android gama alta'),
-- Audio
(7, 'Audífonos Pro', 'AUD-001', 7, 250.00, 120.00, 30, 'Cancelación de ruido'),
(8, 'Parlante Bluetooth', 'AUD-002', 7, 120.00, 60.00, 40, 'Resistente al agua'),
-- Ropa Hombre
(9, 'Camiseta Hombre', 'ROP-001', 8, 25.00, 10.00, 100, 'Algodón'),
(10, 'Jeans Hombre', 'ROP-002', 8, 60.00, 25.00, 50, 'Slim fit'),
-- Ropa Mujer
(11, 'Vestido Mujer', 'ROP-003', 9, 45.00, 20.00, 40, 'Vestido elegante'),
-- Cocina
(12, 'Licuadora', 'HOG-001', 10, 85.00, 40.00, 20, '600W'),
(13, 'Cafetera', 'HOG-002', 10, 95.00, 50.00, 15, 'Café rápido'),
-- Muebles
(14, 'Silla Oficina', 'HOG-003', 11, 180.00, 120.00, 10, 'Ergonómica'),
-- Deportes
(15, 'Balón Fútbol', 'DEP-001', 4, 30.00, 10.00, 60, 'Tamaño oficial');

-- 4. INSERTAR CLIENTES 
INSERT INTO customers(id, first_name, last_name, email, phone, city, country) VALUES
(1, 'Carlos', 'Gómez', 'carlos@mail.com', '0991111111', 'Quito', 'Ecuador'),
(2, 'María', 'Pérez', 'maria@mail.com', '0992222222', 'Guayaquil', 'Ecuador'),
(3, 'Juan', 'Torres', 'juan@mail.com', '0993333333', 'Cuenca', 'Ecuador'),
(4, 'Ana', 'López', 'ana@mail.com', '0994444444', 'Ambato', 'Ecuador'),
(5, 'Pedro', 'Ruiz', 'pedro@mail.com', '0995555555', 'Manta', 'Ecuador'),
(6, 'Luis', 'Martínez', 'luis@mail.com', '+57-311-4567890', 'Bogotá', 'Colombia'),
(7, 'Sofía', 'Ramírez', 'sofia@mail.com', '+51-987-654321', 'Lima', 'Perú'),
(8, 'Andrés', 'Gómez', 'andres@mail.com', '+52-55-1234-5678', 'Ciudad de México', 'México'),
(9, 'Valentina', 'Rojas', 'valentina@mail.com', '+56-9-8765-4321', 'Santiago', 'Chile'),
(10, 'Diego', 'Fernández', 'diego@mail.com', '+54-11-2345-6789', 'Buenos Aires', 'Argentina');

-- 5. INSERTAR PEDIDOS
INSERT INTO orders (id, customer_id, order_number, status, subtotal, tax, total) VALUES
(1, 1, 'ORD-001', 'paid', 1200.00, 144.00, 1344.00),
(2, 2, 'ORD-002', 'pending', 899.99, 108.00, 1007.99),
(3, 3, 'ORD-003', 'shipped', 250.00, 30.00, 280.00),
(4, 4, 'ORD-004', 'cancelled', 45.00, 5.40, 50.40),
(5, 5, 'ORD-005', 'paid', 180.00, 21.60, 201.60);

-- 6. INSERTAR ITEMS DE PEDIDOS
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
-- Pedido 1 (Cliente Carlos Gómez)
(1, 1, 1, 1200.00, 1200.00), -- Laptop Pro X
(1, 7, 2, 250.00, 500.00), -- Samsung S23
-- Pedido 2 (Cliente María Pérez)
(2, 5, 1, 899.99, 899.99), -- Samsung S23
(2, 9, 2, 25.00, 50.00), -- Camiseta Hombre
-- Pedido 3 (Cliente  Juan Torres)
(3, 7, 1, 250.00, 250.00), -- Audífonos Pro
(3, 15, 1, 30.00, 30.00), -- Balón Fútbol 
-- Pedido 4 (Cliente Ana López)
(4, 11, 1, 45.00, 45.00), -- Vestido Mujer
-- Pedido 5 (Cliente Pedro Ruiz)
(5, 14, 1, 180.00, 180.00), -- Silla de Oficina
(5, 12, 1, 85.00, 85.00); --  Licuadora

-- Actualizar las secuencias para que no fallen
SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));
SELECT setval('categories_id_seq', (SELECT MAX(id) FROM categories));
SELECT setval('products_id_seq', (SELECT MAX(id) FROM products));
SELECT setval('customers_id_seq', (SELECT MAX(id) FROM customers));
SELECT setval('orders_id_seq', (SELECT MAX(id) FROM orders));
SELECT setval('order_items_id_seq', (SELECT MAX(id) FROM order_items));

-- Recuerda:
-- - Usar comillas simples para strings
-- - Separar valores con comas
-- - Terminar statements con punto y coma
-- - Puedes insertar múltiples registros en un solo INSERT
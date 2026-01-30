-- Limpiar datos previos (en orden inverso a las dependencias)
TRUNCATE TABLE order_items CASCADE;
TRUNCATE TABLE orders CASCADE;
TRUNCATE TABLE customers CASCADE;
TRUNCATE TABLE products CASCADE;
TRUNCATE TABLE categories CASCADE;
TRUNCATE TABLE users CASCADE;

-- 1. INSERTAR USUARIOS
-- Hash de password obligatorio: $2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ
INSERT INTO users (id, username, email, password_hash, full_name, role) VALUES
(1, 'admin', 'admin@ecommerce.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Super Administrador', 'admin'),
(2, 'manager_ventas', 'manager@ecommerce.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Roberto Gerente', 'manager'),
(3, 'empleado_juan', 'juan@ecommerce.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Juan Pérez', 'employee'),
(4, 'empleado_ana', 'ana@ecommerce.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Ana López', 'employee');

-- 2. INSERTAR CATEGORÍAS
-- Primero padres (ID 1-4), luego hijos
INSERT INTO categories (id, name, description, parent_id) VALUES
(1, 'Tecnología', 'Dispositivos electrónicos y gadgets', NULL),
(2, 'Ropa', 'Moda para hombres y mujeres', NULL),
(3, 'Hogar', 'Muebles y decoración', NULL),
(4, 'Deportes', 'Equipamiento deportivo', NULL),
(5, 'Laptops', 'Computadoras portátiles', 1),
(6, 'Smartphones', 'Teléfonos inteligentes', 1),
(7, 'Audio', 'Audífonos y parlantes', 1),
(8, 'Hombre', 'Ropa para caballeros', 2),
(9, 'Mujer', 'Ropa para damas', 2),
(10, 'Cocina', 'Electrodomésticos de cocina', 3),
(11, 'Muebles', 'Sofás, sillas y mesas', 3),
(12, 'Futbol', 'Balones y accesorios', 4),
(13, 'Gimnasio', 'Pesas y máquinas', 4);

-- 3. INSERTAR PRODUCTOS
-- 20 productos variados
INSERT INTO products (id, name, sku, category_id, price, cost, stock_quantity, description) VALUES
-- Laptops
(1, 'Laptop Pro X1', 'LAP-001', 5, 1200.00, 800.00, 15, 'Laptop potente para trabajo'),
(2, 'Laptop Air Slim', 'LAP-002', 5, 999.99, 700.00, 8, 'Laptop ultradelgada'),
(3, 'Gaming Beast', 'LAP-003', 5, 2500.00, 1800.00, 5, 'Laptop para juegos'),
-- Smartphones
(4, 'Phone X 128GB', 'PHN-001', 6, 800.00, 500.00, 20, 'Smartphone última generación'),
(5, 'Phone X Pro', 'PHN-002', 6, 1100.00, 750.00, 12, 'Versión profesional con mejor cámara'),
(6, 'Android Galaxy', 'PHN-003', 6, 750.00, 450.00, 25, 'Teléfono Android balanceado'),
-- Audio
(7, 'Audífonos NoiseCancel', 'AUD-001', 7, 250.00, 100.00, 50, 'Cancelación de ruido activa'),
(8, 'Parlante Bluetooth', 'AUD-002', 7, 120.00, 60.00, 30, 'Resistente al agua'),
-- Ropa Hombre
(9, 'Camiseta Básica', 'CLO-M-001', 8, 25.00, 10.00, 100, 'Algodón 100%'),
(10, 'Jeans Slim Fit', 'CLO-M-002', 8, 60.00, 25.00, 40, 'Mezclilla resistente'),
(11, 'Chaqueta Cuero', 'CLO-M-003', 8, 150.00, 80.00, 15, 'Cuero genuino'),
-- Ropa Mujer
(12, 'Vestido Verano', 'CLO-W-001', 9, 45.00, 20.00, 35, 'Floral y ligero'),
(13, 'Blusa Ejecutiva', 'CLO-W-002', 9, 35.00, 15.00, 45, 'Ideal para oficina'),
-- Cocina
(14, 'Cafetera Automática', 'HOM-K-001', 10, 85.00, 40.00, 20, 'Prepara café en minutos'),
(15, 'Licuadora Potente', 'HOM-K-002', 10, 60.00, 30.00, 25, 'Tritura hielo fácilmente'),
-- Muebles
(16, 'Silla Ergonómica', 'HOM-F-001', 11, 200.00, 120.00, 10, 'Cuida tu espalda'),
(17, 'Escritorio Madera', 'HOM-F-002', 11, 150.00, 90.00, 8, 'Madera de roble'),
-- Deportes
(18, 'Balón Oficial', 'SPT-S-001', 12, 30.00, 10.00, 60, 'Tamaño estándar'),
(19, 'Set de Pesas', 'SPT-G-001', 13, 90.00, 50.00, 15, 'Ajustables de 5 a 20kg'),
(20, 'Tapete Yoga', 'SPT-G-002', 13, 20.00, 8.00, 50, 'Antideslizante');

-- 4. INSERTAR CLIENTES
INSERT INTO customers (id, first_name, last_name, email, phone, address, city, country, postal_code, total_spent, order_count) VALUES
(1, 'Carlos', 'Gómez', 'carlos@mail.com', '555-0101', 'Av. Reforma 123', 'Ciudad de México', 'México', '06500', 3700.00, 2),
(2, 'Laura', 'Sánchez', 'laura@mail.com', '555-0102', 'Calle 50 #10', 'Bogotá', 'Colombia', '110111', 1200.00, 1),
(3, 'Pedro', 'Ramírez', 'pedro@mail.com', '555-0103', 'Av. Corrientes 400', 'Buenos Aires', 'Argentina', 'C1043', 250.00, 1),
(4, 'Sofía', 'Martínez', 'sofia@mail.com', '555-0104', 'Gran Vía 20', 'Madrid', 'España', '28013', 0.00, 0),
(5, 'Miguel', 'Torres', 'miguel@mail.com', '555-0105', 'Calle 80', 'Lima', 'Perú', '15001', 999.99, 1),
(6, 'Lucía', 'Fernández', 'lucia@mail.com', '555-0106', 'Providencia 100', 'Santiago', 'Chile', '7500000', 85.00, 1),
(7, 'Andrés', 'Castro', 'andres@mail.com', '555-0107', 'El Poblado', 'Medellín', 'Colombia', '050021', 0.00, 0),
(8, 'Elena', 'Ruiz', 'elena@mail.com', '555-0108', 'Quito Norte', 'Quito', 'Ecuador', '170102', 300.00, 1),
(9, 'David', 'Vargas', 'david@mail.com', '555-0109', 'Zona 10', 'Guatemala', 'Guatemala', '01010', 0.00, 0),
(10, 'Carmen', 'López', 'carmen@mail.com', '555-0110', 'Miraflores', 'Panamá', 'Panamá', '0801', 0.00, 0);

-- 5. INSERTAR PEDIDOS (Orders)
-- 8 Pedidos variados
INSERT INTO orders (id, customer_id, order_number, status, subtotal, tax, shipping_cost, total, shipping_address, shipping_city, shipping_country) VALUES
(1, 1, 'ORD-001', 'delivered', 2500.00, 400.00, 50.00, 2950.00, 'Av. Reforma 123', 'Ciudad de México', 'México'),
(2, 1, 'ORD-002', 'processing', 750.00, 120.00, 20.00, 890.00, 'Av. Reforma 123', 'Ciudad de México', 'México'),
(3, 2, 'ORD-003', 'shipped', 1200.00, 192.00, 30.00, 1422.00, 'Calle 50 #10', 'Bogotá', 'Colombia'),
(4, 3, 'ORD-004', 'delivered', 250.00, 40.00, 15.00, 305.00, 'Av. Corrientes 400', 'Buenos Aires', 'Argentina'),
(5, 5, 'ORD-005', 'pending', 999.99, 160.00, 25.00, 1184.99, 'Calle 80', 'Lima', 'Perú'),
(6, 6, 'ORD-006', 'cancelled', 85.00, 13.60, 10.00, 108.60, 'Providencia 100', 'Santiago', 'Chile'),
(7, 8, 'ORD-007', 'delivered', 300.00, 48.00, 20.00, 368.00, 'Quito Norte', 'Quito', 'Ecuador'),
(8, 1, 'ORD-008', 'pending', 60.00, 9.60, 10.00, 79.60, 'Av. Reforma 123', 'Ciudad de México', 'México');

-- 6. INSERTAR ITEMS DE PEDIDOS
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
-- Orden 1 (Carlos - Laptop Gamer)
(1, 3, 1, 2500.00, 2500.00),
-- Orden 2 (Carlos - Celular Android)
(2, 6, 1, 750.00, 750.00),
-- Orden 3 (Laura - Laptop Pro)
(3, 1, 1, 1200.00, 1200.00),
-- Orden 4 (Pedro - Audífonos)
(4, 7, 1, 250.00, 250.00),
-- Orden 5 (Miguel - Laptop Slim)
(5, 2, 1, 999.99, 999.99),
-- Orden 6 (Lucía - Cafetera)
(6, 14, 1, 85.00, 85.00),
-- Orden 7 (Elena - 2 Sillas)
(7, 17, 2, 150.00, 300.00),
-- Orden 8 (Carlos - Jeans)
(8, 10, 1, 60.00, 60.00);

-- Actualizar las secuencias para que los próximos INSERTs automáticos no fallen
SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));
SELECT setval('categories_id_seq', (SELECT MAX(id) FROM categories));
SELECT setval('products_id_seq', (SELECT MAX(id) FROM products));
SELECT setval('customers_id_seq', (SELECT MAX(id) FROM customers));
SELECT setval('orders_id_seq', (SELECT MAX(id) FROM orders));
SELECT setval('order_items_id_seq', (SELECT MAX(id) FROM order_items));
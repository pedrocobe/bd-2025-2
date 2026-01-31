-- DATOS DE PRUEBA - E-COMMERCE EXAM

-- 1. USERS
INSERT INTO users (username, email, password_hash, full_name, role)
VALUES
('admin', 'admin@mail.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Administrador General', 'admin'),
('manager1', 'manager1@mail.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Gerente Principal', 'employee'),
('employee1', 'emp1@mail.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Empleado Uno', 'employee'),
('employee2', 'emp2@mail.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Empleado Dos', 'employee');

-- 2. CATEGORIES (15 con jerarquía lógica)
INSERT INTO categories (name, description)
VALUES
('Electrónica', 'Productos electrónicos'),
('Computadoras', 'Computadoras y laptops'),
('Accesorios', 'Accesorios electrónicos'),
('Celulares', 'Teléfonos móviles'),
('Ropa', 'Ropa en general'),
('Ropa Hombre', 'Ropa para hombre'),
('Ropa Mujer', 'Ropa para mujer'),
('Hogar', 'Productos para el hogar'),
('Muebles', 'Muebles del hogar'),
('Cocina', 'Artículos de cocina'),
('Libros', 'Libros en general'),
('Educación', 'Libros educativos'),
('Tecnología', 'Libros de tecnología'),
('Deportes', 'Artículos deportivos'),
('Salud', 'Productos de salud');

-- 3. PRODUCTS (25 productos)
INSERT INTO products (name, description, price, stock_quantity, category_id)
VALUES
('Laptop Lenovo', 'Laptop 16GB RAM', 1200.00, 10, 2),
('Laptop HP', 'Laptop 8GB RAM', 900.00, 12, 2),
('Mouse Inalámbrico', 'Mouse USB', 20.00, 100, 3),
('Teclado Mecánico', 'Teclado RGB', 60.00, 40, 3),
('iPhone', 'iPhone 13', 1100.00, 8, 4),
('Samsung Galaxy', 'Galaxy S22', 950.00, 9, 4),
('Camiseta Hombre', 'Camiseta talla M', 15.00, 80, 6),
('Pantalón Hombre', 'Jean azul', 35.00, 60, 6),
('Vestido Mujer', 'Vestido rojo', 45.00, 40, 7),
('Blusa Mujer', 'Blusa blanca', 25.00, 50, 7),
('Silla Oficina', 'Silla ergonómica', 150.00, 20, 9),
('Mesa Madera', 'Mesa comedor', 300.00, 10, 9),
('Olla', 'Olla de acero', 40.00, 35, 10),
('Sartén', 'Sartén antiadherente', 30.00, 45, 10),
('Libro SQL', 'Aprende SQL', 40.00, 30, 13),
('Libro Java', 'Java desde cero', 45.00, 25, 13),
('Libro Redes', 'Fundamentos de redes', 50.00, 20, 13),
('Balón Fútbol', 'Balón profesional', 35.00, 25, 14),
('Raqueta', 'Raqueta tenis', 80.00, 15, 14),
('Proteína', 'Proteína en polvo', 60.00, 18, 15),
('Vitaminas', 'Multivitamínico', 25.00, 40, 15),
('Monitor', 'Monitor 24 pulgadas', 200.00, 22, 1),
('Audífonos', 'Audífonos Bluetooth', 55.00, 50, 1),
('Tablet', 'Tablet Android', 300.00, 14, 1),
('Impresora', 'Impresora láser', 180.00, 11, 1);

-- 4. CUSTOMERS (10 clientes)
INSERT INTO customers (full_name, email, phone, address)
VALUES
('Juan Pérez', 'juan@mail.com', '0991111111', 'Guayaquil'),
('María López', 'maria@mail.com', '0992222222', 'Quito'),
('Carlos Gómez', 'carlos@mail.com', '0993333333', 'Cuenca'),
('Ana Torres', 'ana@mail.com', '0994444444', 'Manta'),
('Luis Díaz', 'luis@mail.com', '0995555555', 'Ambato'),
('Sofía Herrera', 'sofia@mail.com', '0996666666', 'Loja'),
('Pedro Mora', 'pedro@mail.com', '0997777777', 'Machala'),
('Laura Ruiz', 'laura@mail.com', '0998888888', 'Esmeraldas'),
('Diego Castro', 'diego@mail.com', '0999999999', 'Ibarra'),
('Valeria Peña', 'valeria@mail.com', '0980000000', 'Riobamba');

-- 5. ORDERS (8 pedidos, distintos estados)
INSERT INTO orders (customer_id, user_id, status, total)
VALUES
(1, 2, 'paid', 1220.00),
(2, 3, 'pending', 75.00),
(3, 4, 'shipped', 300.00),
(4, 2, 'cancelled', 45.00),
(5, 3, 'paid', 180.00),
(6, 4, 'paid', 95.00),
(7, 2, 'pending', 60.00),
(8, 3, 'shipped', 410.00);

-- 6. ORDER ITEMS (múltiples por pedido)
INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES
(1, 1, 1, 1200.00),
(1, 3, 1, 20.00),

(2, 7, 5, 15.00),

(3, 12, 1, 300.00),

(4, 10, 1, 45.00),

(5, 11, 1, 150.00),
(5, 3, 1, 30.00),

(6, 14, 2, 30.00),
(6, 21, 1, 35.00),

(7, 18, 1, 60.00),

(8, 2, 1, 900.00),
(8, 23, 1, 55.00);

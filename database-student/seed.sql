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

-- 1. USUARIOS (Staff)
INSERT INTO users (username, email, password_hash, full_name, role) VALUES
('admin_juan', 'juan.admin@tienda.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Juan Pérez', 'admin'),
('manager_ana', 'ana.manager@tienda.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Ana Martínez', 'manager'),
('emp_carlos', 'carlos.venta@tienda.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Carlos Ruiz', 'employee'),
('emp_maria', 'maria.bodega@tienda.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'María López', 'employee');

-- 2. CATEGORÍAS (Jerárquicas)
INSERT INTO categories (name, description, parent_id) VALUES
('Tecnología', 'Dispositivos electrónicos y gadgets', NULL),    -- ID 1
('Ropa', 'Vestimenta para todas las edades', NULL),             -- ID 2
('Hogar', 'Artículos para casa y decoración', NULL);           -- ID 3

-- Subcategorías
INSERT INTO categories (name, description, parent_id) VALUES
('Laptops', 'Computadoras portátiles', 1),                     -- ID 4
('Celulares', 'Smartphones y accesorios', 1),                  -- ID 5
('Calzado', 'Zapatos y zapatillas', 2),                        -- ID 6
('Camisetas', 'Camisetas de algodón y deportivas', 2),         -- ID 7
('Cocina', 'Utensilios y electrodomésticos de cocina', 3),     -- ID 8
('Muebles', 'Sofás, mesas y sillas', 3),                       -- ID 9
('Gaming', 'Consolas y accesorios de juego', 1);  

-- 3. PRODUCTOS
INSERT INTO products (category_id, name, description, price, stock, sku) VALUES
(4, 'MacBook Air M2', 'Laptop Apple 13 pulgadas', 1200.00, 15, 'LAP-MAC-001'),
(4, 'Dell XPS 13', 'Laptop potente Windows', 1100.00, 10, 'LAP-DEL-002'),
(5, 'iPhone 15', 'Smartphone Apple 128GB', 950.00, 25, 'CEL-IPH-003'),
(5, 'Samsung S23', 'Smartphone Android 256GB', 850.00, 20, 'CEL-SAM-004'),
(6, 'Nike Air Max', 'Zapatillas deportivas', 120.00, 40, 'CAL-NIK-005'),
(6, 'Adidas Ultraboost', 'Zapatillas para correr', 130.00, 35, 'CAL-ADI-006'),
(7, 'Camiseta Básica', '100% Algodón blanca', 15.00, 100, 'ROA-CAM-007'),
(8, 'Air Fryer Ninja', 'Freidora de aire 4qt', 150.00, 12, 'HOG-NIN-008'),
(9, 'Silla Gamer', 'Ergonómica con soporte lumbar', 250.00, 8, 'MUE-GAM-009'),
(10, 'PS5 Console', 'Consola Sony Disco', 550.00, 5, 'GAM-PS5-010'),
(10, 'Mando DualSense', 'Control inalámbrico PS5', 75.00, 30, 'GAM-CTLR-011'),
(8, 'Cafetera Espresso', 'Máquina de café italiana', 200.00, 10, 'HOG-CAF-012');


-- 4. CLIENTES
INSERT INTO customers (first_name, last_name, email, phone, address) VALUES
('Roberto', 'Gómez', 'roberto@email.com', '0987654321', 'Quito, Av. Amazonas'),
('Lucía', 'Fernández', 'lucia@email.com', '0912345678', 'Guayaquil, Urdesa'),
('Andrés', 'Castro', 'andres@email.com', '0998877665', 'Cuenca, Centro Histórico'),
('Elena', 'Torres', 'elena@email.com', '0922334455', 'Manta, El Murciélago'),
('Diego', 'Vaca', 'diego@email.com', '0933445566', 'Ambato, Ficoa'),
('Carmen', 'Mejía', 'carmen@email.com', '0944556677', 'Loja, San Sebastián'),
('Pablo', 'Sosa', 'pablo@email.com', '0955667788', 'Ibarra, Av. Atahualpa'),
('Sofía', 'Paz', 'sofia@email.com', '0966778899', 'Riobamba, Maldonado'),
('Javier', 'Luna', 'javier@email.com', '0977889900', 'Portoviejo, Av. Manabí'),
('Marta', 'Ríos', 'marta@email.com', '0988990011', 'Esmeraldas, Las Palmas');


-- 5. PEDIDOS (Orders)
INSERT INTO orders (customer_id, user_id, status, total_amount) VALUES
(1, 3, 'delivered', 1320.00), -- Pedido de Roberto procesado por Carlos
(2, 3, 'paid', 950.00),     -- Pedido de Lucía
(3, 4, 'pending', 250.00),  -- Pedido de Andrés procesado por María
(4, 3, 'shipped', 625.00),   -- Pedido de Elena
(5, 4, 'cancelled', 0.00),   -- Pedido cancelado
(6, 3, 'delivered', 150.00),
(1, 3, 'paid', 2200.00),
(7, 4, 'pending', 120.00);

-- 6. DETALLES DE PEDIDO (Order Items)
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1200.00), -- 1 MacBook
(1, 5, 1, 120.00),  -- 1 Nike
(2, 3, 1, 950.00),  -- 1 iPhone
(3, 9, 1, 250.00),  -- 1 Silla
(4, 10, 1, 550.00), -- 1 PS5
(4, 11, 1, 75.00),  -- 1 Mando
(6, 8, 1, 150.00),  -- 1 Air Fryer
(7, 1, 1, 1200.00),
(7, 3, 1, 950.00),
(7, 11, 1, 50.00);             -- ID 10
-- Recuerda:
-- - Usar comillas simples para strings
-- - Separar valores con comas
-- - Terminar statements con punto y coma
-- - Puedes insertar múltiples registros en un solo INSERT

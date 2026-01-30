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

-- Recuerda:
-- - Usar comillas simples para strings
-- - Separar valores con comas
-- - Terminar statements con punto y coma
-- - Puedes insertar múltiples registros en un solo INSERT


-- =====================================================
-- 1) USERS
-- =====================================================
INSERT INTO users (id, username, email, password_hash, full_name, role, is_active, created_at, last_login)
VALUES
		(1, 'admin', 'admin@ecommerce.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Administrador del Sistema', 'admin'::user_role, TRUE, CURRENT_TIMESTAMP - INTERVAL '20 days', CURRENT_TIMESTAMP - INTERVAL '1 day'),
		(2, 'manager', 'manager@ecommerce.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'María García Gerente', 'manager'::user_role, TRUE, CURRENT_TIMESTAMP - INTERVAL '18 days', CURRENT_TIMESTAMP - INTERVAL '2 days'),
		(3, 'employee1', 'employee1@ecommerce.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Juan Pérez Empleado', 'employee'::user_role, TRUE, CURRENT_TIMESTAMP - INTERVAL '16 days', CURRENT_TIMESTAMP - INTERVAL '3 days'),
		(4, 'employee2', 'employee2@ecommerce.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Ana López Empleada', 'employee'::user_role, TRUE, CURRENT_TIMESTAMP - INTERVAL '14 days', CURRENT_TIMESTAMP - INTERVAL '4 days')
ON CONFLICT DO NOTHING;

-- Variante: insertar usuarios usando CTE con VALUES
WITH users_data (id, username, email, password_hash, full_name, role, is_active, created_at, last_login) AS (
	VALUES
		(6, 'aux1', 'aux1@ecom.com', '$2b$10$abc...', 'Auxiliar Uno', 'employee'::user_role, TRUE, CURRENT_TIMESTAMP - INTERVAL '2 days', CURRENT_TIMESTAMP - INTERVAL '1 hour'),
		(7, 'aux2', 'aux2@ecom.com', '$2b$10$abc...', 'Auxiliar Dos', 'employee'::user_role, TRUE, CURRENT_TIMESTAMP - INTERVAL '3 days', CURRENT_TIMESTAMP - INTERVAL '2 hours')
)
INSERT INTO users (id, username, email, password_hash, full_name, role, is_active, created_at, last_login)
SELECT id, username, email, password_hash, full_name, role, is_active, created_at, last_login FROM users_data
ON CONFLICT DO NOTHING;


-- =====================================================
-- 2) CATEGORIES (con jerarquía)
-- =====================================================
INSERT INTO categories (id, name, description, parent_id, is_active)
VALUES
	(1,  'Tecnología', 'Dispositivos y gadgets modernos', NULL, TRUE),
	(2,  'Moda', 'Indumentaria y accesorios', NULL, TRUE),
	(3,  'Hogar & Deco', 'Decoración y muebles', NULL, TRUE),
	(4,  'Outdoor', 'Actividades al aire libre', NULL, TRUE),
	(5,  'Editorial', 'Libros y revistas', NULL, TRUE),
	(6,  'Notebooks', 'Portátiles y accesorios', 1, TRUE),
	(7,  'Smartphones', 'Teléfonos inteligentes', 1, TRUE),
	(8,  'Audio Pro', 'Equipo de audio profesional', 1, TRUE),
	(9,  'Accesorios Moda', 'Joyas y complementos', 2, TRUE),
	(10, 'Cocina Pro', 'Electrodomésticos de cocina', 3, TRUE),
	(11, 'Entrenamiento', 'Máquinas y accesorios fitness', 4, TRUE),
	(12, 'Novelas', 'Ficción y narrativa', 5, TRUE)
ON CONFLICT DO NOTHING;


-- =====================================================
-- 3) PRODUCTS
-- =====================================================
INSERT INTO products (id, name, description, sku, category_id, price, cost, stock_quantity, min_stock_level, is_active, created_by, created_at)
VALUES
	(1,  'Notebook Nova', 'Notebook ligera para oficina', 'NOVA-NB-001', 6, 1099.99, 700.00, 40, 5, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '11 days'),
	(2,  'UltraBook S', 'Ultrabook S Serie', 'UB-S-002', 6, 1699.99, 1150.00, 4, 3, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '10 days'),
	(3,  'Phone Zenith', 'Teléfono con cámara avanzada', 'ZEN-PH-003', 7, 999.99, 650.00, 50, 5, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '9 days'),
	(4,  'Orbit X', 'Smartphone compacto Orbit X', 'ORB-X-004', 7, 679.99, 480.00, 70, 8, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '9 days'),
	(5,  'Cascos Studio', 'Audífonos para estudio', 'STU-AUD-005', 8, 229.99, 140.00, 60, 10, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '8 days'),
	(6,  'Speaker Wave', 'Bocina portátil Wave', 'WAVE-SPK-006', 8, 139.99, 75.00, 80, 10, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '8 days'),
	(7,  'Mechanical TKL', 'Teclado mecánico tenkeyless', 'TKL-KB-007', 6, 99.99, 50.00, 65, 10, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '7 days'),
	(8,  'Ergo Mouse', 'Mouse vertical ergonómico', 'ERG-MSE-008', 6, 44.99, 20.00, 120, 20, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '7 days'),
	(9,  'View 27 Pro', 'Monitor 27" 4K', 'V27P-009', 6, 329.99, 200.00, 7, 5, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '7 days'),
	(10, 'FastCharge 65', 'Cargador USB-C 65W', 'FC-65-010', 7, 34.99, 13.00, 180, 30, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '6 days'),
	(11, 'Armor Case', 'Funda protectora rugged', 'ARM-CASE-011', 7, 22.99, 8.00, 230, 40, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '6 days'),
	(12, 'Pro Noise Cancelling', 'Auriculares con ANC Pro', 'PNC-012', 8, 379.99, 250.00, 30, 5, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '6 days'),
	(13, 'Tech Tee', 'Camiseta técnica transpirable', 'TTEE-013', 2, 26.99, 10.00, 110, 20, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '6 days'),
	(14, 'Denim Flex', 'Jeans stretch moderno', 'DF-JEANS-014', 2, 54.99, 24.00, 70, 15, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '6 days'),
	(15, 'Baseball Pro', 'Gorra deportiva', 'BP-CAP-015', 9, 16.99, 6.00, 90, 20, TRUE, 4, CURRENT_TIMESTAMP - INTERVAL '5 days'),
	(16, 'Run X', 'Zapatillas running de alto rendimiento', 'RUNX-016', 4, 119.99, 60.00, 50, 10, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '5 days'),
	(17, 'Weights 10Kg', 'Mancuernas 10kg pack', 'W10-017', 11, 64.99, 35.00, 30, 8, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '5 days'),
	(18, 'Yoga Pro Mat', 'Mat premium antideslizante', 'YPM-018', 11, 29.99, 10.00, 80, 20, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '5 days'),
	(19, 'Sartén Pro X', 'Sartén profesional 28cm', 'SPX-019', 10, 49.99, 20.00, 60, 10, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '4 days'),
	(20, 'Chef Set', 'Juego de cuchillos Chef', 'CHS-020', 10, 59.99, 25.00, 35, 8, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '4 days'),
	(21, 'Brew Master', 'Cafetera semi automática', 'BM-021', 10, 129.99, 80.00, 15, 5, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '4 days'),
	(22, 'SQL Guide', 'Manual práctico SQL', 'SQL-022', 5, 19.99, 7.00, 130, 20, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '4 days'),
	(23, 'El Principito - Ed', 'Edición ilustrada', 'EP-023', 12, 11.99, 3.00, 150, 30, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '3 days'),
	(24, 'Code Cleanse', 'Guía Clean Code traducida', 'CC-024', 5, 31.99, 13.00, 55, 10, TRUE, 2, CURRENT_TIMESTAMP - INTERVAL '3 days'),
	(25, 'SmartBand X', 'Pulsera inteligente', 'SBX-025', 7, 129.99, 75.00, 48, 8, TRUE, 3, CURRENT_TIMESTAMP - INTERVAL '3 days')
ON CONFLICT DO NOTHING;


-- =====================================================
-- 4) CUSTOMERS
-- =====================================================
INSERT INTO customers (id, first_name, last_name, email, phone, address, city, country, postal_code, is_active, created_at)
VALUES
	(1, 'Santiago', 'González', 'santiago.gonzalez@bd3.example', '+54-9-11-5000-0001', 'Calle Florida 100', 'Buenos Aires', 'Argentina', 'C1000', TRUE, CURRENT_TIMESTAMP - INTERVAL '25 days'),
	(2, 'Martina', 'Fernández', 'martina.fernandez@bd3.example', '+54-9-11-5000-0002', 'Av. Corrientes 200', 'Buenos Aires', 'Argentina', 'C1040', TRUE, CURRENT_TIMESTAMP - INTERVAL '24 days'),
	(3, 'Matías', 'López', 'matias.lopez@bd3.example', '+54-9-11-5000-0003', 'Obelisco 1', 'Buenos Aires', 'Argentina', 'C1001', TRUE, CURRENT_TIMESTAMP - INTERVAL '23 days'),
	(4, 'Valentina', 'Martínez', 'valentina.martinez@bd3.example', '+54-9-11-5000-0004', 'Palermo 33', 'Buenos Aires', 'Argentina', 'C1414', TRUE, CURRENT_TIMESTAMP - INTERVAL '22 days'),
	(5, 'Lucas', 'Giménez', 'lucas.gimenez@bd3.example', '+54-9-11-5000-0005', 'La Boca 7', 'Buenos Aires', 'Argentina', 'C1160', TRUE, CURRENT_TIMESTAMP - INTERVAL '21 days'),
	(6, 'Sofía', 'Rodríguez', 'sofia.rodriguez@bd3.example', '+54-9-11-5000-0006', 'Recoleta 88', 'Buenos Aires', 'Argentina', 'C1126', TRUE, CURRENT_TIMESTAMP - INTERVAL '20 days'),
	(7, 'Federico', 'Alvarez', 'federico.alvarez@bd3.example', '+54-9-11-5000-0007', 'Belgrano 45', 'Buenos Aires', 'Argentina', 'C1428', TRUE, CURRENT_TIMESTAMP - INTERVAL '19 days'),
	(8, 'Julia', 'Sosa', 'julia.sosa@bd3.example', '+54-9-11-5000-0008', 'San Telmo 9', 'Buenos Aires', 'Argentina', 'C1065', TRUE, CURRENT_TIMESTAMP - INTERVAL '18 days'),
	(9, 'Diego', 'Pérez', 'diego.perez@bd3.example', '+54-9-11-5000-0009', 'Caballito 12', 'Buenos Aires', 'Argentina', 'C1414', TRUE, CURRENT_TIMESTAMP - INTERVAL '17 days'),
	(10, 'Nadia', 'Cabrera', 'nadia.cabrera@bd3.example', '+54-9-11-5000-0010', 'Puerto Madero 2', 'Buenos Aires', 'Argentina', 'C1107', TRUE, CURRENT_TIMESTAMP - INTERVAL '16 days')
ON CONFLICT DO NOTHING;

-- Estadísticas iniciales (se recalculan por función más adelante cuando USE_MOCKS=false)
UPDATE customers SET total_spent = 420.00, order_count = 2 WHERE id = 1;
UPDATE customers SET total_spent = 110.00, order_count = 1 WHERE id = 2;
UPDATE customers SET total_spent = 260.00, order_count = 1 WHERE id = 3;
UPDATE customers SET total_spent = 30.00,  order_count = 1 WHERE id = 4;
UPDATE customers SET total_spent = 0.00,   order_count = 0 WHERE id = 5;
UPDATE customers SET total_spent = 95.50,  order_count = 1 WHERE id = 6;
UPDATE customers SET total_spent = 180.75, order_count = 1 WHERE id = 7;


-- =====================================================
-- 5) ORDERS
-- =====================================================
-- Nota: order_number se genera con trigger si es NULL.
-- En seed.sql aún no existen triggers, por eso se insertan order_number y totales manualmente.
INSERT INTO orders (id, customer_id, order_number, status, subtotal, tax, shipping_cost, total, shipping_address, shipping_city, shipping_country, created_by, shipped_at, delivered_at, created_at)
VALUES
	(1, 1, 'ORD-2026-0001', 'delivered', 1609.96, 257.59, 50.00, 1917.55, 'Av. Reforma 123', 'Ciudad de México', 'México', 3, CURRENT_TIMESTAMP - INTERVAL '9 days', CURRENT_TIMESTAMP - INTERVAL '7 days', CURRENT_TIMESTAMP - INTERVAL '10 days'),
	(2, 2, 'ORD-2026-0002', 'delivered', 1039.97, 166.40, 30.00, 1236.37, 'Calle Juárez 456', 'Guadalajara', 'México', 3, CURRENT_TIMESTAMP - INTERVAL '8 days', CURRENT_TIMESTAMP - INTERVAL '6 days', CURRENT_TIMESTAMP - INTERVAL '9 days'),
	(3, 3, 'ORD-2026-0003', 'shipped', 2349.98, 376.00, 80.00, 2805.98, 'Blvd. Díaz Ordaz 789', 'Monterrey', 'México', 4, CURRENT_TIMESTAMP - INTERVAL '4 days', NULL, CURRENT_TIMESTAMP - INTERVAL '6 days'),
	(4, 1, 'ORD-2026-0004', 'processing', 1344.97, 215.20, 50.00, 1610.17, 'Av. Reforma 123', 'Ciudad de México', 'México', 4, NULL, NULL, CURRENT_TIMESTAMP - INTERVAL '4 days'),
	(5, 4, 'ORD-2026-0005', 'pending', 123.97, 19.84, 40.00, 183.81, 'Av. Universidad 100', 'Quito', 'Ecuador', 3, NULL, NULL, CURRENT_TIMESTAMP - INTERVAL '3 days'),
	(6, 5, 'ORD-2026-0006', 'cancelled', 99.97, 16.00, 20.00, 135.97, 'Calle 9 de Octubre 200', 'Guayaquil', 'Ecuador', 3, NULL, NULL, CURRENT_TIMESTAMP - INTERVAL '2 days'),
	(7, 6, 'ORD-2026-0007', 'delivered', 153.97, 24.64, 25.00, 203.61, 'Av. Los Shyris 321', 'Quito', 'Ecuador', 4, CURRENT_TIMESTAMP - INTERVAL '6 days', CURRENT_TIMESTAMP - INTERVAL '5 days', CURRENT_TIMESTAMP - INTERVAL '7 days'),
	(8, 7, 'ORD-2026-0008', 'processing', 304.97, 48.80, 45.00, 398.77, 'Calle Larga 55', 'Cuenca', 'Ecuador', 4, NULL, NULL, CURRENT_TIMESTAMP - INTERVAL '1 day')
ON CONFLICT DO NOTHING;


-- =====================================================
-- 6) ORDER_ITEMS
-- =====================================================
-- unit_price se registra al momento de la compra.
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal)
VALUES
	-- Order 1
	(1, 1, 1, 1299.99, 1299.99),
	(1, 5, 1, 249.99, 249.99),
	(1, 10, 2, 29.99, 59.98),

	-- Order 2
	(2, 4, 1, 999.99, 999.99),
	(2, 11, 2, 19.99, 39.98),

	-- Order 3
	(3, 2, 1, 1999.99, 1999.99),
	(3, 12, 1, 349.99, 349.99),

	-- Order 4
	(4, 3, 1, 1199.99, 1199.99),
	(4, 6, 1, 129.99, 129.99),
	(4, 15, 1, 14.99, 14.99),

	-- Order 5
	(5, 16, 1, 79.99, 79.99),
	(5, 18, 2, 21.99, 43.98),

	-- Order 6 (cancelled)
	(6, 13, 2, 24.99, 49.98),
	(6, 14, 1, 49.99, 49.99),

	-- Order 7
	(7, 21, 1, 99.99, 99.99),
	(7, 22, 1, 18.99, 18.99),
	(7, 19, 1, 34.99, 34.99),

	-- Order 8
	(8, 25, 1, 199.99, 199.99),
	(8, 17, 1, 59.99, 59.99),
	(8, 20, 1, 44.99, 44.99)
ON CONFLICT DO NOTHING;



-- =====================================================
-- ACTUALIZAR SECUENCIAS (importante para tests)
-- =====================================================
SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));
SELECT setval('categories_id_seq', (SELECT MAX(id) FROM categories));
SELECT setval('products_id_seq', (SELECT MAX(id) FROM products));
SELECT setval('customers_id_seq', (SELECT MAX(id) FROM customers));
SELECT setval('orders_id_seq', (SELECT MAX(id) FROM orders));
SELECT setval('order_items_id_seq', (SELECT MAX(id) FROM order_items));


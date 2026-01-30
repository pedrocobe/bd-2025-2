-- ============================================
-- DATOS DE PRUEBA - ECOMMERCE EXAM
-- ============================================

-- Limpiar datos existentes
TRUNCATE TABLE order_items, orders, product_reviews, products, categories, customers, users, audit_log RESTART IDENTITY CASCADE;

-- ==================== INSERTAR USUARIOS ====================
INSERT INTO users (username, email, password_hash, full_name, role, is_active) VALUES
('admin', 'admin@tienda.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Administrador Principal', 'admin', TRUE),
('manager1', 'manager@tienda.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Gerente de Ventas', 'manager', TRUE),
('employee1', 'empleado@tienda.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Empleado de Soporte', 'employee', TRUE),
('juan.perez', 'juan@cliente.com', '$2b$10$YQl4z5Y5Y5Y5Y5Y5Y5Y.8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJZ8xJ', 'Juan Pérez', 'employee', TRUE);

-- ==================== INSERTAR CLIENTES ====================
INSERT INTO customers (user_id, first_name, last_name, email, phone, address, city, country, total_orders, total_spent) VALUES
(4, 'Juan', 'Pérez', 'juan@cliente.com', '+57 300 123 4567', 'Calle 123 #45-67', 'Bogotá', 'Colombia', 3, 1250000.00),
(NULL, 'María', 'Gómez', 'maria@cliente.com', '+57 310 987 6543', 'Avenida Siempre Viva 742', 'Medellín', 'Colombia', 5, 2345000.00),
(NULL, 'Carlos', 'Rodríguez', 'carlos@cliente.com', '+57 320 456 7890', 'Carrera 80 #12-34', 'Cali', 'Colombia', 2, 780000.00),
(NULL, 'Ana', 'Martínez', 'ana@cliente.com', '+57 315 222 3344', 'Diagonal 25 #15-30', 'Barranquilla', 'Colombia', 1, 450000.00),
(NULL, 'Pedro', 'López', 'pedro@cliente.com', '+57 301 555 6677', 'Transversal 5 #8-20', 'Cartagena', 'Colombia', 0, 0.00);

-- ==================== INSERTAR CATEGORÍAS ====================
INSERT INTO categories (name, description, parent_id, slug, is_active) VALUES
('Electrónica', 'Dispositivos electrónicos y gadgets', NULL, 'electronica', TRUE),
('Computadores', 'Laptops, desktops y accesorios', 1, 'computadores', TRUE),
('Teléfonos', 'Smartphones y accesorios', 1, 'telefonos', TRUE),
('Audio', 'Audífonos, parlantes y sistemas de sonido', 1, 'audio', TRUE),
('Hogar', 'Productos para el hogar', NULL, 'hogar', TRUE),
('Electrodomésticos', 'Neveras, lavadoras, etc.', 5, 'electrodomesticos', TRUE),
('Muebles', 'Muebles para sala, comedor, dormitorio', 5, 'muebles', TRUE),
('Deportes', 'Equipamiento deportivo', NULL, 'deportes', TRUE),
('Fútbol', 'Balones, uniformes, zapatillas', 8, 'futbol', TRUE),
('Ciclismo', 'Bicicletas y accesorios', 8, 'ciclismo', TRUE);

-- ==================== INSERTAR PRODUCTOS ====================
INSERT INTO products (sku, name, description, price, cost, stock_quantity, reorder_level, category_id, tags) VALUES
('LAP-001', 'Laptop Gamer Xtreme', 'Laptop gaming con RTX 4070', 4500000.00, 3200000.00, 8, 3, 2, ARRAY['gaming', 'laptop']),
('LAP-002', 'Laptop Ultrabook Pro', 'Laptop ultradelgada', 3200000.00, 2400000.00, 15, 5, 2, ARRAY['ultrabook', 'profesional']),
('DESK-001', 'Desktop Workstation', 'Computador de escritorio', 3800000.00, 2800000.00, 5, 2, 2, ARRAY['desktop', 'workstation']),
('PHN-001', 'Smartphone Galaxy S24', 'Flagship Samsung', 3200000.00, 2500000.00, 12, 4, 3, ARRAY['samsung', 'android']),
('PHN-002', 'iPhone 15 Pro', 'iPhone profesional', 4500000.00, 3500000.00, 9, 3, 3, ARRAY['apple', 'iphone']),
('PHN-003', 'Smartphone Mid-Range', 'Excelente relación calidad-precio', 1200000.00, 850000.00, 25, 8, 3, ARRAY['midrange', 'value']),
('AUD-001', 'Audífonos Noise Cancelling', 'Audífonos con cancelación de ruido', 850000.00, 520000.00, 18, 6, 4, ARRAY['headphones', 'wireless']),
('AUD-002', 'Parlante Bluetooth Portátil', 'Parlante resistente al agua', 350000.00, 220000.00, 30, 10, 4, ARRAY['speaker', 'portable']),
('ELE-001', 'Nevera French Door', 'Nevera inteligente', 4200000.00, 3100000.00, 6, 2, 6, ARRAY['refrigerator', 'smart']),
('ELE-002', 'Lavadora Carga Frontal', 'Lavadora eficiente', 1800000.00, 1250000.00, 10, 4, 6, ARRAY['washer', 'front-load']),
('SPT-001', 'Balón Oficial Liga', 'Balón de fútbol profesional', 250000.00, 150000.00, 40, 15, 9, ARRAY['soccer', 'ball']),
('SPT-002', 'Zapatillas de Fútbol', 'Zapatillas con tacos moldados', 320000.00, 210000.00, 22, 8, 9, ARRAY['cleats', 'soccer']);

-- ==================== INSERTAR PEDIDOS ====================
INSERT INTO orders (order_number, customer_id, status, subtotal, tax_amount, shipping_amount, total_amount, payment_method, payment_status) VALUES
('ORD-2024-001', 1, 'delivered', 7700000.00, 1232000.00, 0.00, 8932000.00, 'credit_card', 'paid'),
('ORD-2024-002', 2, 'processing', 7950000.00, 1272000.00, 50000.00, 9272000.00, 'paypal', 'paid'),
('ORD-2024-003', 3, 'shipped', 1200000.00, 192000.00, 30000.00, 1422000.00, 'credit_card', 'paid'),
('ORD-2024-004', 4, 'pending', 350000.00, 56000.00, 20000.00, 376000.00, 'cash_on_delivery', 'pending');

-- ==================== INSERTAR ITEMS DE PEDIDO ====================
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 4500000.00),
(1, 4, 1, 3200000.00),
(2, 5, 1, 4500000.00),
(2, 7, 2, 850000.00),
(2, 10, 1, 1800000.00),
(3, 6, 1, 1200000.00),
(4, 8, 1, 350000.00);

-- ==================== VERIFICACIÓN ====================
DO $$
BEGIN
    RAISE NOTICE '✅ Datos de prueba insertados:';
    RAISE NOTICE '   - % usuarios', (SELECT COUNT(*) FROM users);
    RAISE NOTICE '   - % clientes', (SELECT COUNT(*) FROM customers);
    RAISE NOTICE '   - % categorías', (SELECT COUNT(*) FROM categories);
    RAISE NOTICE '   - % productos', (SELECT COUNT(*) FROM products);
    RAISE NOTICE '   - % pedidos', (SELECT COUNT(*) FROM orders);
    RAISE NOTICE '   - % items', (SELECT COUNT(*) FROM order_items);
END $$;
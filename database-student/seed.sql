-- Usuarios
INSERT INTO users (username, email, password_hash, full_name, is_active, role) VALUES
('admin1', 'admin1@store.com', '$2b$10$zY7y1s6eAq9H3Pq5v8R5uO1wKjF3C0nQbT9wE2xYvG1mF7aH2kL2', 'Admin One', true, 'admin'),
('customer1', 'customer1@email.com', '$2b$10$3K6h9JvTq2LzP5s8u1QeNe4mF2ZgY0xCqR7sV1bH8tW3rD5y6oPq', 'Customer One', true, 'customer'),
('customer2', 'customer2@email.com', '$2b$10$8J1kL2mN3oP4qR5sT6uV7wX8yZ9aB0cD1eF2gH3iJ4kL5mN6oPq', 'Customer Two', true, 'customer'),
('customer3', 'customer3@email.com', '$2b$10$5R8tU1vW2xY3zA4bC5dE6fG7hI8jK9lM0nO1pQ2rS3tU4vW5xYz', 'Customer Three', true, 'customer');

-- Categorías padre
INSERT INTO categories (name) VALUES
('Electronics'),
('Computers'),
('Phones'),
('Audio'),
('Accessories');

-- Subcategorias
INSERT INTO categories (name, parent_id) VALUES
('Laptops', (SELECT id FROM categories WHERE name='Computers')),
('Smartphones', (SELECT id FROM categories WHERE name='Phones')),
('Headphones', (SELECT id FROM categories WHERE name='Audio')),
('Cables', (SELECT id FROM categories WHERE name='Accessories'));

-- Productos
INSERT INTO products (sku, name, cost, price, stock_quantity, active, category_id) VALUES
('SKU001','Dell XPS 13 Laptop',1000,1299.99,10,TRUE,(SELECT id FROM categories WHERE name='Laptops')),
('SKU002','iPhone 15 Pro',900,1199.99,15,TRUE,(SELECT id FROM categories WHERE name='Smartphones')),
('SKU003','AirPods Pro',180,249.99,30,TRUE,(SELECT id FROM categories WHERE name='Headphones')),
('SKU004','USB-C Cable',5,19.99,50,TRUE,(SELECT id FROM categories WHERE name='Cables')),
('SKU005','LG 27" Monitor',220,299.99,8,TRUE,(SELECT id FROM categories WHERE name='Computers')),
('SKU006','Mechanical Keyboard',50,89.99,20,TRUE,(SELECT id FROM categories WHERE name='Accessories')),
('SKU007','Samsung Galaxy S23',750,999.99,12,TRUE,(SELECT id FROM categories WHERE name='Smartphones')),
('SKU008','Wireless Mouse',20,39.99,25,TRUE,(SELECT id FROM categories WHERE name='Accessories')),
('SKU009','Sony WH-1000XM4 Headphones',250,349.99,10,TRUE,(SELECT id FROM categories WHERE name='Headphones')),
('SKU010','30W Fast Charger',10,29.99,40,TRUE,(SELECT id FROM categories WHERE name='Cables'));

-- Clientes
INSERT INTO customers (name, email, phone) VALUES
('Xavier Rodriguez','xavier@email.com','0991234567'),
('Zayne Martinez','zayne@email.com','0997654321'),
('Harry Choi','harry@email.com','0981122334');

-- Pedidos
INSERT INTO orders (customer_id, status) VALUES
(1,'paid'), (2,'shipped'), (3,'pending');

-- Detalle
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1,(SELECT id FROM products WHERE sku='SKU001'),1,1299.99),
(1,(SELECT id FROM products WHERE sku='SKU003'),2,249.99),
(2,(SELECT id FROM products WHERE sku='SKU002'),1,1199.99);

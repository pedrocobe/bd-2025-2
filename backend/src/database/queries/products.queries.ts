export const ProductsQueries = {
  findAll: `
    SELECT p.id,
           p.name,
           p.sku,
           p.price,
           p.stock_quantity,
           p.active,
           c.name AS category_name,
           c.id AS category_id
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    ORDER BY p.created_at DESC
  `,

  findById: `
    SELECT p.id,
           p.name,
           p.sku,
           p.price,
           p.cost,
           p.stock_quantity,
           p.active,
           c.name AS category_name,
           c.id AS category_id,
           p.created_at,
           p.updated_at
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE p.id = $1
  `,

  findBySku: `
    SELECT id,
           name,
           sku,
           price,
           cost,
           stock_quantity,
           active,
           category_id
    FROM products
    WHERE sku = $1
  `,

  findByCategory: `
    SELECT id,
           name,
           sku,
           price,
           stock_quantity,
           active
    FROM products
    WHERE category_id = $1 AND active = true
    ORDER BY name ASC
  `,

  create: `
    INSERT INTO products (name, sku, price, cost, stock_quantity, active, category_id)
    VALUES ($1, $2, $3, $4, $5, true, $6)
    RETURNING id, name, sku, price, cost, stock_quantity, active, category_id, created_at, updated_at
  `,

  update: `
    UPDATE products
    SET name = $2,
        price = $3,
        cost = $4,
        stock_quantity = $5,
        active = $6,
        category_id = $7,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, name, sku, price, cost, stock_quantity, active, category_id, updated_at
  `,

  updateStock: `
    UPDATE products
    SET stock_quantity = $2,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = $1
    RETURNING id, name, sku, stock_quantity, updated_at
  `,

  delete: `
    DELETE FROM products
    WHERE id = $1
    RETURNING id
  `,

  findLowStock: `
    SELECT p.id,
           p.name,
           p.sku,
           p.stock_quantity,
           10 - p.stock_quantity AS deficit,
           c.name AS category_name
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE p.stock_quantity < 10 AND p.active = true
    ORDER BY deficit DESC
  `,

  search: `
    SELECT p.id,
           p.name,
           p.sku,
           p.price,
           p.stock_quantity,
           c.name AS category_name
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE p.name ILIKE $1 OR p.sku ILIKE $1
    ORDER BY p.name ASC
  `,

  findTopSelling: `
    SELECT p.id,
           p.name,
           p.sku,
           p.price,
           SUM(oi.quantity) AS total_sold,
           COUNT(DISTINCT o.id) AS total_orders
    FROM products p
    LEFT JOIN order_items oi ON p.id = oi.product_id
    LEFT JOIN orders o ON oi.order_id = o.id
    WHERE o.status != 'cancelled' OR o.status IS NULL
    GROUP BY p.id, p.name, p.sku, p.price
    HAVING SUM(oi.quantity) IS NOT NULL
    ORDER BY total_sold DESC
    LIMIT $1
  `,

  calculateProfitMargins: `
    SELECT id,
           name,
           price,
           cost,
           (price - cost) AS profit,
           ROUND(((price - cost) / price) * 100, 2) AS profit_margin_percent
    FROM products
    WHERE active = true AND price > 0
    ORDER BY profit_margin_percent DESC
  `,

  getInventoryValue: `
    SELECT c.name AS category_name,
           COUNT(p.id) AS total_products,
           SUM(p.stock_quantity) AS total_units,
           SUM(p.stock_quantity * p.cost) AS inventory_value
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE p.active = true
    GROUP BY c.name
    ORDER BY inventory_value DESC
  `,

  findNeverSold: `
    SELECT p.id,
           p.name,
           p.sku,
           p.price,
           p.stock_quantity,
           p.created_at
    FROM products p
    LEFT JOIN order_items oi ON p.id = oi.product_id
    WHERE oi.id IS NULL AND p.active = true
    ORDER BY p.created_at DESC
  `,

  countProducts: `
    SELECT COUNT(*) AS total
    FROM products
  `,

  countActiveProducts: `
    SELECT COUNT(*) AS active
    FROM products
    WHERE active = true
  `,

  averagePrice: `
    SELECT AVG(price) AS average_price
    FROM products
  `,

  mostExpensive: `
    SELECT id, name, price
    FROM products
    ORDER BY price DESC
    LIMIT 1
  `,

  cheapest: `
    SELECT id, name, price
    FROM products
    ORDER BY price ASC
    LIMIT 1
  `,

  stockValue: `
    SELECT SUM(stock_quantity * price) AS stock_value
    FROM products
    WHERE active = true
  `
};

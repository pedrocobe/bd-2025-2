import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../src/app.module';

describe('Products Module (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  describe('GET /products', () => {
    it('should return products with category names', () => {
      return request(app.getHttpServer())
        .get('/products')
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body)).toBe(true);
          if (res.body.length > 0) {
            expect(res.body[0]).toHaveProperty('id');
            expect(res.body[0]).toHaveProperty('name');
            expect(res.body[0]).toHaveProperty('price');
            expect(res.body[0]).toHaveProperty('category_name');
          }
        });
    });
  });

  describe('GET /products/low-stock', () => {
    it('should return products with low stock', () => {
      return request(app.getHttpServer())
        .get('/products/low-stock')
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body)).toBe(true);
          if (res.body.length > 0) {
            expect(res.body[0]).toHaveProperty('stock_quantity');
            expect(res.body[0]).toHaveProperty('min_stock_level');
            expect(res.body[0]).toHaveProperty('deficit');
            expect(res.body[0].stock_quantity).toBeLessThan(
              res.body[0].min_stock_level,
            );
          }
        });
    });
  });

  describe('GET /products/top-selling', () => {
    it('should return top selling products', () => {
      return request(app.getHttpServer())
        .get('/products/top-selling?limit=5')
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body)).toBe(true);
          expect(res.body.length).toBeLessThanOrEqual(5);
          if (res.body.length > 0) {
            expect(res.body[0]).toHaveProperty('total_sold');
            expect(res.body[0]).toHaveProperty('order_count');
          }
        });
    });
  });

  describe('GET /products/profit-margins', () => {
    it('should calculate profit margins', () => {
      return request(app.getHttpServer())
        .get('/products/profit-margins')
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body)).toBe(true);
          if (res.body.length > 0) {
            expect(res.body[0]).toHaveProperty('price');
            expect(res.body[0]).toHaveProperty('cost');
            expect(res.body[0]).toHaveProperty('profit');
            expect(res.body[0]).toHaveProperty('profit_margin_percent');
          }
        });
    });
  });

  describe('GET /products/inventory-value', () => {
    it('should calculate inventory value by category', () => {
      return request(app.getHttpServer())
        .get('/products/inventory-value')
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body)).toBe(true);
          if (res.body.length > 0) {
            expect(res.body[0]).toHaveProperty('category_name');
            expect(res.body[0]).toHaveProperty('product_count');
            expect(res.body[0]).toHaveProperty('total_units');
            expect(res.body[0]).toHaveProperty('inventory_value');
          }
        });
    });
  });

  describe('GET /products/never-sold', () => {
    it('should return products that were never sold', () => {
      return request(app.getHttpServer())
        .get('/products/never-sold')
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body)).toBe(true);
        });
    });
  });

  describe('GET /products/search', () => {
    it('should search products by name or SKU', () => {
      return request(app.getHttpServer())
        .get('/products/search?q=laptop')
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body)).toBe(true);
        });
    });
  });

  describe('POST /products', () => {
    it('should create a new product', () => {
      const newProduct = {
        name: 'Test Product ' + Date.now(),
        description: 'Test description',
        sku: 'TEST-SKU-' + Date.now(),
        category_id: 1,
        price: 99.99,
        cost: 50.00,
        stock_quantity: 100,
        min_stock_level: 10,
        created_by: 1,
      };

      return request(app.getHttpServer())
        .post('/products')
        .send(newProduct)
        .expect(201)
        .expect((res) => {
          expect(res.body).toHaveProperty('id');
          expect(res.body.name).toBe(newProduct.name);
          expect(res.body.sku).toBe(newProduct.sku);
        });
    });
  });
});

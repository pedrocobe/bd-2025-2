import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../src/app.module';

describe('Reports Module (e2e)', () => {
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

  describe('GET /reports/daily-sales', () => {
    it('should return daily sales report', () => {
      return request(app.getHttpServer())
        .get('/reports/daily-sales?start_date=2025-01-01&end_date=2025-01-31')
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body)).toBe(true);
          if (res.body.length > 0) {
            expect(res.body[0]).toHaveProperty('sale_date');
            expect(res.body[0]).toHaveProperty('order_count');
            expect(res.body[0]).toHaveProperty('total_sales');
            expect(res.body[0]).toHaveProperty('avg_order_value');
          }
        });
    });
  });

  describe('GET /reports/monthly-sales', () => {
    it('should return monthly sales report', () => {
      return request(app.getHttpServer())
        .get('/reports/monthly-sales?year=2025')
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body)).toBe(true);
          if (res.body.length > 0) {
            expect(res.body[0]).toHaveProperty('month_num');
            expect(res.body[0]).toHaveProperty('month_name');
            expect(res.body[0]).toHaveProperty('order_count');
            expect(res.body[0]).toHaveProperty('total_sales');
          }
        });
    });
  });

  describe('GET /reports/top-selling-products', () => {
    it('should return top selling products report', () => {
      return request(app.getHttpServer())
        .get('/reports/top-selling-products?limit=10')
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body)).toBe(true);
          if (res.body.length > 0) {
            expect(res.body[0]).toHaveProperty('name');
            expect(res.body[0]).toHaveProperty('category_name');
            expect(res.body[0]).toHaveProperty('total_quantity_sold');
            expect(res.body[0]).toHaveProperty('total_revenue');
          }
        });
    });
  });

  describe('GET /reports/top-customers', () => {
    it('should return top customers report', () => {
      return request(app.getHttpServer())
        .get('/reports/top-customers?limit=10')
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body)).toBe(true);
          if (res.body.length > 0) {
            expect(res.body[0]).toHaveProperty('customer_name');
            expect(res.body[0]).toHaveProperty('email');
            expect(res.body[0]).toHaveProperty('order_count');
            expect(res.body[0]).toHaveProperty('lifetime_value');
          }
        });
    });
  });

  describe('GET /reports/sales-by-category', () => {
    it('should return sales by category', () => {
      return request(app.getHttpServer())
        .get('/reports/sales-by-category')
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body)).toBe(true);
          if (res.body.length > 0) {
            expect(res.body[0]).toHaveProperty('category_name');
            expect(res.body[0]).toHaveProperty('product_count');
            expect(res.body[0]).toHaveProperty('units_sold');
            expect(res.body[0]).toHaveProperty('total_revenue');
          }
        });
    });
  });

  describe('GET /reports/inventory-analysis', () => {
    it('should return inventory analysis', () => {
      return request(app.getHttpServer())
        .get('/reports/inventory-analysis')
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body)).toBe(true);
          if (res.body.length > 0) {
            expect(res.body[0]).toHaveProperty('category_name');
            expect(res.body[0]).toHaveProperty('product_count');
            expect(res.body[0]).toHaveProperty('total_units');
            expect(res.body[0]).toHaveProperty('inventory_cost');
            expect(res.body[0]).toHaveProperty('inventory_value');
            expect(res.body[0]).toHaveProperty('potential_profit');
            expect(res.body[0]).toHaveProperty('low_stock_items');
          }
        });
    });
  });

  describe('GET /reports/dashboard', () => {
    it('should return dashboard metrics', () => {
      return request(app.getHttpServer())
        .get('/reports/dashboard')
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('total_customers');
          expect(res.body).toHaveProperty('total_products');
          expect(res.body).toHaveProperty('total_orders');
          expect(res.body).toHaveProperty('total_revenue');
        });
    });
  });
});

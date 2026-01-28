import { Injectable, Inject, NotFoundException } from '@nestjs/common';
import { Pool } from 'pg';
import { DATABASE_POOL } from '../database/database.module';
import { MockService } from '../mocks/mock.service';
import { ProductsQueries } from '../database/queries/products.queries';

@Injectable()
export class ProductsService {
  constructor(
    @Inject(DATABASE_POOL) private pool: Pool,
    private mockService: MockService,
  ) {}

  async findAll() {
    if (this.mockService.useMocks()) {
      return this.mockService.getProducts();
    }
    const result = await this.pool.query(ProductsQueries.findAll);
    return result.rows;
  }

  async findById(id: number) {
    if (this.mockService.useMocks()) {
      const product = this.mockService.getProductById(id);
      if (!product) {
        throw new NotFoundException(`Product with ID ${id} not found`);
      }
      return product;
    }
    const result = await this.pool.query(ProductsQueries.findById, [id]);
    if (result.rows.length === 0) {
      throw new NotFoundException(`Product with ID ${id} not found`);
    }
    return result.rows[0];
  }

  async findBySku(sku: string) {
    const result = await this.pool.query(ProductsQueries.findBySku, [sku]);
    return result.rows[0] || null;
  }

  async findByCategory(categoryId: number) {
    const result = await this.pool.query(ProductsQueries.findByCategory, [
      categoryId,
    ]);
    return result.rows;
  }

  async create(createProductDto: any) {
    const {
      name,
      description,
      sku,
      category_id,
      price,
      cost,
      stock_quantity,
      min_stock_level,
      created_by,
    } = createProductDto;

    const result = await this.pool.query(ProductsQueries.create, [
      name,
      description,
      sku,
      category_id,
      price,
      cost,
      stock_quantity,
      min_stock_level,
      created_by,
    ]);

    return result.rows[0];
  }

  async update(id: number, updateProductDto: any) {
    const {
      name,
      description,
      category_id,
      price,
      cost,
      stock_quantity,
      min_stock_level,
      is_active,
    } = updateProductDto;

    const result = await this.pool.query(ProductsQueries.update, [
      id,
      name,
      description,
      category_id,
      price,
      cost,
      stock_quantity,
      min_stock_level,
      is_active,
    ]);

    if (result.rows.length === 0) {
      throw new NotFoundException(`Product with ID ${id} not found`);
    }

    return result.rows[0];
  }

  async updateStock(id: number, stock_quantity: number) {
    const result = await this.pool.query(ProductsQueries.updateStock, [
      id,
      stock_quantity,
    ]);

    if (result.rows.length === 0) {
      throw new NotFoundException(`Product with ID ${id} not found`);
    }

    return result.rows[0];
  }

  async delete(id: number) {
    const result = await this.pool.query(ProductsQueries.delete, [id]);

    if (result.rows.length === 0) {
      throw new NotFoundException(`Product with ID ${id} not found`);
    }

    return { deleted: true, id };
  }

  async findLowStock() {
    if (this.mockService.useMocks()) {
      return this.mockService.getLowStockProducts();
    }
    const result = await this.pool.query(ProductsQueries.findLowStock);
    return result.rows;
  }

  async search(searchTerm: string) {
    if (this.mockService.useMocks()) {
      return this.mockService.searchProducts(searchTerm);
    }
    const term = `%${searchTerm}%`;
    const result = await this.pool.query(ProductsQueries.search, [term]);
    return result.rows;
  }

  async findTopSelling(limit: number = 10) {
    if (this.mockService.useMocks()) {
      return this.mockService.getTopSellingProducts(limit);
    }
    const result = await this.pool.query(ProductsQueries.findTopSelling, [
      limit,
    ]);
    return result.rows;
  }

  async calculateProfitMargins() {
    const result = await this.pool.query(ProductsQueries.calculateProfitMargins);
    return result.rows;
  }

  async getInventoryValue() {
    const result = await this.pool.query(ProductsQueries.getInventoryValue);
    return result.rows;
  }

  async findNeverSold() {
    const result = await this.pool.query(ProductsQueries.findNeverSold);
    return result.rows;
  }
}

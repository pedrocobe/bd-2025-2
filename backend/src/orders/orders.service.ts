import { Injectable, Inject, NotFoundException } from '@nestjs/common';
import { Pool } from 'pg';
import { DATABASE_POOL } from '../database/database.module';
import { MockService } from '../mocks/mock.service';
import { OrdersQueries } from '../database/queries/orders.queries';

@Injectable()
export class OrdersService {
  constructor(
    @Inject(DATABASE_POOL) private pool: Pool,
    private mockService: MockService,
  ) {}

  async findAll() {
    if (this.mockService.useMocks()) {
      return this.mockService.getOrders();
    }
    const result = await this.pool.query(OrdersQueries.findAll);
    return result.rows;
  }

  async findById(id: number) {
    if (this.mockService.useMocks()) {
      const order = this.mockService.getOrderById(id);
      if (!order) {
        throw new NotFoundException(`Order with ID ${id} not found`);
      }
      return order;
    }
    const result = await this.pool.query(OrdersQueries.findById, [id]);
    if (result.rows.length === 0) {
      throw new NotFoundException(`Order with ID ${id} not found`);
    }
    return result.rows[0];
  }

  async findByCustomer(customerId: number) {
    const result = await this.pool.query(OrdersQueries.findByCustomer, [customerId]);
    return result.rows;
  }

  async findByStatus(status: string) {
    const result = await this.pool.query(OrdersQueries.findByStatus, [status]);
    return result.rows;
  }

  async findOrderItems(orderId: number) {
    const result = await this.pool.query(OrdersQueries.findOrderItems, [orderId]);
    return result.rows;
  }

  async create(createDto: any) {
    const { customer_id, order_number, shipping_address, shipping_city, shipping_country, shipping_cost, created_by } = createDto;
    const result = await this.pool.query(OrdersQueries.create, [
      customer_id, order_number, shipping_address, shipping_city, shipping_country, shipping_cost, created_by
    ]);
    return result.rows[0];
  }

  async updateStatus(id: number, status: string) {
    const result = await this.pool.query(OrdersQueries.updateStatus, [id, status]);
    if (result.rows.length === 0) {
      throw new NotFoundException(`Order with ID ${id} not found`);
    }
    return result.rows[0];
  }

  async cancel(id: number) {
    const result = await this.pool.query(OrdersQueries.cancel, [id]);
    if (result.rows.length === 0) {
      throw new NotFoundException(`Order with ID ${id} not found`);
    }
    return result.rows[0];
  }

  async delete(id: number) {
    const result = await this.pool.query(OrdersQueries.delete, [id]);
    if (result.rows.length === 0) {
      throw new NotFoundException(`Order with ID ${id} not found`);
    }
    return { deleted: true, id };
  }
}

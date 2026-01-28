import { Injectable, Inject, NotFoundException } from '@nestjs/common';
import { Pool } from 'pg';
import { DATABASE_POOL } from '../database/database.module';
import { MockService } from '../mocks/mock.service';
import { CustomersQueries } from '../database/queries/customers.queries';

@Injectable()
export class CustomersService {
  constructor(
    @Inject(DATABASE_POOL) private pool: Pool,
    private mockService: MockService,
  ) {}

  async findAll() {
    if (this.mockService.useMocks()) {
      return this.mockService.getCustomers();
    }
    const result = await this.pool.query(CustomersQueries.findAll);
    return result.rows;
  }

  async findById(id: number) {
    if (this.mockService.useMocks()) {
      const customer = this.mockService.getCustomerById(id);
      if (!customer) {
        throw new NotFoundException(`Customer with ID ${id} not found`);
      }
      return customer;
    }
    const result = await this.pool.query(CustomersQueries.findById, [id]);
    if (result.rows.length === 0) {
      throw new NotFoundException(`Customer with ID ${id} not found`);
    }
    return result.rows[0];
  }

  async create(createDto: any) {
    const { first_name, last_name, email, phone, address, city, country, postal_code } = createDto;
    const result = await this.pool.query(CustomersQueries.create, [
      first_name, last_name, email, phone, address, city, country, postal_code
    ]);
    return result.rows[0];
  }

  async update(id: number, updateDto: any) {
    const { first_name, last_name, email, phone, address, city, country, postal_code, is_active } = updateDto;
    const result = await this.pool.query(CustomersQueries.update, [
      id, first_name, last_name, email, phone, address, city, country, postal_code, is_active
    ]);
    if (result.rows.length === 0) {
      throw new NotFoundException(`Customer with ID ${id} not found`);
    }
    return result.rows[0];
  }

  async delete(id: number) {
    const result = await this.pool.query(CustomersQueries.delete, [id]);
    if (result.rows.length === 0) {
      throw new NotFoundException(`Customer with ID ${id} not found`);
    }
    return { deleted: true, id };
  }

  async search(searchTerm: string) {
    const term = `%${searchTerm}%`;
    const result = await this.pool.query(CustomersQueries.search, [term]);
    return result.rows;
  }

  async findTopCustomers(limit: number = 10) {
    const result = await this.pool.query(CustomersQueries.findTopCustomers, [limit]);
    return result.rows;
  }

  async groupByCity() {
    const result = await this.pool.query(CustomersQueries.groupByCity);
    return result.rows;
  }
}

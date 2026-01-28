import { Injectable, Inject, NotFoundException } from '@nestjs/common';
import { Pool } from 'pg';
import { DATABASE_POOL } from '../database/database.module';
import { CategoriesQueries } from '../database/queries/categories.queries';

@Injectable()
export class CategoriesService {
  constructor(@Inject(DATABASE_POOL) private pool: Pool) {}

  async findAll() {
    const result = await this.pool.query(CategoriesQueries.findAll);
    return result.rows;
  }

  async findById(id: number) {
    const result = await this.pool.query(CategoriesQueries.findById, [id]);
    if (result.rows.length === 0) {
      throw new NotFoundException(`Category with ID ${id} not found`);
    }
    return result.rows[0];
  }

  async findAllWithParent() {
    const result = await this.pool.query(CategoriesQueries.findAllWithParent);
    return result.rows;
  }

  async findRootCategories() {
    const result = await this.pool.query(CategoriesQueries.findRootCategories);
    return result.rows;
  }

  async findByParent(parentId: number) {
    const result = await this.pool.query(CategoriesQueries.findByParent, [parentId]);
    return result.rows;
  }

  async create(createDto: any) {
    const { name, description, parent_id } = createDto;
    const result = await this.pool.query(CategoriesQueries.create, [name, description, parent_id]);
    return result.rows[0];
  }

  async update(id: number, updateDto: any) {
    const { name, description, parent_id, is_active } = updateDto;
    const result = await this.pool.query(CategoriesQueries.update, [id, name, description, parent_id, is_active]);
    if (result.rows.length === 0) {
      throw new NotFoundException(`Category with ID ${id} not found`);
    }
    return result.rows[0];
  }

  async delete(id: number) {
    const result = await this.pool.query(CategoriesQueries.delete, [id]);
    if (result.rows.length === 0) {
      throw new NotFoundException(`Category with ID ${id} not found`);
    }
    return { deleted: true, id };
  }

  async countProducts() {
    const result = await this.pool.query(CategoriesQueries.countProducts);
    return result.rows;
  }
}

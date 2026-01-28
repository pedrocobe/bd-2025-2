import { Injectable, Inject, NotFoundException } from '@nestjs/common';
import { Pool } from 'pg';
import { DATABASE_POOL } from '../database/database.module';
import { MockService } from '../mocks/mock.service';
import { UsersQueries } from '../database/queries/users.queries';
import { CreateUserDto, UpdateUserDto } from './dto/user.dto';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
  constructor(
    @Inject(DATABASE_POOL) private pool: Pool,
    private mockService: MockService,
  ) {}

  async findAll() {
    if (this.mockService.useMocks()) {
      return this.mockService.getUsers();
    }
    const result = await this.pool.query(UsersQueries.findAll);
    return result.rows;
  }

  async findById(id: number) {
    if (this.mockService.useMocks()) {
      const user = this.mockService.getUserById(id);
      if (!user) {
        throw new NotFoundException(`User with ID ${id} not found`);
      }
      return user;
    }
    const result = await this.pool.query(UsersQueries.findById, [id]);
    if (result.rows.length === 0) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }
    return result.rows[0];
  }

  async findByUsername(username: string) {
    const result = await this.pool.query(UsersQueries.findByUsername, [
      username,
    ]);
    return result.rows[0] || null;
  }

  async findByEmail(email: string) {
    const result = await this.pool.query(UsersQueries.findByEmail, [email]);
    return result.rows[0] || null;
  }

  async create(createUserDto: CreateUserDto) {
    const { username, email, password, full_name, role } = createUserDto;

    // Hash password
    const password_hash = await bcrypt.hash(password, 10);

    const result = await this.pool.query(UsersQueries.create, [
      username,
      email,
      password_hash,
      full_name,
      role || 'employee',
    ]);

    return result.rows[0];
  }

  async update(id: number, updateUserDto: UpdateUserDto) {
    const { email, full_name, role, is_active } = updateUserDto;

    const result = await this.pool.query(UsersQueries.update, [
      id,
      email,
      full_name,
      role,
      is_active,
    ]);

    if (result.rows.length === 0) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    return result.rows[0];
  }

  async updatePassword(id: number, newPassword: string) {
    const password_hash = await bcrypt.hash(newPassword, 10);

    const result = await this.pool.query(UsersQueries.updatePassword, [
      id,
      password_hash,
    ]);

    if (result.rows.length === 0) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    return result.rows[0];
  }

  async updateLastLogin(id: number) {
    const result = await this.pool.query(UsersQueries.updateLastLogin, [id]);
    return result.rows[0];
  }

  async deactivate(id: number) {
    const result = await this.pool.query(UsersQueries.deactivate, [id]);

    if (result.rows.length === 0) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    return result.rows[0];
  }

  async delete(id: number) {
    const result = await this.pool.query(UsersQueries.delete, [id]);

    if (result.rows.length === 0) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    return { deleted: true, id };
  }

  async findByRole(role: string) {
    if (this.mockService.useMocks()) {
      return this.mockService.getUsersByRole(role);
    }
    const result = await this.pool.query(UsersQueries.findByRole, [role]);
    return result.rows;
  }

  async countByRole() {
    if (this.mockService.useMocks()) {
      return this.mockService.countUsersByRole();
    }
    const result = await this.pool.query(UsersQueries.countByRole);
    return result.rows;
  }

  async search(searchTerm: string) {
    if (this.mockService.useMocks()) {
      return this.mockService.searchUsers(searchTerm);
    }
    const term = `%${searchTerm}%`;
    const result = await this.pool.query(UsersQueries.search, [term]);
    return result.rows;
  }
}

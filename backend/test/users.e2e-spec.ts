import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../src/app.module';

describe('Users Module (e2e)', () => {
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

  describe('GET /users', () => {
    it('should return an array of users', () => {
      return request(app.getHttpServer())
        .get('/users')
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body)).toBe(true);
          if (res.body.length > 0) {
            expect(res.body[0]).toHaveProperty('id');
            expect(res.body[0]).toHaveProperty('username');
            expect(res.body[0]).toHaveProperty('email');
            expect(res.body[0]).not.toHaveProperty('password_hash');
          }
        });
    });
  });

  describe('GET /users/:id', () => {
    it('should return a single user', () => {
      return request(app.getHttpServer())
        .get('/users/1')
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('id');
          expect(res.body).toHaveProperty('username');
          expect(res.body).toHaveProperty('full_name');
          expect(res.body).not.toHaveProperty('password_hash');
        });
    });

    it('should return 404 for non-existent user', () => {
      return request(app.getHttpServer())
        .get('/users/99999')
        .expect(404);
    });
  });

  describe('GET /users/search', () => {
    it('should search users by name', () => {
      return request(app.getHttpServer())
        .get('/users/search?q=admin')
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body)).toBe(true);
        });
    });
  });

  describe('GET /users/role/:role', () => {
    it('should return users by role', () => {
      return request(app.getHttpServer())
        .get('/users/role/admin')
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body)).toBe(true);
          if (res.body.length > 0) {
            expect(res.body[0].role).toBe('admin');
          }
        });
    });
  });

  describe('GET /users/stats/by-role', () => {
    it('should return count of users by role', () => {
      return request(app.getHttpServer())
        .get('/users/stats/by-role')
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body)).toBe(true);
          if (res.body.length > 0) {
            expect(res.body[0]).toHaveProperty('role');
            expect(res.body[0]).toHaveProperty('count');
          }
        });
    });
  });

  describe('POST /users', () => {
    it('should create a new user', () => {
      const newUser = {
        username: 'testuser' + Date.now(),
        email: `test${Date.now()}@example.com`,
        password: 'password123',
        full_name: 'Test User',
        role: 'employee',
      };

      return request(app.getHttpServer())
        .post('/users')
        .send(newUser)
        .expect(201)
        .expect((res) => {
          expect(res.body).toHaveProperty('id');
          expect(res.body.username).toBe(newUser.username);
          expect(res.body.email).toBe(newUser.email);
          expect(res.body).not.toHaveProperty('password_hash');
        });
    });
  });

  describe('PUT /users/:id', () => {
    let userId: number;

    beforeAll(async () => {
      const res = await request(app.getHttpServer())
        .post('/users')
        .send({
          username: 'updatetest' + Date.now(),
          email: `update${Date.now()}@example.com`,
          password: 'password123',
          full_name: 'Update Test',
          role: 'employee',
        });
      userId = res.body.id;
    });

    it('should update a user', () => {
      return request(app.getHttpServer())
        .put(`/users/${userId}`)
        .send({
          email: `updated${Date.now()}@example.com`,
          full_name: 'Updated Name',
          role: 'manager',
          is_active: true,
        })
        .expect(200)
        .expect((res) => {
          expect(res.body.full_name).toBe('Updated Name');
          expect(res.body.role).toBe('manager');
        });
    });
  });

  describe('PUT /users/:id/deactivate', () => {
    let userId: number;

    beforeAll(async () => {
      const res = await request(app.getHttpServer())
        .post('/users')
        .send({
          username: 'deactivatetest' + Date.now(),
          email: `deactivate${Date.now()}@example.com`,
          password: 'password123',
          full_name: 'Deactivate Test',
          role: 'employee',
        });
      userId = res.body.id;
    });

    it('should deactivate a user', () => {
      return request(app.getHttpServer())
        .put(`/users/${userId}/deactivate`)
        .expect(200)
        .expect((res) => {
          expect(res.body.is_active).toBe(false);
        });
    });
  });
});

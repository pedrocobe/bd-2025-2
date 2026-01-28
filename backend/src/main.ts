import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Enable CORS for frontend
  app.enableCors({
    origin: ['http://localhost:5173', 'http://localhost:3000'],
    credentials: true,
  });

  // Global validation pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  // Documentación API Swagger
  const config = new DocumentBuilder()
    .setTitle('API Examen E-commerce')
    .setDescription('API para examen de Base de Datos - Sistema de E-commerce')
    .setVersion('1.0')
    .addBearerAuth()
    .addTag('auth', 'Autenticación y autorización')
    .addTag('users', 'Gestión de usuarios')
    .addTag('categories', 'Gestión de categorías')
    .addTag('products', 'Gestión de productos')
    .addTag('customers', 'Gestión de clientes')
    .addTag('orders', 'Gestión de pedidos')
    .addTag('reports', 'Reportes y estadísticas')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  const port = process.env.PORT || 3000;
  await app.listen(port);

  console.log(`
  🚀 Aplicación corriendo en: http://localhost:${port}
  📚 Documentación API: http://localhost:${port}/api
  🗄️  Base de datos: PostgreSQL en ${process.env.DB_HOST}:${process.env.DB_PORT}
  `);
}

bootstrap();

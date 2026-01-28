import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';

@ApiTags('salud')
@Controller()
export class AppController {
  @Get()
  @ApiOperation({ summary: 'Verificación de salud' })
  getHealth() {
    return {
      status: 'ok',
      message: 'API Examen E-commerce está funcionando',
      timestamp: new Date().toISOString(),
    };
  }

  @Get('info')
  @ApiOperation({ summary: 'Información de la API' })
  getInfo() {
    return {
      name: 'API Examen E-commerce',
      version: '1.0.0',
      description: 'API para examen de Base de Datos',
      endpoints: {
        docs: '/api',
        auth: '/auth',
        users: '/users',
        categories: '/categories',
        products: '/products',
        customers: '/customers',
        orders: '/orders',
        reports: '/reports',
      },
    };
  }
}

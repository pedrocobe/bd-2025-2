import { Controller, Get, Post, Put, Delete, Body, Param, ParseIntPipe } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { OrdersService } from './orders.service';

@ApiTags('orders')
@Controller('orders')
export class OrdersController {
  constructor(private readonly ordersService: OrdersService) {}

  @Get()
  @ApiOperation({ summary: 'Obtener todos los pedidos' })
  findAll() {
    return this.ordersService.findAll();
  }

  @Get('customer/:customerId')
  @ApiOperation({ summary: 'Obtener pedidos por cliente' })
  findByCustomer(@Param('customerId', ParseIntPipe) customerId: number) {
    return this.ordersService.findByCustomer(customerId);
  }

  @Get('status/:status')
  @ApiOperation({ summary: 'Obtener pedidos por estado' })
  findByStatus(@Param('status') status: string) {
    return this.ordersService.findByStatus(status);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Obtener pedido por ID' })
  findById(@Param('id', ParseIntPipe) id: number) {
    return this.ordersService.findById(id);
  }

  @Get(':id/items')
  @ApiOperation({ summary: 'Obtener items del pedido' })
  findOrderItems(@Param('id', ParseIntPipe) id: number) {
    return this.ordersService.findOrderItems(id);
  }

  @Post()
  @ApiOperation({ summary: 'Crear pedido' })
  create(@Body() createDto: any) {
    return this.ordersService.create(createDto);
  }

  @Put(':id/status')
  @ApiOperation({ summary: 'Actualizar estado del pedido' })
  updateStatus(@Param('id', ParseIntPipe) id: number, @Body('status') status: string) {
    return this.ordersService.updateStatus(id, status);
  }

  @Put(':id/cancel')
  @ApiOperation({ summary: 'Cancelar pedido' })
  cancel(@Param('id', ParseIntPipe) id: number) {
    return this.ordersService.cancel(id);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Eliminar pedido' })
  delete(@Param('id', ParseIntPipe) id: number) {
    return this.ordersService.delete(id);
  }
}

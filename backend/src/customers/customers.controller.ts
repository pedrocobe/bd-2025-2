import { Controller, Get, Post, Put, Delete, Body, Param, Query, ParseIntPipe } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { CustomersService } from './customers.service';

@ApiTags('customers')
@Controller('customers')
export class CustomersController {
  constructor(private readonly customersService: CustomersService) {}

  @Get()
  @ApiOperation({ summary: 'Obtener todos los clientes' })
  findAll() {
    return this.customersService.findAll();
  }

  @Get('search')
  @ApiOperation({ summary: 'Buscar clientes' })
  search(@Query('q') searchTerm: string) {
    return this.customersService.search(searchTerm);
  }

  @Get('top')
  @ApiOperation({ summary: 'Obtener mejores clientes' })
  findTopCustomers(@Query('limit', ParseIntPipe) limit: number = 10) {
    return this.customersService.findTopCustomers(limit);
  }

  @Get('stats/by-city')
  @ApiOperation({ summary: 'Agrupar clientes por ciudad' })
  groupByCity() {
    return this.customersService.groupByCity();
  }

  @Get(':id')
  @ApiOperation({ summary: 'Obtener cliente por ID' })
  findById(@Param('id', ParseIntPipe) id: number) {
    return this.customersService.findById(id);
  }

  @Post()
  @ApiOperation({ summary: 'Crear cliente' })
  create(@Body() createDto: any) {
    return this.customersService.create(createDto);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Actualizar cliente' })
  update(@Param('id', ParseIntPipe) id: number, @Body() updateDto: any) {
    return this.customersService.update(id, updateDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Eliminar cliente' })
  delete(@Param('id', ParseIntPipe) id: number) {
    return this.customersService.delete(id);
  }
}

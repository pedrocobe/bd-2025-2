import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  ParseIntPipe,
} from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { ProductsService } from './products.service';

@ApiTags('products')
@Controller('products')
export class ProductsController {
  constructor(private readonly productsService: ProductsService) {}

  @Get()
  @ApiOperation({ summary: 'Obtener todos los productos' })
  findAll() {
    return this.productsService.findAll();
  }

  @Get('search')
  @ApiOperation({ summary: 'Buscar productos' })
  search(@Query('q') searchTerm: string) {
    return this.productsService.search(searchTerm);
  }

  @Get('low-stock')
  @ApiOperation({ summary: 'Obtener productos con stock bajo' })
  findLowStock() {
    return this.productsService.findLowStock();
  }

  @Get('top-selling')
  @ApiOperation({ summary: 'Obtener productos más vendidos' })
  findTopSelling(@Query('limit', ParseIntPipe) limit: number = 10) {
    return this.productsService.findTopSelling(limit);
  }

  @Get('profit-margins')
  @ApiOperation({ summary: 'Calcular márgenes de ganancia' })
  calculateProfitMargins() {
    return this.productsService.calculateProfitMargins();
  }

  @Get('inventory-value')
  @ApiOperation({ summary: 'Obtener valor del inventario' })
  getInventoryValue() {
    return this.productsService.getInventoryValue();
  }

  @Get('never-sold')
  @ApiOperation({ summary: 'Obtener productos nunca vendidos' })
  findNeverSold() {
    return this.productsService.findNeverSold();
  }

  @Get('category/:categoryId')
  @ApiOperation({ summary: 'Obtener productos por categoría' })
  findByCategory(@Param('categoryId', ParseIntPipe) categoryId: number) {
    return this.productsService.findByCategory(categoryId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Obtener producto por ID' })
  findById(@Param('id', ParseIntPipe) id: number) {
    return this.productsService.findById(id);
  }

  @Post()
  @ApiOperation({ summary: 'Crear un nuevo producto' })
  create(@Body() createProductDto: any) {
    return this.productsService.create(createProductDto);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Actualizar producto' })
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateProductDto: any,
  ) {
    return this.productsService.update(id, updateProductDto);
  }

  @Put(':id/stock')
  @ApiOperation({ summary: 'Actualizar stock del producto' })
  updateStock(
    @Param('id', ParseIntPipe) id: number,
    @Body('stock_quantity', ParseIntPipe) stock_quantity: number,
  ) {
    return this.productsService.updateStock(id, stock_quantity);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Eliminar producto' })
  delete(@Param('id', ParseIntPipe) id: number) {
    return this.productsService.delete(id);
  }
}

import { Controller, Get, Post, Put, Delete, Body, Param, ParseIntPipe } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { CategoriesService } from './categories.service';

@ApiTags('categories')
@Controller('categories')
export class CategoriesController {
  constructor(private readonly categoriesService: CategoriesService) {}

  @Get()
  @ApiOperation({ summary: 'Obtener todas las categorías' })
  findAll() {
    return this.categoriesService.findAll();
  }

  @Get('with-parent')
  @ApiOperation({ summary: 'Obtener categorías con info del padre' })
  findAllWithParent() {
    return this.categoriesService.findAllWithParent();
  }

  @Get('root')
  @ApiOperation({ summary: 'Obtener categorías principales' })
  findRootCategories() {
    return this.categoriesService.findRootCategories();
  }

  @Get('stats/products')
  @ApiOperation({ summary: 'Contar productos por categoría' })
  countProducts() {
    return this.categoriesService.countProducts();
  }

  @Get('parent/:parentId')
  @ApiOperation({ summary: 'Obtener categorías por padre' })
  findByParent(@Param('parentId', ParseIntPipe) parentId: number) {
    return this.categoriesService.findByParent(parentId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Obtener categoría por ID' })
  findById(@Param('id', ParseIntPipe) id: number) {
    return this.categoriesService.findById(id);
  }

  @Post()
  @ApiOperation({ summary: 'Crear categoría' })
  create(@Body() createDto: any) {
    return this.categoriesService.create(createDto);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Actualizar categoría' })
  update(@Param('id', ParseIntPipe) id: number, @Body() updateDto: any) {
    return this.categoriesService.update(id, updateDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Eliminar categoría' })
  delete(@Param('id', ParseIntPipe) id: number) {
    return this.categoriesService.delete(id);
  }
}

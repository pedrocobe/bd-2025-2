import { Controller, Get, Query, ParseIntPipe } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery } from '@nestjs/swagger';
import { ReportsService } from './reports.service';

@ApiTags('reports')
@Controller('reports')
export class ReportsController {
  constructor(private readonly reportsService: ReportsService) {}

  @Get('daily-sales')
  @ApiOperation({ summary: 'Obtener reporte de ventas diarias' })
  @ApiQuery({ name: 'start_date', example: '2025-01-01' })
  @ApiQuery({ name: 'end_date', example: '2025-01-31' })
  dailySales(
    @Query('start_date') startDate: string,
    @Query('end_date') endDate: string,
  ) {
    return this.reportsService.dailySales(startDate, endDate);
  }

  @Get('monthly-sales')
  @ApiOperation({ summary: 'Obtener reporte de ventas mensuales' })
  @ApiQuery({ name: 'year', example: 2025 })
  monthlySales(@Query('year', ParseIntPipe) year: number) {
    return this.reportsService.monthlySales(year);
  }

  @Get('top-selling-products')
  @ApiOperation({ summary: 'Obtener productos más vendidos' })
  topSellingProducts(@Query('limit', ParseIntPipe) limit: number = 10) {
    return this.reportsService.topSellingProducts(limit);
  }

  @Get('top-customers')
  @ApiOperation({ summary: 'Obtener mejores clientes' })
  topCustomers(@Query('limit', ParseIntPipe) limit: number = 10) {
    return this.reportsService.topCustomers(limit);
  }

  @Get('sales-by-category')
  @ApiOperation({ summary: 'Obtener ventas por categoría' })
  salesByCategory() {
    return this.reportsService.salesByCategory();
  }

  @Get('inventory-analysis')
  @ApiOperation({ summary: 'Obtener análisis de inventario' })
  inventoryAnalysis() {
    return this.reportsService.inventoryAnalysis();
  }

  @Get('profit-margins')
  @ApiOperation({ summary: 'Obtener reporte de márgenes de ganancia' })
  profitMarginReport() {
    return this.reportsService.profitMarginReport();
  }

  @Get('sales-by-city')
  @ApiOperation({ summary: 'Obtener ventas por ciudad' })
  salesByCity() {
    return this.reportsService.salesByCity();
  }

  @Get('abandoned-orders')
  @ApiOperation({ summary: 'Obtener pedidos abandonados' })
  abandonedOrders(@Query('days', ParseIntPipe) days: number = 7) {
    return this.reportsService.abandonedOrders(days);
  }

  @Get('unsold-products')
  @ApiOperation({ summary: 'Obtener productos sin vender' })
  unsoldProducts(@Query('days', ParseIntPipe) days: number = 90) {
    return this.reportsService.unsoldProducts(days);
  }

  @Get('employee-performance')
  @ApiOperation({ summary: 'Obtener rendimiento de empleados' })
  employeePerformance(
    @Query('start_date') startDate: string,
    @Query('end_date') endDate: string,
  ) {
    return this.reportsService.employeePerformance(startDate, endDate);
  }

  @Get('sales-trend')
  @ApiOperation({ summary: 'Obtener tendencia de ventas' })
  salesTrend(
    @Query('month', ParseIntPipe) month: number,
    @Query('year', ParseIntPipe) year: number,
  ) {
    return this.reportsService.salesTrend(month, year);
  }

  @Get('dashboard')
  @ApiOperation({ summary: 'Obtener métricas del dashboard' })
  dashboardMetrics() {
    return this.reportsService.dashboardMetrics();
  }
}

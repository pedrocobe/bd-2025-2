import { Injectable, Inject } from '@nestjs/common';
import { Pool } from 'pg';
import { DATABASE_POOL } from '../database/database.module';
import { MockService } from '../mocks/mock.service';
import { ReportsQueries } from '../database/queries/reports.queries';

@Injectable()
export class ReportsService {
  constructor(
    @Inject(DATABASE_POOL) private pool: Pool,
    private mockService: MockService,
  ) {}

  async dailySales(startDate: string, endDate: string) {
    if (this.mockService.useMocks()) {
      return this.mockService.getDailySales(startDate, endDate);
    }
    const result = await this.pool.query(ReportsQueries.dailySales, [
      startDate,
      endDate,
    ]);
    return result.rows;
  }

  async monthlySales(year: number) {
    if (this.mockService.useMocks()) {
      return this.mockService.getMonthlySales(year);
    }
    const result = await this.pool.query(ReportsQueries.monthlySales, [year]);
    return result.rows;
  }

  async topSellingProducts(limit: number = 10) {
    if (this.mockService.useMocks()) {
      return this.mockService.getTopSellingProductsReport(limit);
    }
    const result = await this.pool.query(ReportsQueries.topSellingProducts, [
      limit,
    ]);
    return result.rows;
  }

  async topCustomers(limit: number = 10) {
    if (this.mockService.useMocks()) {
      return this.mockService.getTopCustomersReport(limit);
    }
    const result = await this.pool.query(ReportsQueries.topCustomers, [limit]);
    return result.rows;
  }

  async salesByCategory() {
    if (this.mockService.useMocks()) {
      return this.mockService.getSalesByCategory();
    }
    const result = await this.pool.query(ReportsQueries.salesByCategory);
    return result.rows;
  }

  async inventoryAnalysis() {
    if (this.mockService.useMocks()) {
      return this.mockService.getInventoryAnalysis();
    }
    const result = await this.pool.query(ReportsQueries.inventoryAnalysis);
    return result.rows;
  }

  async profitMarginReport() {
    const result = await this.pool.query(ReportsQueries.profitMarginReport);
    return result.rows;
  }

  async salesByCity() {
    const result = await this.pool.query(ReportsQueries.salesByCity);
    return result.rows;
  }

  async abandonedOrders(days: number) {
    const result = await this.pool.query(ReportsQueries.abandonedOrders, [
      days,
    ]);
    return result.rows;
  }

  async unsoldProducts(days: number) {
    const result = await this.pool.query(ReportsQueries.unsoldProducts, [days]);
    return result.rows;
  }

  async employeePerformance(startDate: string, endDate: string) {
    const result = await this.pool.query(ReportsQueries.employeePerformance, [
      startDate,
      endDate,
    ]);
    return result.rows;
  }

  async salesTrend(currentMonth: number, currentYear: number) {
    const result = await this.pool.query(ReportsQueries.salesTrend, [
      currentMonth,
      currentYear,
    ]);
    return result.rows;
  }

  async dashboardMetrics() {
    if (this.mockService.useMocks()) {
      return this.mockService.getDashboardMetrics();
    }
    const result = await this.pool.query(ReportsQueries.dashboardMetrics);
    return result.rows[0];
  }
}

import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import {
  mockUsers,
  mockCategories,
  mockProducts,
  mockCustomers,
  mockOrders,
  mockTopProducts,
  mockTopCustomers,
  mockDailySales,
  mockMonthlySales,
  mockSalesByCategory,
  mockInventoryAnalysis,
  mockDashboardMetrics,
} from './mock-data';

/**
 * Mock Service
 * 
 * Este servicio proporciona datos simulados cuando USE_MOCKS=true
 * Permite a los estudiantes ver el frontend funcionando antes de escribir SQL
 */
@Injectable()
export class MockService {
  constructor(private configService: ConfigService) {}

  useMocks(): boolean {
    return this.configService.get('USE_MOCKS') === 'true';
  }

  // Users
  getUsers() {
    return mockUsers.map(({ password_hash, ...user }) => user);
  }

  getUserById(id: number) {
    const user = mockUsers.find((u) => u.id === id);
    if (!user) return null;
    const { password_hash, ...userWithoutPassword } = user;
    return userWithoutPassword;
  }

  getUserByUsername(username: string) {
    return mockUsers.find((u) => u.username === username) || null;
  }

  searchUsers(term: string) {
    const lowerTerm = term.toLowerCase();
    return mockUsers
      .filter(
        (u) =>
          u.full_name.toLowerCase().includes(lowerTerm) ||
          u.email.toLowerCase().includes(lowerTerm),
      )
      .map(({ password_hash, ...user }) => user);
  }

  getUsersByRole(role: string) {
    return mockUsers
      .filter((u) => u.role === role)
      .map(({ password_hash, ...user }) => user);
  }

  countUsersByRole() {
    const counts: Record<string, number> = {};
    mockUsers.forEach((u) => {
      counts[u.role] = (counts[u.role] || 0) + 1;
    });
    return Object.entries(counts).map(([role, count]) => ({ role, count }));
  }

  // Categories
  getCategories() {
    return mockCategories;
  }

  getCategoryById(id: number) {
    return mockCategories.find((c) => c.id === id) || null;
  }

  getCategoriesWithParent() {
    return mockCategories.map((c) => {
      const parent = c.parent_id
        ? mockCategories.find((p) => p.id === c.parent_id)
        : null;
      return {
        ...c,
        parent_name: parent?.name || null,
      };
    });
  }

  getRootCategories() {
    return mockCategories.filter((c) => c.parent_id === null);
  }

  getCategoriesByParent(parentId: number) {
    return mockCategories.filter((c) => c.parent_id === parentId);
  }

  countProductsByCategory() {
    const counts: Record<number, number> = {};
    mockProducts.forEach((p) => {
      if (p.category_id) {
        counts[p.category_id] = (counts[p.category_id] || 0) + 1;
      }
    });
    return mockCategories.map((c) => ({
      id: c.id,
      name: c.name,
      product_count: counts[c.id] || 0,
    }));
  }

  // Products
  getProducts() {
    return mockProducts;
  }

  getProductById(id: number) {
    return mockProducts.find((p) => p.id === id) || null;
  }

  getProductsBySku(sku: string) {
    return mockProducts.find((p) => p.sku === sku) || null;
  }

  getProductsByCategory(categoryId: number) {
    return mockProducts.filter((p) => p.category_id === categoryId);
  }

  searchProducts(term: string) {
    const lowerTerm = term.toLowerCase();
    return mockProducts.filter(
      (p) =>
        p.name.toLowerCase().includes(lowerTerm) ||
        p.sku.toLowerCase().includes(lowerTerm),
    );
  }

  getLowStockProducts() {
    return mockProducts
      .filter((p) => p.stock_quantity < p.min_stock_level)
      .map((p) => ({
        ...p,
        deficit: p.min_stock_level - p.stock_quantity,
      }));
  }

  getTopSellingProducts(limit: number) {
    return mockTopProducts.slice(0, limit);
  }

  calculateProfitMargins() {
    return mockProducts.map((p) => {
      const profit = parseFloat(p.price) - parseFloat(p.cost);
      const profit_margin_percent = (profit / parseFloat(p.price)) * 100;
      return {
        id: p.id,
        name: p.name,
        price: p.price,
        cost: p.cost,
        profit: profit.toFixed(2),
        profit_margin_percent: profit_margin_percent.toFixed(2),
      };
    });
  }

  getInventoryValue() {
    const byCategory: Record<string, any> = {};
    mockProducts.forEach((p) => {
      const cat = p.category_name || 'Sin categoría';
      if (!byCategory[cat]) {
        byCategory[cat] = {
          category_name: cat,
          product_count: 0,
          total_units: 0,
          inventory_value: 0,
        };
      }
      byCategory[cat].product_count++;
      byCategory[cat].total_units += p.stock_quantity;
      byCategory[cat].inventory_value +=
        p.stock_quantity * parseFloat(p.cost);
    });
    return Object.values(byCategory);
  }

  getNeverSoldProducts() {
    // Simulación: productos sin ventas
    return [];
  }

  // Customers
  getCustomers() {
    return mockCustomers;
  }

  getCustomerById(id: number) {
    return mockCustomers.find((c) => c.id === id) || null;
  }

  searchCustomers(term: string) {
    const lowerTerm = term.toLowerCase();
    return mockCustomers.filter(
      (c) =>
        c.first_name.toLowerCase().includes(lowerTerm) ||
        c.last_name.toLowerCase().includes(lowerTerm) ||
        c.email.toLowerCase().includes(lowerTerm),
    );
  }

  getTopCustomers(limit: number) {
    return mockTopCustomers.slice(0, limit);
  }

  groupCustomersByCity() {
    const byCity: Record<string, any> = {};
    mockCustomers.forEach((c) => {
      const key = `${c.city}, ${c.country}`;
      if (!byCity[key]) {
        byCity[key] = {
          city: c.city,
          country: c.country,
          customer_count: 0,
          total_revenue: 0,
        };
      }
      byCity[key].customer_count++;
      byCity[key].total_revenue += parseFloat(c.total_spent);
    });
    return Object.values(byCity);
  }

  // Orders
  getOrders() {
    return mockOrders;
  }

  getOrderById(id: number) {
    return mockOrders.find((o) => o.id === id) || null;
  }

  getOrdersByCustomer(customerId: number) {
    return mockOrders.filter((o) => o.customer_id === customerId);
  }

  getOrdersByStatus(status: string) {
    return mockOrders.filter((o) => o.status === status);
  }

  getOrderItems(orderId: number) {
    // Simulación de items de pedido
    return [
      {
        id: 1,
        order_id: orderId,
        product_id: 1,
        product_name: 'Laptop Dell XPS 13',
        sku: 'DELL-XPS13-001',
        quantity: 1,
        unit_price: '1299.99',
        subtotal: '1299.99',
      },
    ];
  }

  countOrdersByStatus() {
    const counts: Record<string, any> = {};
    mockOrders.forEach((o) => {
      if (!counts[o.status]) {
        counts[o.status] = {
          status: o.status,
          order_count: 0,
          total_amount: 0,
        };
      }
      counts[o.status].order_count++;
      counts[o.status].total_amount += parseFloat(o.total);
    });
    return Object.values(counts);
  }

  // Reports
  getDailySales(startDate: string, endDate: string) {
    return mockDailySales;
  }

  getMonthlySales(year: number) {
    return mockMonthlySales;
  }

  getTopSellingProductsReport(limit: number) {
    return mockTopProducts.slice(0, limit);
  }

  getTopCustomersReport(limit: number) {
    return mockTopCustomers.slice(0, limit);
  }

  getSalesByCategory() {
    return mockSalesByCategory;
  }

  getInventoryAnalysis() {
    return mockInventoryAnalysis;
  }

  getProfitMarginReport() {
    return this.calculateProfitMargins();
  }

  getSalesByCity() {
    return this.groupCustomersByCity();
  }

  getAbandonedOrders(days: number) {
    return mockOrders.filter((o) => o.status === 'pending');
  }

  getUnsoldProducts(days: number) {
    return [];
  }

  getEmployeePerformance(startDate: string, endDate: string) {
    return [];
  }

  getSalesTrend(month: number, year: number) {
    return mockMonthlySales;
  }

  getDashboardMetrics() {
    return mockDashboardMetrics;
  }
}

import { useState, useEffect } from 'react';
import axios from 'axios';

export default function Reports() {
  const [topProducts, setTopProducts] = useState([]);
  const [topCustomers, setTopCustomers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    loadReports();
  }, []);

  const loadReports = async () => {
    try {
      const [productsRes, customersRes] = await Promise.all([
        axios.get('/api/reports/top-selling-products?limit=5'),
        axios.get('/api/reports/top-customers?limit=5'),
      ]);
      setTopProducts(productsRes.data);
      setTopCustomers(customersRes.data);
      setLoading(false);
    } catch (err: any) {
      setError(err.response?.data?.message || 'Error loading reports');
      setLoading(false);
    }
  };

  if (loading) return <div className="loading">Cargando...</div>;
  if (error) return <div className="error">{error}</div>;

  return (
    <div className="page">
      <div className="page-header">
        <h2>📈 Reportes</h2>
        <p>Queries SQL avanzadas con JOINs, GROUP BY y agregaciones</p>
      </div>

      <div className="card">
        <h3>🔥 Productos Más Vendidos</h3>
        <p style={{ fontSize: '0.875rem', color: '#666', marginBottom: '1rem' }}>
          Query: reports.queries.ts - topSellingProducts
        </p>
        <table>
          <thead>
            <tr>
              <th>Product</th>
              <th>Category</th>
              <th>Units Sold</th>
              <th>Revenue</th>
            </tr>
          </thead>
          <tbody>
            {topProducts.map((product: any) => (
              <tr key={product.id}>
                <td>{product.name}</td>
                <td>{product.category_name}</td>
                <td>{product.total_quantity_sold}</td>
                <td>${parseFloat(product.total_revenue).toFixed(2)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      <div className="card" style={{ marginTop: '2rem' }}>
        <h3>⭐ Mejores Clientes</h3>
        <p style={{ fontSize: '0.875rem', color: '#666', marginBottom: '1rem' }}>
          Query: reports.queries.ts - topCustomers
        </p>
        <table>
          <thead>
            <tr>
              <th>Customer</th>
              <th>Email</th>
              <th>Orders</th>
              <th>Lifetime Value</th>
            </tr>
          </thead>
          <tbody>
            {topCustomers.map((customer: any) => (
              <tr key={customer.id}>
                <td>{customer.customer_name}</td>
                <td>{customer.email}</td>
                <td>{customer.order_count}</td>
                <td>${parseFloat(customer.lifetime_value).toFixed(2)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

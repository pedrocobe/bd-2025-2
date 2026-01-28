import { useState, useEffect } from 'react';
import axios from 'axios';

export default function Customers() {
  const [customers, setCustomers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    loadCustomers();
  }, []);

  const loadCustomers = async () => {
    try {
      const response = await axios.get('/api/customers');
      setCustomers(response.data);
      setLoading(false);
    } catch (err: any) {
      setError(err.response?.data?.message || 'Error loading customers');
      setLoading(false);
    }
  };

  if (loading) return <div className="loading">Cargando...</div>;
  if (error) return <div className="error">{error}</div>;

  return (
    <div className="page">
      <div className="page-header">
        <h2>👥 Clientes</h2>
        <p>Query: customers.queries.ts - findAll</p>
      </div>

      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>City</th>
            <th>Total Spent</th>
            <th>Orders</th>
          </tr>
        </thead>
        <tbody>
          {customers.map((customer: any) => (
            <tr key={customer.id}>
              <td>{customer.id}</td>
              <td>{customer.first_name} {customer.last_name}</td>
              <td>{customer.email}</td>
              <td>{customer.city}, {customer.country}</td>
              <td>${parseFloat(customer.total_spent || 0).toFixed(2)}</td>
              <td>{customer.order_count || 0}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

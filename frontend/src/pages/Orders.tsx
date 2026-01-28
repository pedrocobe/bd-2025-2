import { useState, useEffect } from 'react';
import axios from 'axios';

export default function Orders() {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    loadOrders();
  }, []);

  const loadOrders = async () => {
    try {
      const response = await axios.get('/api/orders');
      setOrders(response.data);
      setLoading(false);
    } catch (err: any) {
      setError(err.response?.data?.message || 'Error loading orders');
      setLoading(false);
    }
  };

  if (loading) return <div className="loading">Cargando...</div>;
  if (error) return <div className="error">{error}</div>;

  return (
    <div className="page">
      <div className="page-header">
        <h2>🛒 Pedidos</h2>
        <p>Query: orders.queries.ts - findAll (con JOIN a customers)</p>
      </div>

      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Order Number</th>
            <th>Customer</th>
            <th>Status</th>
            <th>Total</th>
            <th>Date</th>
          </tr>
        </thead>
        <tbody>
          {orders.map((order: any) => (
            <tr key={order.id}>
              <td>{order.id}</td>
              <td>{order.order_number}</td>
              <td>{order.customer_name}</td>
              <td>
                <span style={{
                  padding: '0.25rem 0.5rem',
                  borderRadius: '4px',
                  background: order.status === 'delivered' ? '#d4edda' : '#fff3cd',
                  textTransform: 'capitalize'
                }}>
                  {order.status}
                </span>
              </td>
              <td>${parseFloat(order.total).toFixed(2)}</td>
              <td>{new Date(order.created_at).toLocaleDateString()}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

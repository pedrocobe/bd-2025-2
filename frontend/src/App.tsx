import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import Home from './pages/Home';
import Users from './pages/Users';
import Products from './pages/Products';
import Customers from './pages/Customers';
import Orders from './pages/Orders';
import Reports from './pages/Reports';
import './App.css';

function App() {
  return (
    <Router>
      <div className="app">
        <nav className="navbar">
          <div className="nav-brand">
            <h1>🎓 Examen E-commerce</h1>
            <p>Interfaz de Pruebas de Base de Datos</p>
          </div>
          <ul className="nav-menu">
            <li><Link to="/">Inicio</Link></li>
            <li><Link to="/users">Usuarios</Link></li>
            <li><Link to="/products">Productos</Link></li>
            <li><Link to="/customers">Clientes</Link></li>
            <li><Link to="/orders">Pedidos</Link></li>
            <li><Link to="/reports">Reportes</Link></li>
          </ul>
        </nav>

        <main className="main-content">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/users" element={<Users />} />
            <Route path="/products" element={<Products />} />
            <Route path="/customers" element={<Customers />} />
            <Route path="/orders" element={<Orders />} />
            <Route path="/reports" element={<Reports />} />
          </Routes>
        </main>
      </div>
    </Router>
  );
}

export default App;

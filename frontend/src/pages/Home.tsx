export default function Home() {
  return (
    <div className="page">
      <div className="page-header">
        <h2>🎓 Examen de Base de Datos</h2>
        <p>Sistema de E-commerce - Interfaz de Pruebas</p>
      </div>

      <div className="card">
        <h3>📋 Instrucciones</h3>
        <p>Esta interfaz te permite probar las queries SQL que has implementado.</p>
        <ul style={{ marginTop: '1rem', marginLeft: '1.5rem' }}>
          <li>Navega por los diferentes módulos usando el menú superior</li>
          <li>Prueba las operaciones CRUD y reportes</li>
          <li>Si ves errores, revisa tus queries SQL</li>
          <li>Ejecuta los tests automáticos: <code>npm test</code></li>
        </ul>
      </div>

      <div className="card" style={{ marginTop: '1rem', background: '#fff8e1' }}>
        <h3>⚠️ Importante</h3>
        <p>Asegúrate de haber:</p>
        <ol style={{ marginTop: '1rem', marginLeft: '1.5rem' }}>
          <li>Creado el esquema de base de datos (schema.sql)</li>
          <li>Insertado datos de prueba (seed.sql)</li>
          <li>Completado las queries en los archivos .queries.ts</li>
          <li>Implementado funciones y triggers</li>
        </ol>
      </div>

      <div className="grid" style={{ marginTop: '2rem' }}>
        <div className="stat-card">
          <h3>6</h3>
          <p>Módulos</p>
        </div>
        <div className="stat-card">
          <h3>81</h3>
          <p>Pruebas Totales</p>
        </div>
        <div className="stat-card">
          <h3>100</h3>
          <p>Puntos Máximos</p>
        </div>
      </div>
    </div>
  );
}

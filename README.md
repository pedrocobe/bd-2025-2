# 🎓 Examen de Base de Datos - E-commerce API

## 📖 Descripción del Proyecto

Este es un proyecto de examen para la materia de **Bases de Datos**. El objetivo es que **escribas ÚNICAMENTE código SQL** para hacer funcionar una aplicación de e-commerce completa.

**El proyecto ya está construido**, tú solo debes:
- ✅ Diseñar el esquema de base de datos
- ✅ Escribir las consultas SQL
- ✅ Crear funciones y triggers
- ✅ Configurar permisos

**NO necesitas programar nada en TypeScript, JavaScript o React.**

---

## 🎯 ¿Qué debo hacer EXACTAMENTE?

Tu tarea es **llenar ÚNICAMENTE archivos SQL**. Nada más.

### 📁 **Archivos que DEBES completar:**

```
database-student/
├── schema.sql       ← Crear TODAS las tablas (PKs, FKs, constraints)
├── seed.sql         ← Insertar datos de prueba
├── functions.sql    ← Crear 8 funciones PL/pgSQL
├── triggers.sql     ← Crear 9 triggers
└── permissions.sql  ← Crear roles y permisos (GRANT/REVOKE)

backend/src/database/queries/
├── users.queries.ts     ← ~15 queries SQL para usuarios
├── products.queries.ts  ← ~20 queries SQL para productos
└── reports.queries.ts   ← ~6 queries SQL complejos de reportería
```

**Total: 8 archivos con SQL puro.**

---

## 💻 Requisitos Previos (Instalación en tu Computadora)

**ANTES de clonar el proyecto**, asegúrate de tener instalado lo siguiente:

> 📋 **¿Necesitas ayuda verificando la instalación?** Lee: [VERIFICAR_INSTALACION.md](VERIFICAR_INSTALACION.md)

### ✅ Software Obligatorio

| Software | Versión Mínima | Para qué se usa | Link de descarga |
|----------|----------------|-----------------|------------------|
| **Node.js** | 18.0 o superior | Ejecutar backend y frontend | [nodejs.org](https://nodejs.org/) |
| **npm** | 9.0 o superior | Gestor de paquetes (viene con Node.js) | Incluido con Node.js |
| **Docker Desktop** | Última versión | Correr PostgreSQL en contenedor | [docker.com](https://www.docker.com/products/docker-desktop/) |
| **Git** | Cualquier versión | Clonar el repositorio | [git-scm.com](https://git-scm.com/) |

### 🔍 Verificar Instalación

Antes de continuar, verifica que todo esté instalado:

```bash
# Verificar Node.js
node --version
# Debe mostrar: v18.x.x o superior

# Verificar npm
npm --version
# Debe mostrar: 9.x.x o superior

# Verificar Docker
docker --version
# Debe mostrar: Docker version 20.x.x o superior

# Verificar Docker Compose
docker compose version
# O: docker-compose --version
# Debe mostrar: Docker Compose version v2.x.x o superior

# Verificar Git
git --version
# Debe mostrar: git version 2.x.x
```

**Si algún comando falla, instala el software faltante antes de continuar.**

### 📝 Recomendaciones Adicionales

| Software | Obligatorio | Para qué |
|----------|-------------|----------|
| **VS Code** | No (pero recomendado) | Editor de código con extensiones SQL |
| **TablePlus / DBeaver** | No (opcional) | Explorar base de datos visualmente |
| **Postman** | No (opcional) | Probar APIs (también puedes usar Swagger) |
| **psql** (PostgreSQL Client) | No (opcional) | Conectarte a PostgreSQL desde terminal |

---

## 🚀 Instalación Rápida

### 1️⃣ Clonar el proyecto

```bash
git clone <url-del-repo>
cd examenes2025-2
```

### 2️⃣ Instalar dependencias del proyecto

**IMPORTANTE:** Este paso puede tardar 5-10 minutos la primera vez.

```bash
# Opción A: Instalar todo automáticamente (recomendado)
./preparar-entorno.sh

# Opción B: Instalar manualmente
# Backend
cd backend
npm install

# Frontend
cd ../frontend
npm install
cd ..
```

Si ves errores de dependencias, son normales. Solo importa que termine con "✓ Dependencias instaladas".

### 3️⃣ Verificar que Docker esté corriendo

**⚠️ IMPORTANTE:** Docker Desktop debe estar abierto y corriendo.

```bash
# Verificar que Docker esté activo
docker ps
```

Si ves un error "Cannot connect to the Docker daemon", **abre Docker Desktop** y espera a que se inicie.

### 4️⃣ Iniciar PostgreSQL con Docker

```bash
cd backend

# Usa el comando que tengas disponible:
docker-compose up -d
# O: docker compose up -d
```

Esto inicia PostgreSQL en el **puerto 5435** con:
- Base de datos: `ecommerce_exam`
- Usuario: `postgres`
- Password: `postgres`

**Verificar que PostgreSQL esté corriendo:**

```bash
docker ps
# Debes ver "postgres_exam" en la lista
```

> **Nota sobre puertos:** Usamos puerto 5435 para no interferir con PostgreSQL local (puerto 5432). Si tienes PostgreSQL instalado localmente, ambos pueden coexistir sin problemas.

---

## 🎭 PASO 1: Ver el Sistema Funcionando (OBLIGATORIO ANTES DE EMPEZAR)

**⚠️ MUY IMPORTANTE:** Antes de escribir una sola línea de SQL, **debes explorar el sistema completo** usando el modo de demostración (mocks).

### ¿Por qué usar el modo mock primero?

El modo mock (datos simulados) te permite:

1. ✅ **Ver la aplicación web completa funcionando** sin necesidad de base de datos
2. ✅ **Entender la estructura del proyecto** y cómo están organizados los módulos
3. ✅ **Explorar la interfaz visual** para saber qué funcionalidades debes implementar
4. ✅ **Revisar la documentación de las APIs** en Swagger para ver todos los endpoints
5. ✅ **Entender qué datos debe retornar cada query** al ver los mocks
6. ✅ **Identificar las relaciones entre tablas** observando cómo se conectan los datos
7. ✅ **Planificar tu esquema de base de datos** antes de escribir código

**Es IMPOSIBLE hacer bien el examen sin explorar primero el sistema con mocks.**

### Activar modo demostración

El archivo `backend/.env` debe tener:

```bash
USE_MOCKS=true
```

Por defecto ya viene activado, **NO lo cambies hasta que hayas explorado todo**.

### Iniciar el sistema

```bash
# Terminal 1 - Backend (API)
cd backend
npm run start:dev

# Terminal 2 - Frontend (Aplicación Web)
cd frontend
npm run dev
```

Espera unos segundos hasta ver:

```
✓ Backend corriendo en http://localhost:3000
✓ Frontend corriendo en http://localhost:5173
```

### 🌐 Explorar la Aplicación Web

**Abre:** http://localhost:5173

Navega por TODAS estas páginas:

| Página | URL | Qué explorar |
|--------|-----|--------------|
| **Login** | `/login` | Sistema de autenticación, campos requeridos |
| **Usuarios** | `/users` | Lista, crear, editar, eliminar usuarios |
| **Productos** | `/products` | Gestión de inventario, categorías, precios |
| **Clientes** | `/customers` | Base de clientes, estadísticas |
| **Pedidos** | `/orders` | Sistema de órdenes, estados, detalles |
| **Reportes** | `/reports` | Gráficas de ventas, estadísticas, análisis |

**Prueba TODAS las funcionalidades:**
- ✅ Crear registros
- ✅ Editar registros
- ✅ Eliminar registros
- ✅ Buscar/filtrar
- ✅ Ver detalles
- ✅ Cambiar páginas
- ✅ Ordenar columnas

**Observa qué datos muestra cada pantalla** - esto te dice qué campos necesitas en tus tablas.

### 📚 Explorar la Documentación de APIs

**Abre:** http://localhost:3000/api (Swagger Documentation)

Aquí verás TODOS los endpoints que debes implementar con SQL:

| Módulo | Endpoints | Qué revisar |
|--------|-----------|-------------|
| **Auth** | `/auth/login`, `/auth/profile` | Autenticación y JWT |
| **Users** | `/users`, `/users/:id`, `/users/search` | CRUD completo, búsquedas |
| **Categories** | `/categories`, `/categories/hierarchy` | Categorías con jerarquía |
| **Products** | `/products`, `/products/top-selling` | Inventario, reportes |
| **Customers** | `/customers`, `/customers/top` | Clientes y estadísticas |
| **Orders** | `/orders`, `/orders/status/:status` | Pedidos y estados |
| **Reports** | `/reports/daily-sales`, `/reports/dashboard` | Reportería compleja |

**Para cada endpoint:**
1. Haz clic en el endpoint
2. Haz clic en "Try it out"
3. Haz clic en "Execute"
4. **Revisa la respuesta** - así debes estructurar tus queries SQL

**Ejemplo:** Si el endpoint `/products` retorna:

```json
{
  "id": 1,
  "name": "Laptop",
  "price": 999.99,
  "category_name": "Electronics",
  "stock_quantity": 50
}
```

Tu query SQL debe retornar exactamente esos campos:
```sql
SELECT p.id, p.name, p.price, c.name AS category_name, p.stock_quantity
FROM products p
JOIN categories c ON p.category_id = c.id
```

### 🔍 Explorar el Código del Proyecto

Aunque **NO debes modificar** el código de la aplicación, **SÍ debes explorarlo** para entender la estructura:

#### Backend (`backend/src/`)

```bash
backend/src/
├── auth/              # ← Revisa: Cómo funciona la autenticación
├── users/             # ← Revisa: Qué operaciones hace con usuarios
├── products/          # ← Revisa: Qué campos necesita products
├── orders/            # ← Revisa: Cómo se relacionan orders y order_items
└── database/queries/  # ← AQUÍ escribirás tu SQL
```

**Archivos importantes a revisar:**

1. `backend/src/users/users.service.ts` - Ve qué parámetros recibe cada función
2. `backend/src/products/dto/*.dto.ts` - Ve qué campos son obligatorios
3. `backend/src/database/queries/*.queries.ts` - Ve los TODOs que debes completar

#### Frontend (`frontend/src/`)

```bash
frontend/src/
├── pages/        # ← Revisa: Qué páginas existen y qué muestran
├── components/   # ← Revisa: Qué componentes se usan
└── services/     # ← Revisa: Qué llamadas hace a la API
```

### ⏱️ Tiempo Recomendado de Exploración

| Actividad | Tiempo | Importante |
|-----------|--------|------------|
| Explorar frontend web | 30 min | ⭐⭐⭐⭐⭐ |
| Revisar API en Swagger | 30 min | ⭐⭐⭐⭐⭐ |
| Ver código backend | 20 min | ⭐⭐⭐⭐ |
| Ver código frontend | 10 min | ⭐⭐⭐ |
| **TOTAL** | **90 min** | **Crítico** |

**NO SALTES ESTE PASO.** Los estudiantes que exploran primero obtienen mejores calificaciones.

### 📝 Toma Notas Mientras Exploras

Mientras navegas, anota:

- ✅ ¿Qué tablas necesitas? (usuarios, productos, categorías, etc.)
- ✅ ¿Qué relaciones hay? (producto → categoría, pedido → cliente)
- ✅ ¿Qué campos tiene cada tabla? (id, name, price, etc.)
- ✅ ¿Qué campos son obligatorios? (NOT NULL)
- ✅ ¿Qué campos deben ser únicos? (username, email, sku)
- ✅ ¿Qué validaciones hay? (price > 0, stock >= 0)
- ✅ ¿Qué queries complejas necesitas? (JOINs, GROUP BY, etc.)

### ⚠️ IMPORTANTE: Diferencia entre Mock y Real

| Con `USE_MOCKS=true` | Con `USE_MOCKS=false` |
|---------------------|----------------------|
| ✅ Sistema funciona SIN base de datos | ⚠️ Sistema NECESITA tu base de datos |
| ✅ Datos simulados en código | ⚠️ Datos reales de PostgreSQL |
| ✅ Perfecto para explorar | ⚠️ Perfecto para probar tu SQL |
| ❌ Tests NO funcionan | ✅ Tests SÍ funcionan |
| ✅ No necesitas Docker | ⚠️ Necesitas Docker corriendo |

**Solo cambia a `USE_MOCKS=false` cuando hayas terminado de explorar y estés listo para escribir SQL.**

### 🎬 Resumen Visual: ¿Qué Hacer con el Modo Mock?

```
┌─────────────────────────────────────────────────────────────┐
│  FASE 1: EXPLORACIÓN (90 minutos) - USE_MOCKS=true         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. Abre http://localhost:5173                              │
│     ↓                                                        │
│     └─> Navega por TODAS las páginas                        │
│         └─> Anota qué datos ves en cada pantalla           │
│                                                              │
│  2. Abre http://localhost:3000/api (Swagger)                │
│     ↓                                                        │
│     └─> Prueba TODOS los endpoints                          │
│         └─> Anota qué parámetros reciben                   │
│         └─> Anota qué respuestas retornan                  │
│                                                              │
│  3. Abre VS Code                                            │
│     ↓                                                        │
│     └─> Lee backend/src/users/users.service.ts             │
│     └─> Lee backend/src/database/queries/*.queries.ts      │
│     └─> Identifica qué queries debes escribir              │
│                                                              │
│  4. Diseña tu esquema en papel                              │
│     ↓                                                        │
│     └─> Dibuja todas las tablas                            │
│     └─> Dibuja las relaciones (FKs)                        │
│     └─> Define los campos de cada tabla                    │
│                                                              │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  FASE 2: IMPLEMENTACIÓN (4-6 horas) - USE_MOCKS=false      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  5. Escribe schema.sql                                      │
│     └─> Carga: docker exec -i postgres_exam psql ...       │
│                                                              │
│  6. Escribe seed.sql                                        │
│     └─> Carga: docker exec -i postgres_exam psql ...       │
│                                                              │
│  7. Escribe *.queries.ts                                    │
│     └─> Cambia USE_MOCKS=false en .env                     │
│     └─> Reinicia backend: npm run start:dev                │
│     └─> Prueba en frontend                                 │
│                                                              │
│  8. Escribe functions.sql y triggers.sql                    │
│     └─> Carga cada archivo                                 │
│                                                              │
│  9. Ejecuta tests: npm test                                 │
│     └─> Corrige errores                                     │
│     └─> Repite hasta 100%                                   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**⚠️ NO SALTES LA FASE 1.** Es la clave del éxito.

---

## 📝 PASO 2: Entender los Requisitos

Lee el archivo `database-student/REQUISITOS.md` que explica:
- Qué tablas necesitas crear
- Qué relaciones deben existir
- Qué constraints son necesarios
- Qué queries debes escribir

**Todos los archivos en `database-student/` tienen instrucciones detalladas en español.**

---

## 🎯 PASO 3: Completar los Archivos SQL

### A) Esquema de Base de Datos (30 puntos)

**Archivo:** `database-student/schema.sql`

**Qué hacer:** Crear TODAS las tablas necesarias:
- Usuarios (con autenticación)
- Categorías (con jerarquía)
- Productos (con inventario)
- Clientes
- Pedidos y detalles de pedidos

**Requisitos:**
- Primary Keys (PKs)
- Foreign Keys (FKs)
- Constraints: NOT NULL, UNIQUE, CHECK
- Índices para búsquedas frecuentes
- Tipos ENUM donde sea apropiado
- Timestamps (created_at, updated_at)

**Cargar tu schema:**

```bash
cd backend
docker exec -i postgres_exam psql -U postgres -d ecommerce_exam < ../database-student/schema.sql
```

---

### B) Datos de Prueba (Parte del esquema)

**Archivo:** `database-student/seed.sql`

**Qué hacer:** Insertar datos de ejemplo:
- Mínimo 4 usuarios (incluyendo un admin)
- Varias categorías con jerarquía
- Al menos 10 productos
- Algunos clientes
- Algunos pedidos de ejemplo

**Cargar datos:**

```bash
docker exec -i postgres_exam psql -U postgres -d ecommerce_exam < ../database-student/seed.sql
```

---

### C) Queries SQL en TypeScript (40 puntos)

**Archivos:**
- `backend/src/database/queries/users.queries.ts`
- `backend/src/database/queries/products.queries.ts`
- `backend/src/database/queries/reports.queries.ts`

**Qué hacer:** Llenar SOLO las strings de SQL.

**Ejemplo de lo que encuentras:**

```typescript
export const UsersQueries = {
  findAll: `
    // TODO: Query SQL aquí
    // Debe devolver: id, username, email, full_name, role, is_active, created_at
    // Ordenado por: created_at DESC
  `,
  
  findById: `
    // TODO: Query SQL aquí
    // Parámetro: $1 (id del usuario)
    // Debe devolver: todos los campos del usuario
  `,
  
  create: `
    // TODO: Query SQL aquí
    // Parámetros: $1=username, $2=email, $3=password_hash, $4=full_name, $5=role
    // Debe retornar: el usuario creado con RETURNING
  `,
};
```

**Lo que TÚ escribes:**

```typescript
export const UsersQueries = {
  findAll: `
    SELECT id, username, email, full_name, role, is_active, created_at
    FROM users
    ORDER BY created_at DESC
  `,
  
  findById: `
    SELECT id, username, email, full_name, role, is_active, created_at, last_login
    FROM users
    WHERE id = $1
  `,
  
  create: `
    INSERT INTO users (username, email, password_hash, full_name, role)
    VALUES ($1, $2, $3, $4, $5)
    RETURNING id, username, email, full_name, role, is_active, created_at
  `,
};
```

**Tipos de queries que debes escribir:**
- ✅ CRUD básico (INSERT, SELECT, UPDATE, DELETE)
- ✅ JOINs (INNER JOIN, LEFT JOIN)
- ✅ Búsquedas con LIKE/ILIKE
- ✅ Agregaciones (COUNT, SUM, AVG, GROUP BY, HAVING)
- ✅ Subconsultas
- ✅ RETURNING (para devolver datos insertados/actualizados)

---

### D) Funciones SQL (10 puntos)

**Archivo:** `database-student/functions.sql`

**Qué hacer:** Crear 8 funciones PL/pgSQL:
1. Calcular subtotal de pedido
2. Aplicar descuento
3. Calcular impuestos
4. Actualizar estadísticas de cliente
5. Verificar stock disponible
6. Margen de ganancia de producto
7. Días desde última compra
8. Valor total de inventario

El archivo tiene instrucciones detalladas para cada función.

**Cargar funciones:**

```bash
docker exec -i postgres_exam psql -U postgres -d ecommerce_exam < ../database-student/functions.sql
```

---

### E) Triggers (10 puntos)

**Archivo:** `database-student/triggers.sql`

**Qué hacer:** Crear 9 triggers:
- Validar stock antes de insertar order_item
- Actualizar stock después de crear pedido
- Actualizar timestamps automáticamente
- Validar precios positivos
- Auditoría de cambios
- Recalcular totales de pedidos
- etc.

El archivo tiene instrucciones detalladas para cada trigger.

**Cargar triggers:**

```bash
docker exec -i postgres_exam psql -U postgres -d ecommerce_exam < ../database-student/triggers.sql
```

---

### F) Permisos (10 puntos)

**Archivo:** `database-student/permissions.sql`

**Qué hacer:** Crear 4 roles con sus permisos:
- `db_admin`: Acceso total
- `db_manager`: Lectura/escritura en todas las tablas
- `db_employee`: Solo lectura en la mayoría, escritura limitada
- `db_readonly`: Solo lectura en todas las tablas

**Nota:** El sistema se conecta con el usuario `postgres`. Los roles que crees son para **demostrar tu conocimiento** de GRANT/REVOKE, no para la conexión del sistema.

**Cargar permisos:**

```bash
docker exec -i postgres_exam psql -U postgres -d ecommerce_exam < ../database-student/permissions.sql
```

---

## 🧪 PASO 4: Probar tu Trabajo

### Desactivar mocks

En `backend/.env` cambia:

```bash
USE_MOCKS=false
```

### Reiniciar el backend

```bash
cd backend
# Ctrl+C para detener el servidor anterior
npm run start:dev
```

### Probar manualmente

1. Abre http://localhost:5173
2. Intenta hacer login
3. Navega por todas las páginas
4. Verifica que las operaciones funcionen

### Ejecutar tests automáticos

```bash
cd backend
npm test
```

**Resultado esperado:**

```
PASS  test/users.e2e-spec.ts
PASS  test/products.e2e-spec.ts
PASS  test/reports.e2e-spec.ts

Tests:       24 passed, 24 total
✅ Todo correcto
```

**Si hay errores:**

```
FAIL  test/products.e2e-spec.ts
  ✗ should find products by category (89ms)
    
    Error: column "category_name" does not exist
```

Esto te indica exactamente qué falta en tu SQL.

---

## 📊 Criterios de Evaluación

| Parte | Puntos | Archivo(s) | Descripción |
|-------|--------|------------|-------------|
| **Esquema de BD** | 30 | schema.sql + seed.sql | Tablas, relaciones, constraints, datos |
| **Queries SQL** | 40 | *.queries.ts | CRUD, JOINs, agregaciones, reportes |
| **Funciones** | 10 | functions.sql | 8 funciones PL/pgSQL |
| **Triggers** | 10 | triggers.sql | 9 triggers de validación/auditoría |
| **Permisos** | 10 | permissions.sql | 4 roles con GRANT/REVOKE |
| **TOTAL** | **100** | 8 archivos | |

---

## 📚 Recursos Útiles

- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [SQL Tutorial](https://www.postgresqltutorial.com/)
- [JOINs Explicados](https://www.postgresql.org/docs/current/tutorial-join.html)
- [Funciones PL/pgSQL](https://www.postgresql.org/docs/current/plpgsql.html)
- [Triggers](https://www.postgresql.org/docs/current/trigger-definition.html)

---

## 🆘 Problemas Comunes

### PostgreSQL no inicia

```bash
cd backend
docker-compose down -v
docker-compose up -d
```

### Tests fallan con error de conexión

Verifica que PostgreSQL esté corriendo:

```bash
docker ps
# Debes ver "postgres_exam" en la lista
```

### Quiero reiniciar la base de datos

```bash
cd backend
docker-compose down -v
docker-compose up -d
sleep 10

# Volver a cargar
docker exec -i postgres_exam psql -U postgres -d ecommerce_exam < ../database-student/schema.sql
docker exec -i postgres_exam psql -U postgres -d ecommerce_exam < ../database-student/seed.sql
docker exec -i postgres_exam psql -U postgres -d ecommerce_exam < ../database-student/functions.sql
docker exec -i postgres_exam psql -U postgres -d ecommerce_exam < ../database-student/triggers.sql
docker exec -i postgres_exam psql -U postgres -d ecommerce_exam < ../database-student/permissions.sql
```

### Los tests pasan pero la nota es baja

Verifica que hayas completado:
- ✅ Todas las tablas en schema.sql
- ✅ Datos de prueba en seed.sql
- ✅ Todas las funciones en functions.sql
- ✅ Todos los triggers en triggers.sql
- ✅ Los permisos en permissions.sql

---

## ✅ Checklist Final

Antes de entregar, verifica:

- [ ] `schema.sql` tiene TODAS las tablas con PKs, FKs, constraints
- [ ] `seed.sql` tiene datos de prueba suficientes
- [ ] `users.queries.ts` tiene ~15 queries completadas
- [ ] `products.queries.ts` tiene ~20 queries completadas
- [ ] `reports.queries.ts` tiene ~6 queries completadas
- [ ] `functions.sql` tiene las 8 funciones
- [ ] `triggers.sql` tiene los 9 triggers
- [ ] `permissions.sql` tiene los 4 roles configurados
- [ ] `npm test` pasa todos los tests
- [ ] La aplicación funciona en http://localhost:5173 con `USE_MOCKS=false`

---

## 📦 Entrega del Examen

### 🔀 **Método de Entrega: Git Branch**

**IMPORTANTE:** La entrega se hace mediante una rama (branch) de Git con un nombre específico.

#### Paso 1: Crear tu rama personal

```bash
# Asegúrate de estar en la rama main
git checkout main

# Crea tu rama con el formato: student/nombre_apellido_cedula
# Ejemplo: student/juan_perez_1234567890
git checkout -b student/TU_NOMBRE_TU_APELLIDO_TU_CEDULA

# Verifica que estás en tu rama
git branch
# Debe mostrar: * student/tu_nombre_tu_apellido_tu_cedula
```

#### Paso 2: Hacer commit de tus cambios

```bash
# Agregar SOLO los archivos que modificaste
git add database-student/schema.sql
git add database-student/seed.sql
git add database-student/functions.sql
git add database-student/triggers.sql
git add database-student/permissions.sql
git add backend/src/database/queries/users.queries.ts
git add backend/src/database/queries/products.queries.ts
git add backend/src/database/queries/reports.queries.ts

# Hacer commit
git commit -m "Solución examen - [TU NOMBRE COMPLETO]"
```

#### Paso 3: Subir tu rama al repositorio

```bash
# Subir tu rama
git push origin student/TU_NOMBRE_TU_APELLIDO_TU_CEDULA
```

### ✅ **Checklist de Entrega**

Antes de hacer push, verifica:

- [ ] El nombre de tu rama sigue el formato: `student/nombre_apellido_cedula`
- [ ] Hiciste commit de los 8 archivos (5 .sql + 3 .queries.ts)
- [ ] NO incluiste node_modules ni archivos innecesarios
- [ ] Ejecutaste `npm test` localmente y verificaste tu calificación
- [ ] Tu commit tiene un mensaje descriptivo con tu nombre

### 📋 **Archivos que DEBES entregar:**

```
database-student/
├── schema.sql          ✅
├── seed.sql            ✅
├── functions.sql       ✅
├── triggers.sql        ✅
└── permissions.sql     ✅

backend/src/database/queries/
├── users.queries.ts    ✅
├── products.queries.ts ✅
└── reports.queries.ts  ✅
```

**Total: 8 archivos**

### ❌ **NO entregues:**

- node_modules/
- .env (ya está configurado)
- Código de servicios, controllers o componentes
- Documentación o archivos del profesor
- Logs o archivos temporales

### 🚨 **Advertencias Importantes:**

1. **Nombre de rama incorrecto = NO SE CALIFICA**
   - Formato correcto: `student/nombre_apellido_cedula`
   - TODO en minúsculas, separado por guiones bajos
   - Ejemplo: `student/maria_garcia_9876543210`

2. **Un solo commit por estudiante**
   - Haz un solo commit con todos tus cambios
   - Si necesitas corregir, haz otro commit en la MISMA rama

3. **No modificar main**
   - NUNCA hagas push a `main`
   - SIEMPRE trabaja en tu rama personal

4. **Deadline**
   - Después de la fecha límite, NO se aceptan cambios
   - Asegúrate de hacer push antes del deadline

---

## 🎯 **Ejemplo Completo de Entrega:**

```bash
# 1. Clonar el repositorio
git clone <url-del-repositorio>
cd examenes2025-2

# 2. Instalar y desarrollar
npm install
# ... trabajar en los archivos SQL ...

# 3. Probar localmente
cd backend
npm test

# 4. Crear rama personal
git checkout -b student/carlos_lopez_1122334455

# 5. Agregar archivos
git add database-student/*.sql
git add backend/src/database/queries/*.queries.ts

# 6. Commit
git commit -m "Solución examen - Carlos López - CI: 1122334455"

# 7. Push
git push origin student/carlos_lopez_1122334455

# 8. ✅ ¡Listo! El profesor revisará tu rama
```

---

## 🎯 ¡Buena suerte!

Recuerda:
1. **Explora primero** con mocks activados
2. **Lee los requisitos** en cada archivo
3. **Escribe SQL limpio** y comentado
4. **Prueba con tests** antes de entregar
5. **Consulta la documentación** de PostgreSQL cuando tengas dudas

**¡Todo lo que necesitas saber está en los comentarios de cada archivo!**

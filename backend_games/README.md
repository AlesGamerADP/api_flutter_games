# API de Juegos - Backend con Node.js y Supabase

API REST desarrollada con Node.js y Express que utiliza Supabase como base de datos para gestionar una colección de juegos. La API permite realizar operaciones CRUD (Crear, Leer, Actualizar, Eliminar) sobre juegos con información como nombre, género, plataforma, descripción, año de lanzamiento e imagen.

## Tecnologías Utilizadas

### Express
Framework web para Node.js que facilita la creación de servidores HTTP y el manejo de rutas. Express permite definir endpoints REST de manera sencilla y manejar peticiones HTTP (GET, POST, PUT, DELETE).

### Supabase
Plataforma de backend como servicio que proporciona una base de datos PostgreSQL gestionada. Utilizamos el cliente de JavaScript de Supabase para interactuar con la base de datos desde Node.js. Supabase maneja la autenticación, el almacenamiento y las consultas SQL.

### CORS
Middleware que permite que aplicaciones web en diferentes dominios puedan hacer peticiones a esta API. Es necesario cuando el frontend (Flutter) se ejecuta en un origen diferente al del servidor.

### dotenv
Librería que carga variables de entorno desde un archivo .env. Permite configurar credenciales y configuraciones sin hardcodearlas en el código, mejorando la seguridad.

### nodemon
Herramienta de desarrollo que reinicia automáticamente el servidor cuando detecta cambios en los archivos. Facilita el desarrollo al no tener que reiniciar manualmente el servidor después de cada modificación.

## Estructura del Proyecto

```
backend_games/
├── config/
│   └── supabase.js          # Configuración del cliente de Supabase
├── routes/
│   └── games.js             # Rutas de la API para operaciones CRUD
├── index.js                 # Archivo principal del servidor
├── package.json             # Dependencias y scripts del proyecto
├── supabase_setup.sql       # Script SQL para crear la tabla en Supabase
└── .env                     # Variables de entorno (no se incluye en el repositorio)
```

## Instalación

1. Instala las dependencias del proyecto:
```bash
npm install
```

Este comando lee el archivo package.json e instala todas las dependencias listadas en la sección dependencies y devDependencies.

2. Crea un archivo `.env` en la raíz del proyecto con las siguientes variables:
```
SUPABASE_URL=tu_url_de_supabase
SUPABASE_KEY=tu_clave_api_de_supabase
PORT=3000
```

Las variables de entorno son necesarias para:
- SUPABASE_URL: La URL de tu proyecto en Supabase (se obtiene del dashboard)
- SUPABASE_KEY: La clave API pública (anon key) de Supabase para autenticación
- PORT: El puerto donde el servidor escuchará las peticiones (por defecto 3000)

## Configuración de Supabase

### Crear la Base de Datos

1. Crea una cuenta en Supabase (https://supabase.com) y crea un nuevo proyecto.

2. Ve al SQL Editor en el dashboard de Supabase.

3. Ejecuta el script SQL que se encuentra en `supabase_setup.sql` o ejecuta manualmente:

```sql
CREATE TABLE juegos (
  id BIGSERIAL PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  genero VARCHAR(100) NOT NULL,
  plataforma VARCHAR(100) NOT NULL,
  descripcion TEXT NOT NULL,
  año_lanzamiento INTEGER NOT NULL,
  imagen_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);
```

Este script crea una tabla llamada "juegos" con los siguientes campos:
- id: Identificador único autoincremental (BIGSERIAL)
- nombre: Nombre del juego (máximo 255 caracteres, requerido)
- genero: Género del juego (máximo 100 caracteres, requerido)
- plataforma: Plataforma donde está disponible (máximo 100 caracteres, requerido)
- descripcion: Descripción del juego (texto largo, requerido)
- año_lanzamiento: Año en que se lanzó el juego (número entero, requerido)
- imagen_url: URL de la imagen del juego (opcional)
- created_at: Fecha y hora de creación (se asigna automáticamente)
- updated_at: Fecha y hora de última actualización (se asigna automáticamente)

4. Obtén las credenciales de tu proyecto:
   - Ve a Settings > API en el dashboard de Supabase
   - Copia la "Project URL" y úsala como SUPABASE_URL
   - Copia la "anon public" key y úsala como SUPABASE_KEY

## Uso

Inicia el servidor con:
```bash
npm start
```

Este comando ejecuta nodemon que a su vez ejecuta index.js. El servidor se reiniciará automáticamente cuando modifiques archivos.

El servidor estará disponible en `http://localhost:3000` (o el puerto que hayas configurado en PORT).

## Endpoints de la API

La API expone los siguientes endpoints bajo la ruta base `/api/games`:

### GET /api/games
Obtiene todos los juegos almacenados en la base de datos, ordenados por año de lanzamiento de forma descendente (más recientes primero).

**Respuesta exitosa (200):**
```json
[
  {
    "id": 1,
    "nombre": "Ejemplo",
    "genero": "Acción",
    "plataforma": "PC",
    "descripcion": "Descripción del juego",
    "año_lanzamiento": 2023,
    "imagen_url": "https://ejemplo.com/imagen.jpg",
    "created_at": "2024-01-01T00:00:00.000Z",
    "updated_at": "2024-01-01T00:00:00.000Z"
  }
]
```

### GET /api/games/:id
Obtiene un juego específico por su ID.

**Parámetros:**
- id: Identificador numérico del juego

**Respuesta exitosa (200):**
```json
{
  "id": 1,
  "nombre": "Ejemplo",
  "genero": "Acción",
  "plataforma": "PC",
  "descripcion": "Descripción del juego",
  "año_lanzamiento": 2023,
  "imagen_url": "https://ejemplo.com/imagen.jpg"
}
```

**Respuesta de error (404):**
```json
{
  "error": "Juego no encontrado"
}
```

### POST /api/games
Crea un nuevo juego en la base de datos.

**Body requerido (JSON):**
```json
{
  "nombre": "Nombre del juego",
  "genero": "Género",
  "plataforma": "Plataforma",
  "descripcion": "Descripción del juego",
  "año_lanzamiento": 2023,
  "imagen_url": "https://ejemplo.com/imagen.jpg"
}
```

**Campos requeridos:**
- nombre: String, no puede estar vacío
- genero: String, no puede estar vacío
- plataforma: String, no puede estar vacío
- descripcion: String, no puede estar vacío
- año_lanzamiento: Number, año válido

**Campos opcionales:**
- imagen_url: String, URL de la imagen

**Respuesta exitosa (201):**
```json
{
  "id": 1,
  "nombre": "Nombre del juego",
  "genero": "Género",
  "plataforma": "Plataforma",
  "descripcion": "Descripción del juego",
  "año_lanzamiento": 2023,
  "imagen_url": "https://ejemplo.com/imagen.jpg"
}
```

**Respuesta de error (400):**
```json
{
  "error": "Faltan campos requeridos: nombre, genero, plataforma, descripcion, año_lanzamiento"
}
```

### PUT /api/games/:id
Actualiza un juego existente. Solo se actualizan los campos que se envíen en el body.

**Parámetros:**
- id: Identificador numérico del juego a actualizar

**Body (JSON, todos los campos son opcionales):**
```json
{
  "nombre": "Nuevo nombre",
  "genero": "Nuevo género",
  "plataforma": "Nueva plataforma",
  "descripcion": "Nueva descripción",
  "año_lanzamiento": 2024,
  "imagen_url": "https://ejemplo.com/nueva-imagen.jpg"
}
```

**Respuesta exitosa (200):**
```json
{
  "id": 1,
  "nombre": "Nuevo nombre",
  "genero": "Nuevo género",
  "plataforma": "Nueva plataforma",
  "descripcion": "Nueva descripción",
  "año_lanzamiento": 2024,
  "imagen_url": "https://ejemplo.com/nueva-imagen.jpg"
}
```

**Respuesta de error (404):**
```json
{
  "error": "Juego no encontrado"
}
```

### DELETE /api/games/:id
Elimina un juego de la base de datos.

**Parámetros:**
- id: Identificador numérico del juego a eliminar

**Respuesta exitosa (200):**
```json
{
  "message": "Juego eliminado correctamente"
}
```

**Respuesta de error (400):**
```json
{
  "error": "Mensaje de error de Supabase"
}
```

## Manejo de Errores

La API maneja errores de las siguientes maneras:

1. Errores de validación: Retorna código 400 con un mensaje descriptivo cuando faltan campos requeridos.

2. Errores de base de datos: Retorna código 400 o 404 dependiendo del tipo de error que Supabase retorne.

3. Errores del servidor: Retorna código 500 con un mensaje genérico para errores internos.

Todos los errores se retornan en formato JSON con un campo "error" que contiene el mensaje descriptivo.

## CORS

La API está configurada para aceptar peticiones desde cualquier origen mediante el middleware CORS. Esto permite que aplicaciones frontend en diferentes dominios puedan consumir la API sin problemas de política de mismo origen.

## Variables de Entorno

El proyecto utiliza dotenv para cargar variables de entorno desde el archivo .env. Estas variables son:

- SUPABASE_URL: URL del proyecto en Supabase
- SUPABASE_KEY: Clave API pública de Supabase
- PORT: Puerto donde el servidor escuchará (opcional, por defecto 3000)

Es importante no subir el archivo .env al repositorio ya que contiene información sensible. El archivo .gitignore ya está configurado para excluirlo.

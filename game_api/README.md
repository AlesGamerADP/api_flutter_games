# GameHub - Aplicación Flutter

Aplicación móvil desarrollada con Flutter que consume la API REST de juegos. Permite gestionar una colección de juegos mediante operaciones CRUD (Crear, Leer, Actualizar, Eliminar) con una interfaz de usuario moderna y responsive.

## Tecnologías Utilizadas

### Flutter
Framework de desarrollo multiplataforma de Google que permite crear aplicaciones nativas para iOS, Android, Web y Desktop desde un solo código base. Utilizamos Flutter para crear la interfaz de usuario y manejar la lógica de la aplicación.

### Dart
Lenguaje de programación utilizado por Flutter. Dart es un lenguaje orientado a objetos con tipado estático que compila a código nativo para diferentes plataformas.

### HTTP Package
Paquete de Flutter que proporciona funcionalidades para realizar peticiones HTTP. Utilizamos este paquete para comunicarnos con la API REST del backend, enviando y recibiendo datos en formato JSON.

### Material Design 3
Sistema de diseño de Google implementado en Flutter. Utilizamos Material Design 3 para crear una interfaz consistente y moderna con componentes predefinidos como AppBar, Cards, TextFields, y botones.

## Estructura del Proyecto

```
lib/
├── config/
│   └── api_config.dart          # Configuración de la URL base de la API
├── models/
│   └── game.dart                # Modelo de datos que representa un juego
├── screens/
│   ├── games_list_screen.dart   # Pantalla principal que muestra la lista de juegos
│   ├── game_form_screen.dart    # Pantalla para crear o editar un juego
│   └── game_detail_screen.dart  # Pantalla que muestra los detalles de un juego
├── services/
│   └── game_service.dart        # Servicio que contiene los métodos para consumir la API
└── main.dart                     # Punto de entrada de la aplicación
```

## Instalación

1. Asegúrate de tener Flutter instalado en tu sistema. Puedes descargarlo desde https://flutter.dev

2. Verifica la instalación ejecutando:
```bash
flutter doctor
```

3. Instala las dependencias del proyecto:
```bash
flutter pub get
```

Este comando lee el archivo pubspec.yaml e instala todas las dependencias listadas. Las dependencias principales son:
- flutter: SDK de Flutter
- http: Para realizar peticiones HTTP a la API
- cupertino_icons: Iconos de estilo iOS

## Configuración

Antes de ejecutar la aplicación, debes configurar la URL de la API en el archivo `lib/config/api_config.dart`.

Abre el archivo y modifica la constante `baseUrl` según tu entorno:

```dart
static const String baseUrl = 'http://localhost:3000/api/games';
```

Configuraciones según el entorno:

- Android Emulador: `http://10.0.2.2:3000/api/games`
  - El emulador de Android usa 10.0.2.2 para referirse a localhost de la máquina host

- iOS Simulador: `http://localhost:3000/api/games`
  - El simulador de iOS puede acceder directamente a localhost

- Dispositivo Físico: `http://TU_IP_LOCAL:3000/api/games`
  - Reemplaza TU_IP_LOCAL con la dirección IP local de tu computadora
  - Para encontrar tu IP local:
    - Windows: Ejecuta `ipconfig` en la terminal y busca "IPv4 Address"
    - Mac/Linux: Ejecuta `ifconfig` o `ip addr` y busca la dirección IP de tu interfaz de red

## Ejecutar la Aplicación

Para ejecutar la aplicación en modo desarrollo:

```bash
flutter run
```

Este comando compila y ejecuta la aplicación en un dispositivo conectado o emulador disponible.

## Funcionalidades

### Listar Juegos
La pantalla principal muestra una lista de todos los juegos almacenados en la base de datos. Cada juego se muestra en una card con:
- Imagen del juego (si está disponible)
- Nombre del juego
- Género y plataforma en badges de colores
- Año de lanzamiento
- Menú de opciones (tres puntos) para editar o eliminar

Puedes hacer pull-to-refresh para actualizar la lista.

### Ver Detalles de un Juego
Al hacer tap en una card de juego, se abre la pantalla de detalles que muestra:
- Imagen grande del juego en el header
- Badges de género y plataforma
- Año de lanzamiento
- Descripción completa
- Fechas de creación y actualización (si están disponibles)

### Crear un Nuevo Juego
Presiona el botón flotante "Nuevo Juego" para abrir el formulario. El formulario incluye campos para:
- Nombre del juego (requerido)
- Género (requerido)
- Plataforma (requerido)
- Descripción (requerido)
- Año de lanzamiento (requerido, debe ser un año válido entre 1970 y el año actual + 1)
- URL de imagen (opcional)

Todos los campos tienen validación y mostrarán mensajes de error si no se completan correctamente.

### Editar un Juego
Desde el menú de tres puntos en cada card, selecciona "Editar" para modificar un juego existente. El formulario se pre-llena con los datos actuales del juego y permite modificar cualquier campo.

### Eliminar un Juego
Desde el menú de tres puntos, selecciona "Eliminar". Se mostrará un diálogo de confirmación antes de eliminar el juego permanentemente.

## Modelo de Datos

El modelo `Game` representa un juego con los siguientes campos:

- id: Identificador único (int, opcional al crear)
- nombre: Nombre del juego (String, requerido)
- genero: Género del juego (String, requerido)
- plataforma: Plataforma donde está disponible (String, requerido)
- descripcion: Descripción del juego (String, requerido)
- anioLanzamiento: Año de lanzamiento (int, requerido)
- imagenUrl: URL de la imagen (String, opcional)
- createdAt: Fecha de creación (DateTime, opcional)
- updatedAt: Fecha de última actualización (DateTime, opcional)

El modelo incluye métodos para convertir entre JSON y objetos Dart:
- `fromJson`: Crea un objeto Game desde un mapa JSON
- `toJson`: Convierte un objeto Game a un mapa JSON

## Servicio de API

El archivo `game_service.dart` contiene la clase `GameService` que encapsula todas las operaciones de comunicación con la API:

- `getGames()`: Obtiene todos los juegos
- `getGameById(int id)`: Obtiene un juego por su ID
- `createGame(Game game)`: Crea un nuevo juego
- `updateGame(int id, Game game)`: Actualiza un juego existente
- `deleteGame(int id)`: Elimina un juego

Cada método maneja las peticiones HTTP, convierte los datos entre JSON y objetos Dart, y lanza excepciones con mensajes descriptivos en caso de error.

## Manejo de Errores

La aplicación maneja errores de las siguientes maneras:

1. Errores de conexión: Muestra un mensaje indicando que no se pudo conectar con el servidor. Incluye un botón para reintentar.

2. Errores de validación: Los campos del formulario muestran mensajes de error específicos cuando la validación falla.

3. Errores del servidor: Muestra mensajes de error en SnackBars (notificaciones en la parte inferior de la pantalla) cuando las operaciones fallan.

4. Estado vacío: Muestra un mensaje amigable cuando no hay juegos en la lista.

## Tema y Diseño

La aplicación utiliza un tema oscuro con los siguientes colores principales:

- Color primario: Indigo (#6366F1)
- Color secundario: Púrpura (#8B5CF6)
- Fondo: Gris oscuro (#111827)
- Superficie: Gris medio (#1F2937)

El diseño es minimalista y moderno, con cards redondeadas, espaciado consistente y tipografía clara. La interfaz es responsive y se adapta a diferentes tamaños de pantalla.

## Requisitos Previos

Antes de usar la aplicación, asegúrate de que:

1. El servidor backend esté corriendo y accesible desde tu dispositivo o emulador
2. La URL de la API esté correctamente configurada en `api_config.dart`
3. El backend tenga la tabla de juegos creada en Supabase
4. Las credenciales de Supabase estén configuradas en el backend

## Notas Importantes

- La aplicación requiere conexión a internet para comunicarse con la API
- Las imágenes se cargan desde URLs externas, asegúrate de que las URLs sean válidas
- Para dispositivos físicos, tanto el dispositivo como la computadora deben estar en la misma red WiFi
- El año de lanzamiento debe ser un número entre 1970 y el año actual más uno

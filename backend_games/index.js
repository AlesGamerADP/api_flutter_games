const express = require('express');
const cors = require('cors');
require('dotenv').config();

const gamesRoutes = require('./routes/games');

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Rutas
app.use('/api/games', gamesRoutes);

// Ruta de prueba
app.get('/', (req, res) => {
  res.json({ 
    message: 'API de Juegos funcionando correctamente',
    endpoints: {
      'GET /api/games': 'Obtener todos los juegos',
      'GET /api/games/:id': 'Obtener un juego por ID',
      'POST /api/games': 'Crear un nuevo juego',
      'PUT /api/games/:id': 'Actualizar un juego',
      'DELETE /api/games/:id': 'Eliminar un juego'
    }
  });
});

// Manejo de errores
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Error interno del servidor' });
});

app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});


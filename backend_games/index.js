const express = require('express');
const cors = require('cors');
const https = require('https');
const http = require('http');
require('dotenv').config();

const gamesRoutes = require('./routes/games');

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Ruta proxy para imágenes (soluciona problemas de CORS en web)
app.get('/api/proxy-image', async (req, res) => {
  try {
    const imageUrl = req.query.url;
    
    if (!imageUrl) {
      return res.status(400).json({ error: 'URL de imagen requerida' });
    }

    // Validar que sea una URL válida
    let url;
    try {
      url = new URL(imageUrl);
    } catch (e) {
      return res.status(400).json({ error: 'URL inválida' });
    }

    // Configurar headers CORS
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
    res.setHeader('Cache-Control', 'public, max-age=31536000');

    // Determinar si usar http o https
    const client = url.protocol === 'https:' ? https : http;

    // Hacer la petición a la imagen
    client.get(imageUrl, (imageRes) => {
      // Copiar headers importantes
      if (imageRes.headers['content-type']) {
        res.setHeader('Content-Type', imageRes.headers['content-type']);
      }
      if (imageRes.headers['content-length']) {
        res.setHeader('Content-Length', imageRes.headers['content-length']);
      }

      // Pipe la respuesta
      imageRes.pipe(res);
    }).on('error', (err) => {
      console.error('Error al obtener imagen:', err);
      res.status(500).json({ error: 'Error al obtener la imagen' });
    });
  } catch (error) {
    console.error('Error en proxy de imagen:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

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


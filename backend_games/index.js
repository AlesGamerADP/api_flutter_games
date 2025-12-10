const express = require('express');
const cors = require('cors');
const https = require('https');
const http = require('http');
require('dotenv').config();

const gamesRoutes = require('./routes/games');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get('/api/proxy-image', async (req, res) => {
  try {
    const imageUrl = req.query.url;
    
    if (!imageUrl) {
      return res.status(400).json({ error: 'URL de imagen requerida' });
    }

    let url;
    try {
      url = new URL(imageUrl);
    } catch (e) {
      return res.status(400).json({ error: 'URL inválida' });
    }

    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
    res.setHeader('Cache-Control', 'public, max-age=31536000');

    const client = url.protocol === 'https:' ? https : http;

    client.get(imageUrl, (imageRes) => {
      if (imageRes.headers['content-type']) {
        res.setHeader('Content-Type', imageRes.headers['content-type']);
      }
      if (imageRes.headers['content-length']) {
        res.setHeader('Content-Length', imageRes.headers['content-length']);
      }

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

app.use('/api/games', gamesRoutes);

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

app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Error interno del servidor' });
});

app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});


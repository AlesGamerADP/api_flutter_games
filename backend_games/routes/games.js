const express = require('express');
const router = express.Router();
const supabase = require('../config/supabase');

// Obtener todos los juegos
router.get('/', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('juegos')
      .select('*')
      .order('año_lanzamiento', { ascending: false });

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener los juegos' });
  }
});

// Obtener un juego por ID
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const { data, error } = await supabase
      .from('juegos')
      .select('*')
      .eq('id', id)
      .single();

    if (error) {
      return res.status(404).json({ error: 'Juego no encontrado' });
    }

    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener el juego' });
  }
});

// Crear un nuevo juego
router.post('/', async (req, res) => {
  try {
    const { nombre, genero, plataforma, descripcion, año_lanzamiento, imagen_url } = req.body;

    // Validar campos requeridos
    if (!nombre || !genero || !plataforma || !descripcion || !año_lanzamiento) {
      return res.status(400).json({ 
        error: 'Faltan campos requeridos: nombre, genero, plataforma, descripcion, año_lanzamiento' 
      });
    }

    const { data, error } = await supabase
      .from('juegos')
      .insert([
        {
          nombre,
          genero,
          plataforma,
          descripcion,
          año_lanzamiento,
          imagen_url: imagen_url || null
        }
      ])
      .select()
      .single();

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.status(201).json(data);
  } catch (error) {
    res.status(500).json({ error: 'Error al crear el juego' });
  }
});

// Actualizar un juego
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { nombre, genero, plataforma, descripcion, año_lanzamiento, imagen_url } = req.body;

    const updateData = {};
    if (nombre !== undefined) updateData.nombre = nombre;
    if (genero !== undefined) updateData.genero = genero;
    if (plataforma !== undefined) updateData.plataforma = plataforma;
    if (descripcion !== undefined) updateData.descripcion = descripcion;
    if (año_lanzamiento !== undefined) updateData.año_lanzamiento = año_lanzamiento;
    if (imagen_url !== undefined) updateData.imagen_url = imagen_url;

    const { data, error } = await supabase
      .from('juegos')
      .update(updateData)
      .eq('id', id)
      .select()
      .single();

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    if (!data) {
      return res.status(404).json({ error: 'Juego no encontrado' });
    }

    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Error al actualizar el juego' });
  }
});

// Eliminar un juego
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const { error } = await supabase
      .from('juegos')
      .delete()
      .eq('id', id);

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json({ message: 'Juego eliminado correctamente' });
  } catch (error) {
    res.status(500).json({ error: 'Error al eliminar el juego' });
  }
});

module.exports = router;


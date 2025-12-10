-- Script para crear la tabla de juegos en Supabase
-- Ejecuta este script en el SQL Editor de Supabase

CREATE TABLE IF NOT EXISTS juegos (
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

-- Crear un índice para búsquedas más rápidas por año
CREATE INDEX IF NOT EXISTS idx_juegos_año_lanzamiento ON juegos(año_lanzamiento);

-- Crear un índice para búsquedas por género
CREATE INDEX IF NOT EXISTS idx_juegos_genero ON juegos(genero);

-- Crear un índice para búsquedas por plataforma
CREATE INDEX IF NOT EXISTS idx_juegos_plataforma ON juegos(plataforma);


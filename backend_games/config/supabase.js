const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_KEY;

if (!supabaseUrl || !supabaseKey) {
  console.error('\n❌ Error: Faltan las variables de entorno requeridas');
  console.error('\nPor favor, asegúrate de que tu archivo .env contenga:');
  console.error('SUPABASE_URL=tu_url_de_supabase');
  console.error('SUPABASE_KEY=tu_clave_api_de_supabase');
  console.error('\nObtén estas credenciales desde: Supabase Dashboard > Settings > API\n');
  throw new Error('Faltan las variables de entorno SUPABASE_URL y SUPABASE_KEY');
}

const supabase = createClient(supabaseUrl, supabaseKey);

module.exports = supabase;


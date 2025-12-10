import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../models/game.dart';
import '../config/api_config.dart';

class GameService {
  static const String baseUrl = ApiConfig.baseUrl;

  Future<List<Game>> getGames() async {
    developer.log('GET: Intentando conectar a $baseUrl', name: 'GameService');
    try {
      final uri = Uri.parse(baseUrl);
      developer.log('URL parseada: ${uri.toString()}', name: 'GameService');
      developer.log('Host: ${uri.host}, Port: ${uri.port}, Scheme: ${uri.scheme}', name: 'GameService');
      
      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          developer.log('ERROR: Timeout al conectar con el servidor', name: 'GameService');
          throw Exception('Timeout: No se pudo conectar con el servidor después de 10 segundos');
        },
      );

      developer.log('Respuesta recibida - Status: ${response.statusCode}', name: 'GameService');
      developer.log('Headers: ${response.headers}', name: 'GameService');
      developer.log('Body length: ${response.body.length}', name: 'GameService');

      if (response.statusCode == 200) {
        try {
          List<dynamic> data = json.decode(response.body);
          developer.log('Datos parseados correctamente: ${data.length} juegos', name: 'GameService');
          return data.map((json) => Game.fromJson(json)).toList();
        } catch (e) {
          developer.log('ERROR al parsear JSON: $e', name: 'GameService');
          throw Exception('Error al parsear la respuesta del servidor: $e');
        }
      } else {
        developer.log('ERROR: Status code ${response.statusCode}', name: 'GameService');
        developer.log('Response body: ${response.body}', name: 'GameService');
        throw Exception('Error al cargar los juegos: ${response.statusCode} - ${response.body}');
      }
    } on http.ClientException catch (e) {
      developer.log('ERROR ClientException: $e', name: 'GameService');
      developer.log('Tipo de error: ${e.runtimeType}', name: 'GameService');
      throw Exception('Error de conexión: ${e.message}. Verifica tu conexión a internet y que el servidor esté disponible.');
    } on FormatException catch (e) {
      developer.log('ERROR FormatException: $e', name: 'GameService');
      throw Exception('Error de formato en la respuesta: $e');
    } catch (e, stackTrace) {
      developer.log('ERROR inesperado: $e', name: 'GameService');
      developer.log('Stack trace: $stackTrace', name: 'GameService');
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  Future<Game> getGameById(int id) async {
    final url = '$baseUrl/$id';
    developer.log('GET by ID: $url', name: 'GameService');
    try {
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          developer.log('ERROR: Timeout al obtener juego $id', name: 'GameService');
          throw Exception('Timeout al obtener el juego');
        },
      );

      developer.log('Respuesta - Status: ${response.statusCode}', name: 'GameService');
      if (response.statusCode == 200) {
        return Game.fromJson(json.decode(response.body));
      } else {
        developer.log('ERROR: Status ${response.statusCode} - ${response.body}', name: 'GameService');
        throw Exception('Error al cargar el juego: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      developer.log('ERROR ClientException: $e', name: 'GameService');
      throw Exception('Error de conexión: ${e.message}');
    } catch (e) {
      developer.log('ERROR: $e', name: 'GameService');
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  Future<Game> createGame(Game game) async {
    developer.log('POST: Creando juego - $baseUrl', name: 'GameService');
    try {
      final body = json.encode(game.toJson());
      developer.log('Body: $body', name: 'GameService');
      
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          developer.log('ERROR: Timeout al crear juego', name: 'GameService');
          throw Exception('Timeout al crear el juego');
        },
      );

      developer.log('Respuesta - Status: ${response.statusCode}', name: 'GameService');
      if (response.statusCode == 201) {
        return Game.fromJson(json.decode(response.body));
      } else {
        developer.log('ERROR: Status ${response.statusCode} - ${response.body}', name: 'GameService');
        final errorBody = json.decode(response.body);
        throw Exception(
            'Error al crear el juego: ${errorBody['error'] ?? response.statusCode}');
      }
    } on http.ClientException catch (e) {
      developer.log('ERROR ClientException: $e', name: 'GameService');
      throw Exception('Error de conexión: ${e.message}');
    } catch (e) {
      developer.log('ERROR: $e', name: 'GameService');
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  Future<Game> updateGame(int id, Game game) async {
    final url = '$baseUrl/$id';
    developer.log('PUT: Actualizando juego $id - $url', name: 'GameService');
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(game.toJson()),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          developer.log('ERROR: Timeout al actualizar juego', name: 'GameService');
          throw Exception('Timeout al actualizar el juego');
        },
      );

      developer.log('Respuesta - Status: ${response.statusCode}', name: 'GameService');
      if (response.statusCode == 200) {
        return Game.fromJson(json.decode(response.body));
      } else {
        developer.log('ERROR: Status ${response.statusCode} - ${response.body}', name: 'GameService');
        final errorBody = json.decode(response.body);
        throw Exception(
            'Error al actualizar el juego: ${errorBody['error'] ?? response.statusCode}');
      }
    } on http.ClientException catch (e) {
      developer.log('ERROR ClientException: $e', name: 'GameService');
      throw Exception('Error de conexión: ${e.message}');
    } catch (e) {
      developer.log('ERROR: $e', name: 'GameService');
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  Future<void> deleteGame(int id) async {
    final url = '$baseUrl/$id';
    developer.log('DELETE: Eliminando juego $id - $url', name: 'GameService');
    try {
      final response = await http.delete(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          developer.log('ERROR: Timeout al eliminar juego', name: 'GameService');
          throw Exception('Timeout al eliminar el juego');
        },
      );

      developer.log('Respuesta - Status: ${response.statusCode}', name: 'GameService');
      if (response.statusCode != 200) {
        developer.log('ERROR: Status ${response.statusCode} - ${response.body}', name: 'GameService');
        final errorBody = json.decode(response.body);
        throw Exception(
            'Error al eliminar el juego: ${errorBody['error'] ?? response.statusCode}');
      }
    } on http.ClientException catch (e) {
      developer.log('ERROR ClientException: $e', name: 'GameService');
      throw Exception('Error de conexión: ${e.message}');
    } catch (e) {
      developer.log('ERROR: $e', name: 'GameService');
      throw Exception('Error al conectar con el servidor: $e');
    }
  }
}


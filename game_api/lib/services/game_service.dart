import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game.dart';
import '../config/api_config.dart';

class GameService {
  static const String baseUrl = ApiConfig.baseUrl;

  Future<List<Game>> getGames() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Game.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar los juegos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  Future<Game> getGameById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return Game.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al cargar el juego: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  Future<Game> createGame(Game game) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(game.toJson()),
      );

      if (response.statusCode == 201) {
        return Game.fromJson(json.decode(response.body));
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Error al crear el juego: ${errorBody['error'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  Future<Game> updateGame(int id, Game game) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(game.toJson()),
      );

      if (response.statusCode == 200) {
        return Game.fromJson(json.decode(response.body));
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Error al actualizar el juego: ${errorBody['error'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  Future<void> deleteGame(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200) {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Error al eliminar el juego: ${errorBody['error'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor: $e');
    }
  }
}


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rika_and_morti_characters/models/character.dart';

class ApiService {
  static const String baseUrl = 'https://rickandmortyapi.com/api';

  Future<List<Character>> getCharacters({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/character?page=$page'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        return results.map((json) => Character.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load characters');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<int> getTotalPages() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/character'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['info']['pages'] as int;
      } else {
        return 1;
      }
    } catch (e) {
      return 1;
    }
  }
}

import 'dart:convert';
import 'package:fitness/models/recipe.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class SpoonacularApi {
  final String apiKey = '2742cdfbd75d4d79a7d3851d278afef3';

  Future<List<Recipe>> searchRecipes(String query, int offset) async {
    final url = Uri.parse(
      'https://api.spoonacular.com/recipes/complexSearch?query=$query&offset=$offset&number=20&apiKey=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recipes: ${response.body}');
    }
  }
}

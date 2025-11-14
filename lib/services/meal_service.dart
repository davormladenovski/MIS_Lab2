import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/recipe.dart';

class MealService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories.php'));
    final data = json.decode(response.body);
    final List<dynamic> categoriesJson = data['categories'] ?? [];
    return categoriesJson.map((json) => Category.fromJson(json)).toList();
  }

  Future<List<Meal>> getMealsByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$baseUrl/filter.php?c=${Uri.encodeComponent(category)}'),
    );
    final data = json.decode(response.body);
    final List<dynamic> mealsJson = data['meals'] ?? [];
    return mealsJson.map((json) => Meal.fromJson(json)).toList();
  }

  Future<List<Meal>> searchMeals(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search.php?s=${Uri.encodeComponent(query)}'),
    );
    final data = json.decode(response.body);
    final List<dynamic> mealsJson = data['meals'] ?? [];
    if (mealsJson.isEmpty) return [];
    return mealsJson.map((json) => Meal.fromJson(json)).toList();
  }

  Future<Recipe> getRecipeById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/lookup.php?i=${Uri.encodeComponent(id)}'),
    );
    final data = json.decode(response.body);
    final List<dynamic> mealsJson = data['meals'] ?? [];
    return Recipe.fromJson(mealsJson[0]);
  }

  Future<Recipe> getRandomRecipe() async {
    final response = await http.get(Uri.parse('$baseUrl/random.php'));
    final data = json.decode(response.body);
    final List<dynamic> mealsJson = data['meals'] ?? [];
    return Recipe.fromJson(mealsJson[0]);
  }
}

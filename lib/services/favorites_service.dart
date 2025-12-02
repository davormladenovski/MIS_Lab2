import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_recipes';

  // Додади рецепт во омилени
  Future<void> addFavorite(Recipe recipe) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    
    // Провери дали веќе е омилен
    if (!favorites.any((r) => r.idMeal == recipe.idMeal)) {
      favorites.add(recipe);
      await _saveFavorites(favorites);
    }
  }

  // Отстрани рецепт од омилени
  Future<void> removeFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    favorites.removeWhere((r) => r.idMeal == mealId);
    await _saveFavorites(favorites);
  }

  // Провери дали рецептот е омилен
  Future<bool> isFavorite(String mealId) async {
    final favorites = await getFavorites();
    return favorites.any((r) => r.idMeal == mealId);
  }

  // Земи ги сите омилени рецепти
  Future<List<Recipe>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];
    
    return favoritesJson.map((jsonString) {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return Recipe.fromJson(json);
    }).toList();
  }

  // Зачувај ги омилените рецепти
  Future<void> _saveFavorites(List<Recipe> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = favorites.map((recipe) {
      return jsonEncode({
        'idMeal': recipe.idMeal,
        'strMeal': recipe.strMeal,
        'strCategory': recipe.strCategory,
        'strArea': recipe.strArea,
        'strInstructions': recipe.strInstructions,
        'strMealThumb': recipe.strMealThumb,
        'strYoutube': recipe.strYoutube,
        'strIngredient1': recipe.strIngredient1,
        'strIngredient2': recipe.strIngredient2,
        'strIngredient3': recipe.strIngredient3,
        'strIngredient4': recipe.strIngredient4,
        'strIngredient5': recipe.strIngredient5,
        'strIngredient6': recipe.strIngredient6,
        'strIngredient7': recipe.strIngredient7,
        'strIngredient8': recipe.strIngredient8,
        'strIngredient9': recipe.strIngredient9,
        'strIngredient10': recipe.strIngredient10,
        'strIngredient11': recipe.strIngredient11,
        'strIngredient12': recipe.strIngredient12,
        'strIngredient13': recipe.strIngredient13,
        'strIngredient14': recipe.strIngredient14,
        'strIngredient15': recipe.strIngredient15,
        'strIngredient16': recipe.strIngredient16,
        'strIngredient17': recipe.strIngredient17,
        'strIngredient18': recipe.strIngredient18,
        'strIngredient19': recipe.strIngredient19,
        'strIngredient20': recipe.strIngredient20,
        'strMeasure1': recipe.strMeasure1,
        'strMeasure2': recipe.strMeasure2,
        'strMeasure3': recipe.strMeasure3,
        'strMeasure4': recipe.strMeasure4,
        'strMeasure5': recipe.strMeasure5,
        'strMeasure6': recipe.strMeasure6,
        'strMeasure7': recipe.strMeasure7,
        'strMeasure8': recipe.strMeasure8,
        'strMeasure9': recipe.strMeasure9,
        'strMeasure10': recipe.strMeasure10,
        'strMeasure11': recipe.strMeasure11,
        'strMeasure12': recipe.strMeasure12,
        'strMeasure13': recipe.strMeasure13,
        'strMeasure14': recipe.strMeasure14,
        'strMeasure15': recipe.strMeasure15,
        'strMeasure16': recipe.strMeasure16,
        'strMeasure17': recipe.strMeasure17,
        'strMeasure18': recipe.strMeasure18,
        'strMeasure19': recipe.strMeasure19,
        'strMeasure20': recipe.strMeasure20,
      });
    }).toList();
    
    await prefs.setStringList(_favoritesKey, favoritesJson);
  }
}



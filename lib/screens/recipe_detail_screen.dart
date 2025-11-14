import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/recipe.dart';
import '../services/meal_service.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe? recipe;
  final String? mealId;

  const RecipeDetailScreen({
    super.key,
    this.recipe,
    this.mealId,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final MealService _mealService = MealService();
  Recipe? _recipe;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      _recipe = widget.recipe;
      _isLoading = false;
    } else if (widget.mealId != null) {
      _loadRecipe();
    }
  }

  Future<void> _loadRecipe() async {
    try {
      final recipe = await _mealService.getRecipeById(widget.mealId!);
      setState(() {
        _recipe = recipe;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _openYouTube(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Recipe Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_recipe == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Recipe Details')),
        body: const Center(child: Text('Recipe not found')),
      );
    }

    final ingredients = _recipe!.getIngredients();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              _recipe!.strMealThumb,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 100),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _recipe!.strMeal,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  if (_recipe!.strCategory.isNotEmpty)
                    Text('Category: ${_recipe!.strCategory}'),
                  if (_recipe!.strArea.isNotEmpty)
                    Text('Area: ${_recipe!.strArea}'),
                  const SizedBox(height: 24.0),
                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  for (var ingredient in ingredients)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text('• ${ingredient['ingredient']} - ${ingredient['measure']}'),
                    ),
                  const SizedBox(height: 24.0),
                  const Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(_recipe!.strInstructions),
                  if (_recipe!.strYoutube.isNotEmpty) ...[
                    const SizedBox(height: 24.0),
                    ElevatedButton.icon(
                      onPressed: () => _openYouTube(_recipe!.strYoutube),
                      icon: const Icon(Icons.play_circle_outline),
                      label: const Text('Watch on YouTube'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

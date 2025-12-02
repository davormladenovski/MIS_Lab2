import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../models/recipe.dart';
import '../services/favorites_service.dart';
import '../services/meal_service.dart';

class MealCard extends StatefulWidget {
  final Meal meal;
  final VoidCallback onTap;

  const MealCard({
    super.key,
    required this.meal,
    required this.onTap,
  });

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  final FavoritesService _favoritesService = FavoritesService();
  final MealService _mealService = MealService();
  bool _isFavorite = false;
  bool _isLoadingFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final isFav = await _favoritesService.isFavorite(widget.meal.idMeal);
    setState(() {
      _isFavorite = isFav;
    });
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      _isLoadingFavorite = true;
    });

    try {
      if (_isFavorite) {
        await _favoritesService.removeFavorite(widget.meal.idMeal);
      } else {
        // Земи го целосниот рецепт за да го зачуваме
        final recipe = await _mealService.getRecipeById(widget.meal.idMeal);
        await _favoritesService.addFavorite(recipe);
      }
      
      setState(() {
        _isFavorite = !_isFavorite;
        _isLoadingFavorite = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFavorite 
                ? 'Додадено во омилени' 
                : 'Отстрането од омилени',
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoadingFavorite = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Грешка при зачувување'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: widget.onTap,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Image.network(
                    widget.meal.strMealThumb,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image, size: 50);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.meal.strMeal,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: _isLoadingFavorite
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.white,
                      ),
                onPressed: _toggleFavorite,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



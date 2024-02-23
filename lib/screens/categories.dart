import 'package:flutter/material.dart';
import 'package:meal_app_latest/data/dummy_data.dart';
import 'package:meal_app_latest/screens/meals.dart';
import 'package:meal_app_latest/widgets/category_grid_item.dart';
import 'package:meal_app_latest/models/category.dart';
import 'package:meal_app_latest/models/meal.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({
    super.key,
    required this.toggleFavoriteMealStatus,
    required this.availableMeals,
  });

  final void Function(Meal meal) toggleFavoriteMealStatus;
  final List<Meal> availableMeals;

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => MealsScreen(
        title: category.title,
        meals: filteredMeals,
        toggleFavoriteMealStatus: (meal) => toggleFavoriteMealStatus(meal),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      children: [
        for (final category in availableCategories)
          CategoryGridItem(
            category: category,
            onSelectCategory: () => _selectCategory(context, category),
          ),
      ],
    );
  }
}

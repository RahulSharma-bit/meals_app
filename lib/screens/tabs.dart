import 'package:flutter/material.dart';
import 'package:meal_app_latest/screens/categories.dart';
import 'package:meal_app_latest/screens/filters.dart';
import 'package:meal_app_latest/screens/meals.dart';
import 'package:meal_app_latest/models/meal.dart';
import 'package:meal_app_latest/widgets/main_drawer.dart';
import 'package:meal_app_latest/data/dummy_data.dart';

const kIntialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegeterian: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int activePageIndex = 0;
  final List<Meal> _favoriteMeals = [];
  Map<Filter, bool> _selectedFilters = kIntialFilters;

  void _setScreen(String identifier) async {
    if (identifier == 'filters') {
      Navigator.of(context).pop();
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(
            currentFilters: _selectedFilters,
          ),
        ),
      );
      setState(() {
        _selectedFilters = result ?? kIntialFilters;
      });
      // print(result);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(duration: const Duration(seconds: 3), content: Text(message)));
  }

  void _toggleFavoriteMealStatus(Meal meal) {
    if (_favoriteMeals.contains(meal)) {
      setState(() {
        _favoriteMeals.remove(meal);
        _showInfoMessage("Meal Removed ");
      });
    } else {
      setState(() {
        _favoriteMeals.add(meal);
        _showInfoMessage("Meal Added to the Favorite's ❤");
      });
    }
  }

  void selectPage(int index) {
    setState(() {
      activePageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      if (_selectedFilters[Filter.vegeterian]! && !meal.isVegetarian) {
        return false;
      }
      return true;
    }).toList();

    String activePageTitle = "Categories";
    Widget content = CategoriesScreen(
      toggleFavoriteMealStatus: (meal) => _toggleFavoriteMealStatus(meal),
      availableMeals: availableMeals,
    );

    if (activePageIndex == 1) {
      content = MealsScreen(
        meals: _favoriteMeals,
        toggleFavoriteMealStatus: (meal) {
          _toggleFavoriteMealStatus(meal);
        },
      );
      activePageTitle = "Favorite's";
    }

    return Scaffold(
      appBar: AppBar(title: Text(activePageTitle)),
      drawer: MainDrawer(
        onSelectScreen: (identifier) => _setScreen(identifier),
      ),
      body: content,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: activePageIndex,
          onTap: selectPage,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.set_meal), label: "Categories"),
            BottomNavigationBarItem(
                icon: Icon(Icons.star_border_purple500), label: "Favorite"),
          ]),
    );
  }
}

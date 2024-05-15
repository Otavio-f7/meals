import 'package:flutter/material.dart';
import 'screens/categories_meals_screen.dart';
import 'utils/app_routes.dart';
import 'screens/meal_detail_screen.dart';
import 'screens/tabs_screen.dart';
import 'screens/settings_screen.dart';
import 'models/meal.dart';
import 'models/settings.dart';
import 'data/dummy_data.dart';
 
void main() => runApp( const MyApp());
 
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Settings settings = Settings();
  List<Meal> _availableMeals = dummyMeals;
  final List<Meal> _favoriteMeals = [];

  void _filterMeals(Settings settings) {
    setState(() {
      this.settings = settings;
      _availableMeals = dummyMeals.where((meal){
        final filterGluten = settings.isGlutenFree && !meal.isGlutenFree;
        final filterLactose = settings.isLactoseFree && !meal.isLactoseFree;
        final filterVegan = settings.isVegan && !meal.isVegan;
        final filterVegetarian = settings.isVegetarian && !meal.isVegetarian;
        return !filterGluten && !filterLactose && !filterVegan && !filterVegetarian;
      }).toList();
    });
  }

  void _toggFavorite(Meal meal) {
    setState(() {
      _favoriteMeals.contains(meal) 
        ? _favoriteMeals.remove(meal) 
        : _favoriteMeals.add(meal);
    });
  }

  bool _isFavorite(Meal meal) {
    return _favoriteMeals.contains(meal);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        colorScheme: ThemeData().colorScheme.copyWith(
        primary: Colors.pink,
        secondary:Colors.amber ,
        ),
        fontFamily: 'Raleway',
        canvasColor: const Color.fromRGBO(255, 254, 229, 1),
        textTheme: ThemeData.light().textTheme.copyWith(
          titleLarge: const TextStyle(
            fontSize: 20,
            fontFamily: 'RobotoCondensed'
          )
        ),
        appBarTheme: ThemeData.light().appBarTheme.copyWith(
          backgroundColor: Colors.pink,
          centerTitle: true,
        )
      ),
      routes: {
        AppRoutes.HOME : (ctx) => TabsScreen(_favoriteMeals),
        AppRoutes.CATEGORIES_MEALS :(ctx) => CategoriesMealsScreen(_availableMeals),
        AppRoutes.MEALS_DETAIL :(ctx) => MealDetailScreen(_toggFavorite, _isFavorite),
        AppRoutes.SETTINGS:(ctx) => SettingsScreen(_filterMeals, settings),
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/meal_item.dart';
import '../models/meals.dart';

class FavoriteScreen extends StatelessWidget {
  final List<Meal> favoritesMeals;

  FavoriteScreen(this.favoritesMeals);

  @override
  Widget build(BuildContext context) {
    if (favoritesMeals.isEmpty) {
      return Center(
        child: Text('You have no favorites yet - start adding some!'),
      );
      //vamos usar a mesma listBuilder de meal_detail_Screnn
    } else {
      return ListView.builder(
        itemBuilder: (ctx, index) {
          return MealItem(
            id: favoritesMeals[index].id,
            title: favoritesMeals[index].title,
            imageUrl: favoritesMeals[index].imageUrl,
            duration: favoritesMeals[index].duration,
            complexity: favoritesMeals[index].complexity,
            affordability: favoritesMeals[index].affordability,
            // removeItem: _removeItem,
          );
        },
        itemCount: favoritesMeals.length,
      );
    }
  }
}

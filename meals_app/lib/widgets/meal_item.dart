import 'package:flutter/material.dart';

import '../models/meals.dart';

class MealItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;

  MealItem({
    required this.title,
    required this.imageUrl,
    required this.duration,
    required this.complexity,
    required this.affordability,
  });

  void selectMeal() {}

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: selectMeal,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                //Nossa imagem terá bordas arrendondadas para ela não sobrepor
                //a borda do Card, usamos uma nova widget ClipRRect
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        15), //precisar ser do tamanho da borda do card
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit
                        .cover, //a imagem será redimensionada e cortada para caber
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

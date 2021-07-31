import 'package:flutter/material.dart';

import '../models/meals.dart';
import '../screens/meal_detail_screen.dart';

class MealItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;
  // final Function removeItem;

  MealItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.duration,
    required this.complexity,
    required this.affordability,
    // required this.removeItem,
  });

  String get complexityText {
    //combine varios ifs statements em um statement
    switch (complexity) {
      case Complexity.Simple:
        return 'Simple';
        break;
      case Complexity.Challenging:
        return 'Challeging';
        break;
      case Complexity.Hard:
        return 'Hard';
        break;
      default:
        return 'Unknown';
    }
  }

  String get affordabilityText {
    switch (affordability) {
      case Affordability.Affordable:
        return 'Affordable';
        break;
      case Affordability.Luxurious:
        return 'Expensive';
        break;
      case Affordability.Pricey:
        return 'Pricey';
        break;
      default:
        return 'Unknown';
    }
  }

  void selectMeal(BuildContext ctx) {
    Navigator.of(ctx)
        .pushNamed(
      MealDetailScreen.routeName,
      arguments: id,
    )
        .then(
      (result) {
        if (result != null) {
          //recuperamos o parametro mealId e forwardamos para a tela anterior
          //colocamos o icone de favoritos no lugar da lixeira
          // removeItem(result);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectMeal(context),
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
                ),
                //essa widget só funciona dentro de stack
                Positioned(
                  bottom: 10,
                  right: 20,
                  child: Container(
                    width: 300,
                    color: Colors.black54,
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20,
                    ),
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 26, color: Colors.white),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(Icons.schedule),
                      SizedBox(
                        //espaço entre as informações
                        width: 6,
                      ),
                      Text('$duration min'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.work),
                      SizedBox(
                        //espaço entre as informações
                        width: 6,
                      ),
                      Text('$complexityText'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.attach_money),
                      SizedBox(
                        //espaço entre as informações
                        width: 6,
                      ),
                      Text(affordabilityText),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

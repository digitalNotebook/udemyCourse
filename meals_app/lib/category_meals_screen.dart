import 'package:flutter/material.dart';

import './dummy_data.dart';

class CategoryMealsScreen extends StatelessWidget {
  //Vamos utilizar named routes para passar informações
  // final String id;
  // final String title;

  // CategoryMealsScreen(this.id, this.title);

  //define o nome da rota e podemos chamar sem instanciar a classe
  static const routeName = '/category-meals';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;

    final title = routeArgs['title'];
    final id = routeArgs['id'];

    //Vamos criar uma lista filtrada para passar ao ListView.builder
    final categoriesMeal = DUMMY_MEALS.where((meal) {
      return meal.categories.contains(id);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(title != null ? title : ''),
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return Text(categoriesMeal[index].title);
          },
          itemCount: categoriesMeal.length,
        ),
      ),
    );
  }
}
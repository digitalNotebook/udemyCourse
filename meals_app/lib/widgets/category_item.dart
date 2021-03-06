import 'package:flutter/material.dart';

import '../screens/category_meals_screen.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final Color color;
  final String id;

  CategoryItem(this.id, this.title, this.color);

  void selectCategory(BuildContext ctx) {
    //classe do Flutter que permite navegar entre as telas
    //colocamos a tela da categoria selecionada no topo da stack
    // Navigator.of(ctx).push(
    //   cria o Material Page Route on the fly
    //   MaterialPageRoute(
    //     builder: (_) {
    //       return CategoryMealsScreen(this.id, this.title);
    //     },
    //   ),
    // );

    //Vamos usar essa nova forma para passar informações entre as telas
    //baseado na rota que criamos em main.dart
    Navigator.of(ctx).pushNamed(
      CategoryMealsScreen.routeName,
      arguments: {'id': id, 'title': title},
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectCategory(context),
      splashColor: Theme.of(context).primaryColor,
      borderRadius:
          BorderRadius.circular(20), //tem que ser igual ao do container
      child: Container(
        /*
        otimizamos o build process, quando houver o rebuild este objeto
        não será recriado
        */
        padding: const EdgeInsets.all(15),
        child: Text(
          title,
          //usamos o thema definido em main.dart
          style: Theme.of(context).textTheme.headline6,
        ),
        decoration: BoxDecoration(
          //primeira vez usando Gradient, existem outras formas
          gradient: LinearGradient(
            colors: [
              //color mais clara
              color.withOpacity(0.7),
              color,
            ],
            //AlignmentGeometry -> Aligment
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          //não podemos usar const, pois o construtor circular não é marcado com const
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

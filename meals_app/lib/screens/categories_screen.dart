import 'package:flutter/material.dart';

import '../dummy_data.dart';
import '../widgets/category_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: EdgeInsets.all(25),
      //irá receber os CategoryItems
      children: DUMMY_CATEGORIES
          .map(
            (category) =>
                CategoryItem(category.id, category.title, category.color),
          )
          .toList(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200, //width de 200 devices pixels cada tile
        childAspectRatio: 3 / 2, //200 * (1.5)
        mainAxisSpacing: 20, //espaço entre cada tile do grid
        crossAxisSpacing: 20, //espaço entre cada tile do grid
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../dummy_data.dart';
import '../widgets/meal_item.dart';
import '../models/meals.dart';

class CategoryMealsScreen extends StatefulWidget {
  //Vamos utilizar named routes para passar informações
  // final String id;
  // final String title;

  // CategoryMealsScreen(this.id, this.title);

  //define o nome da rota e podemos chamar sem instanciar a classe
  static const routeName = '/category-meals';

  final List<Meal> availableMeals;

  CategoryMealsScreen(this.availableMeals);

  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  var title;
  late List<Meal> displayedList;
  var _loadInitialData = false;

  @override
  void initState() {
    super.initState();
  }

  //chamado antes de build e depois de initState
  @override
  void didChangeDependencies() {
    if (!_loadInitialData) {
      final routeArgs =
          ModalRoute.of(context)?.settings.arguments as Map<String, String>;

      title = routeArgs['title'];
      final id = routeArgs['id'];

      //Vamos criar uma lista filtrada para passar ao ListView.builder
      displayedList = widget.availableMeals.where((meal) {
        return meal.categories.contains(id);
      }).toList();
      _loadInitialData = true;
    }

    super.didChangeDependencies();
  }

  void _removeItem(String id) {
    setState(
      () {
        displayedList.removeWhere((element) => element.id == id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title != null ? title : ''),
      ),
      body: Center(
        //baseado na lista filtrada acima, exibimos as receitas da categoria
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return MealItem(
              id: displayedList[index].id,
              title: displayedList[index].title,
              imageUrl: displayedList[index].imageUrl,
              duration: displayedList[index].duration,
              complexity: displayedList[index].complexity,
              affordability: displayedList[index].affordability,
              // removeItem: _removeItem,
            );
          },
          itemCount: displayedList.length,
        ),
      ),
    );
  }
}

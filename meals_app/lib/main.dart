import 'package:flutter/material.dart';

import './screens/categories_screen.dart';
import './screens/category_meals_screen.dart';
import './screens/meal_detail_screen.dart';
import './screens/filters_screen.dart';
import 'screens/tab_screen_bottom.dart';
import './dummy_data.dart';
import './models/meals.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //criamos esse mapa, poderia ser um model
  var _filters = {
    'gluten': false,
    'vegan': false,
    'vegetarian': false,
    'lactose': false,
  };

  //forwardamos essa lista para a tela de categorias
  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favoritesMeals = [];

  //passamos um pointer deste método para o salvar da tela de filtros
  void _setFilters(Map<String, bool> filtersData) {
    setState(() {
      _filters = filtersData;

      //fazemos o filtro de acordo com o que foi selecionado
      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_filters['gluten'] as bool && !meal.isGlutenFree) {
          return false;
        }
        if (_filters['vegan'] as bool && !meal.isVegan) {
          return false;
        }
        if (_filters['vegetarian'] as bool && !meal.isVegetarian) {
          return false;
        }
        if (_filters['lactose'] as bool && !meal.isLactoseFree) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  //vamos gerenciar o toggle dos favoritos aqui
  //porém iremos aprender uma forma mais elegante
  //de realizar o state managment
  void _toggleFavorite(String mealId) {
    //procuramos na lista de favoritos se aquela id existe
    //caso não encontre o resultado será -1
    var existingIndex = _favoritesMeals.indexWhere((meal) => meal.id == mealId);

    //encontramos um favorito, vamos removê-lo e atualizar a tela
    if (existingIndex >= 0) {
      setState(
        () {
          _favoritesMeals.removeAt(existingIndex);
        },
      );
    } else {
      setState(
        () {
          _favoritesMeals
              .add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
        },
      );
    }
  }

  //olhamos todos os elementos da lista e retornamos true/false a partir da comparação
  bool _isFavorite(String id) {
    return _favoritesMeals.any((element) => element.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealsApp',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        //replace texttheme com nossas configs
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              bodyText2: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              headline6: TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
      initialRoute: '/', //o padrão é /
      //home: CategoriesScreen(),
      routes: {
        '/': (ctx) => TabsScreen(_favoritesMeals),
        //rota definida como um static const

        CategoryMealsScreen.routeName: (ctx) =>
            CategoryMealsScreen(_availableMeals),
        MealDetailScreen.routeName: (ctx) =>
            MealDetailScreen(_toggleFavorite, _isFavorite),
        FiltersScreen.routeName: (ctx) => FiltersScreen(_filters, _setFilters),
      },
      //é acionada quando usamos pushNamed, mas o Flutter não acha na tabela acima
      // onGenerateRoute: (settings) {
      //   if(settings.name == '/rota-url'){
      //     return some MaterialPageRoute(builder: builder)
      //   }
      //   //devemos retornar uma rota
      // return MaterialPageRoute(builder: (ctx) => CategoryMealsScreen());
      // },
      //usada para error handling
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) => CategoriesScreen());
      },
    );
  }
}

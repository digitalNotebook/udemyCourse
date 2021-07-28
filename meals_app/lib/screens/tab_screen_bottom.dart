import 'package:flutter/material.dart';

import './categories_screen.dart';
import './favorites_screen.dart';
import '../widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  //Lista de widgets que serão exibidas
  final List<Map<String, dynamic>> _pages = [
    {
      'page': CategoriesScreen(),
      'title': 'Categories',
    },
    {
      'page': FavoriteScreen(),
      'title': 'Favorites',
    },
  ];

  //qual tela iremos usar
  int _selectedPageIndex = 0;

  //o index é passado automaticamente pelo Flutter
  //e a cada mudança a tela será renderizada
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
      ),
      drawer: MainDrawer(),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white, //tab não selcionada
        selectedItemColor:
            Theme.of(context).accentColor, //cor da tab selecionada
        currentIndex:
            _selectedPageIndex, //diz a bottomNavigation qual tab está selecionada
        // selectedFontSize: , //tamanho da fonte quando selecionado
        // unselectedFontSize: ,//tamanho da fonte quando não selecionado

        // type: BottomNavigationBarType.shifting, //realiza pequena animação
        //é necessário definir a cor dos itens abaixo

        items: [
          BottomNavigationBarItem(
            tooltip: 'Navegar até as categorias',
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.category), //semelhante as Tab()
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

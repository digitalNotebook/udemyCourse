import 'package:flutter/material.dart';

import './categories_screen.dart';
import './favorites_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, //quantas tabs queremos
      initialIndex: 0, //a categories sempre vem selecionada
      child: Scaffold(
        appBar: AppBar(
          //normal appBar
          title: Text('Meals'),
          bottom: TabBar(
            indicatorColor: Colors.black,
            //tabbar que será adicionada embaixo da appbar
            tabs: [
              //o design das 2 tabs nesse caso
              Tab(
                icon: Icon(Icons.category),
                text: 'Categories',
              ),
              Tab(
                icon: Icon(Icons.favorite),
                text: 'Favorites',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CategoriesScreen(),
            FavoriteScreen(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/widgets/badge.dart';

import '../widgets/products_grid.dart';
// import 'package:provider/provider.dart';
// import '../providers/products.dart';

enum FiltersOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  ProductsOverviewScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    var _showFavoritesOnly = false;
    //só estamos interessados em acessar o conteudo do container
    // var productsContainer = Provider.of<Products>(context, listen: false); usamos para demonstrar a forma antiga

    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          //Primeira vez que usamos essa Widget
          PopupMenuButton(
            //baseado no enum
            onSelected: (FiltersOptions selectedItem) {
              if (selectedItem == FiltersOptions.Favorites) {
                // productsContainer.showFavoritesOnly(); forma antiga
                setState(() {
                  _showFavoritesOnly = true;
                });
              } else {
                // productsContainer.showAll();
                setState(() {
                  _showFavoritesOnly = false;
                });
              }
            },
            icon: Icon(Icons.more_vert), //3 dots verticais
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FiltersOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FiltersOptions.All,
              )
            ],
          ),
          Consumer<Cart>(
            builder: (ctx, cart, ch) => Badge(
              child: ch as IconButton,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              //não será reconstruído quando o carrinho mudar
              onPressed: () {},
              icon: Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      body: ProductsGrid(_showFavoritesOnly),
    );
  }
}
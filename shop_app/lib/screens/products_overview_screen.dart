import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';
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
  var _showFavoritesOnly = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); //WON'T WORK
    // Provider.of<Products>(context, listen: false).fetchAndSetProducts(); //WORK
    //Não executa imediamente apesar o Duration.zero
    // Future.delayed(Duration.zero).then(
    //   (value) => Provider.of<Products>(context).fetchAndSetProducts(),
    // );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
          //Modifica o badge do carrinho caso o botão seja pressionado
          Consumer<Cart>(
            builder: (ctx, cart, ch) => Badge(
              child: ch as IconButton,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              //não será reconstruído quando o carrinho mudar
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showFavoritesOnly),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  //Comentamos pois vamos usar o Provider Product
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(
  //     {required this.id, required this.title, required this.imageUrl, Key? key})
  //     : super(key: key);

  @override
  Widget build(BuildContext context) {
    //deixamos como listen:false, pois só atualizamos o botão de favoritos
    var product = Provider.of<Product>(context, listen: false);

    //só vamos adicionar um produto e não atualizar a página
    var cart = Provider.of<Cart>(context, listen: false);

    var authData = Provider.of<Auth>(context, listen: false);
    //funciona bem dentro de gridview

    //realiza a mesma função do provider acima

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        //nova widget aqui
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          //usamos o consumder widget no unico lugar que irá mudar
          //sem reconstruir toda a widget de ProductItem
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavorite(authData.token, authData.userId);
              },
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);
              //DEPRECATED
              // Scaffold.of(context).showSnackBar(snackbar);
              //EXIBE UMA BARRA DE NOTIFICAÇÃO NO BOTTOM
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added item to the cart'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.deleteSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.shopping_cart,
            ),
          ),
        ),
      ),
    );
  }
}

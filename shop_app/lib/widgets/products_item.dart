import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';

import '../screens/product_detail_screen.dart';

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
                product.toggleFavorite();
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
            onPressed: () {},
            icon: Icon(
              Icons.shopping_cart,
            ),
          ),
        ),
      ),
    );
  }
}

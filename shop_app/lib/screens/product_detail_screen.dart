import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    //recuperamos o id passado pelo pushNamed do onTap de GestureDetector
    var productId = ModalRoute.of(context)?.settings.arguments as String;
    //Acessamos o Products Container items e carregamos o produto pelo id
    var loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        //areas na tela que irão scrollar
        slivers: [
          SliverAppBar(
            expandedHeight: 300, //a mesma do container
            pinned: true, //appbar always visible
            //o que teremos dentro da appbar
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              // a parte que veremos se a appbar for expandida
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                //vamos adicionar um espço (altura)
                SizedBox(
                  height: 10,
                ),
                //um texto que irá exibir o preço (podemos definir o style com o Theme)
                Text(
                  '\$${loadedProduct.price}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                //exibe a descrição em um container com quebra de linha
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    loadedProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: 600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

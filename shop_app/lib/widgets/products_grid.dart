import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'products_item.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Setamos o provider para verificar o container products
    final productsData = Provider.of<Products>(context);

    //usamos o getter que retorna uma cópia da lista
    final products = productsData.items;
    return GridView.builder(
      itemCount: products.length,
      //define como o gridview deve ser construído
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        // create: (c) => products[i],
        child: ProductItem(
            // id: products[i].id,
            // title: products[i].title,
            // imageUrl: products[i].imageUrl,
            ),
      ),
      //define como o gridview deve ser estruturado
      //quantas colunas ele deve ter
      //com o sliver abaixo definimos quantas colunas devemos ter
      //e o flutter irá amassar os itens para caber na tela
      //usando o Extent definimos o quão wide o grid deve ser

      //crossAxiscount 2 columns
      //childAspectRatio 3 / 2 será um pouco alto e menos largo
      //crossAxisSpacing espaço entre as colunas
      //mainAxisSpacing espaço entre as linhas
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}

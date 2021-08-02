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
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
    );
  }
}

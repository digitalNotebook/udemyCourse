import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_products_item.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    var productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (_, index) => Column(
            children: [
              UserProductsItem(
                productData.items[index].imageUrl,
                productData.items[index].title,
              ),
              Divider(),
            ],
          ),
          itemCount: productData.items.length,
        ),
      ),
    );
  }
}

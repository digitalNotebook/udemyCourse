import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  ProductItem(
      {required this.id, required this.title, required this.imageUrl, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //funciona bem dentro de gridviews
    return GridTile(
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}

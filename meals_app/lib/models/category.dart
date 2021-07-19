import 'package:flutter/material.dart';

class Category {
  final String id;
  final String title;
  final Color color;

  //senao for fornecida a cor, o padrão será laranja
  const Category(
      {required this.id, required this.title, this.color = Colors.orange});
}

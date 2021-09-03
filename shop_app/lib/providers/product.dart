import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  //se colocarmos a imagem como asset, toda image novao precisa que o app seja
  //atualizado
  final String imageUrl;

  //vamos nos preocupar depois em como implementar o favoritos para cada usuário
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token, String userId) async {
    //fazemos uma cópia do status antigo
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    final url = Uri.parse(
        'https://shop-app-b6bd5-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token');
    try {
      //somente o GET E O POST CAEM NO CATCH, OS DEMAIS SÃO VALIDADOS COM HTTP STATUS
      //VAMOS ATUALIZAR TO DO O CONJUNTO COM O PUT, JÁ COM O PATCH, PODEMOS ATUALIZAR PARCIALMENTE UM SUBCONJUNTO

      var response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
    notifyListeners();
  }
}

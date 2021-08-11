import 'package:flutter/foundation.dart';

class CartItem {
  //como um cart deve ser
  final String id;
  final String title; //titulo do produto
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  /*Vamos criar um mapa para cada CardItem pertencer a um Produto
  pois o id do CartItem não é o mesmo do Produto, já que o CartItem 
  é um novo objeto */
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  //calculamos o total
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  int get itemCount {
    return _items.length;
  }

  void addItem(String productId, String title, double price) {
    //atualiza o Map com um novo objeto, porém com a qtde adicionada
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + 1,
          price: price,
        ),
      );
    } else {
      //cria um novo CartItem()
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void deleteItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  //removemos a adição mais recente
  void deleteSingleItem(String productId) {
    //se a lista NÃO contém este produto, então cancela a execução
    //do método com return;
    if (!_items.containsKey(productId)) {
      return;
    }
    //checamos se o produto possui mais de uma quantidade
    //removemos um da quantidade
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingProduct) => CartItem(
            id: existingProduct.id,
            title: existingProduct.title,
            quantity: existingProduct.quantity - 1,
            price: existingProduct.price),
      );
      //caso contrário removemos o produto da lista
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}

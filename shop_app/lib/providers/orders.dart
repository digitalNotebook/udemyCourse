import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String token;

  Orders(this.token, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://shop-app-b6bd5-default-rtdb.firebaseio.com/orders.json?auth=$token');
    //fazemos a requisição para o Firebase
    var response = await http.get(url);
    //criamos uma lista vazia para ser preenchida
    final List<OrderItem> loadedOrders = [];
    //estruturamos o conteudo recebido no formato que o Dart reconhece
    final ordersJson = (json.decode(response.body) as Map<String, dynamic>);

    if (ordersJson.isEmpty) {
      return;
    }
    //importante ver a resposta da requisição para montar o OrderItem abaixo
    // print(json.decode(response.body));
    //percorremos o node Orders.json e adicionamos ao loadedOrders
    ordersJson.forEach(
      (orderId, orderData) {
        //Adicionamos o objeto OrderItem na List
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            //mapeamos todos os produtos da ordem
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ),
                )
                .toList(),
          ),
        );
      },
    );
    _orders = loadedOrders.reversed.toList();
  }

  Future<void> addOrdem(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://shop-app-b6bd5-default-rtdb.firebaseio.com/orders.json?auth=$token');

    //usamos o mesmo timestamp para o http e a gravação local
    final timestamp = DateTime.now();
    //colocar o bloco try-catch
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        //conseguimos converter facilmente para um objeto DateTime no Dart
        'dateTime': timestamp.toIso8601String(),
        //vamos mapear os CartItens e retornar um Map de CartProducts
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    //insere a ordem sempre no inicio e move +1 as demais
    _orders.insert(
      0,
      OrderItem(
        //id gerada pelo firebase
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timestamp,
      ),
    );
    notifyListeners();
  }
}

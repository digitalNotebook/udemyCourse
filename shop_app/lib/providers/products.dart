import 'package:flutter/material.dart';
import 'product.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  //não é final, pois irá mudar com o tempo
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  // var _showFavoritesOnly = false;

  //usamos um get dessa forma para retornar uma cópia da lista de produtos
  //e não uma referência para essa variavel, pois senão estariamos
  //modificando-a diretamente, porém só podemos chamar o notifyListeners() aqui
  List<Product> get items {
    //se usarmos dessa forma outras telas verão o container filtrado
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoritesItems {
    //já retorna uma cópia não precisamos colocar o [...]
    return _items.where((productItem) => productItem.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.https(
        'shop-app-b6bd5-default-rtdb.firebaseio.com', 'products.json');
    /*essa requisição pode falhar, então usamos o try-catch
    e repassamos o erro para ser manipulado na widget para exibir informação
    ao usuário */
    try {
      var response = await http.get(url);
      //checar o retorno do firebase
      print(json.decode(response.body));
      /*sabemos que o Firebase retorna um Map<String, Map<>>
       porém o Dart não reconhece o Map de Map por isso usamos dynamic*/
      var extractedData = json.decode(response.body) as Map<String, dynamic>;
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.https(
        'shop-app-b6bd5-default-rtdb.firebaseio.com', 'products.json');
    try {
      //codigo que provalvemente pode falhar
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          },
        ),
      );
      print(json.decode(response.body));
      final newProduct = Product(
        //setamos a ID com a ID gerada pelo Firebase
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); //insere no inicio da lista
      notifyListeners();
    } catch (error) {
      print(error);
      // //podemos enviar este erro para um server analitico, porém

      // //com o uso do throw retornamos esse erro
      // //para usar a mesma catchError em outro lugar
      // //no caso na tela de editproducts para exibir um modal ao usuario
      throw error;
    }
  }

  void update(String id, Product newProduct) {
    //encontramos o indice do produto
    var prodIndex = _items.indexWhere((prod) => prod.id == id);
    //testamos para saber se o produto foi encontrado
    //pois o retorno de não encontrado é -1
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('product not find');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }
}

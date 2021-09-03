import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import 'product.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  //não é final, pois irá mudar com o tempo
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String _authToken;
  final String _userId;

  Products(this._authToken, this._items, this._userId);

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

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterStringUri =
        filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
    var url = Uri.parse(
        'shop-app-b6bd5-default-rtdb.firebaseio.com/products.json?auth=$_authToken&$filterStringUri');
    /*essa requisição pode falhar, então usamos o try-catch
    e repassamos o erro para ser manipulado na widget para exibir informação
    ao usuário */
    try {
      final response = await http.get(url);
      //checar o retorno do firebase
      print(json.decode(response.body));
      /*sabemos que o Firebase retorna um Map<String, Map<>>
       porém o Dart não reconhece o Map de Map por isso usamos dynamic*/
      final productsJson = json.decode(response.body) as Map<String, dynamic>;

      if (productsJson.isEmpty) {
        return;
      }
      //após checarmos se existem produtos, vamos verificar quais são os favoritos desse usuário
      url = Uri.parse(
          'https://shop-app-b6bd5-default-rtdb.firebaseio.com/userFavorites/$_userId.json?auth=$_authToken');

      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProducts = [];
      /*executamos uma iteração para cada map
      e adicionamos a variável a uma lista temporária.
      */
      productsJson.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          /*setamos baseado na requisição dos favoritos
          se favoriteData is null, então é false, porém se o produtoId não existir
          ele é falso também*/
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      HttpException('Could not connect');
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'shop-app-b6bd5-default-rtdb.firebaseio.com?auth=$_authToken/products.json');
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
            'creatorId': _userId,
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

  Future<void> update(String id, Product newProduct) async {
    //encontramos o indice do produto
    print('ID DO UPDATE: $id');
    final url = Uri.parse(
        'https://shop-app-b6bd5-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken');
    var prodIndex = _items.indexWhere((prod) => prod.id == id);
    //testamos para saber se o produto foi encontrado
    //pois o retorno de não encontrado é -1
    if (prodIndex >= 0) {
      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          },
        ),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('product not find');
    }
  }

  //deleção otimistica = fazemos o rollback se der ruim
  //antes de deletar um item, o copiamos
  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://shop-app-b6bd5-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken');

    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    //removemos o produto da lista, porém não dá memória
    _items.removeAt(existingProductIndex);
    notifyListeners();
    //o método delete não throw error
    //por isso não usamos o catch e por isso temos nossa propria Exception
    var response = await http.delete(url);

    if (response.statusCode >= 400) {
      //rollback em caso de qualquer erro
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not connect');
    }
    //remove da memória, caso dê tudo certo
    existingProduct.dispose();
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

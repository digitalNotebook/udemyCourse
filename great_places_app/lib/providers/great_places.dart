import 'dart:io';

import 'package:flutter/foundation.dart';

import '../helpers/db_helpers.dart';
import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(String title, File image) {
    //criamos um novo Place
    var newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      location: null,
      image: image,
    );
    _items.add(newPlace);
    notifyListeners();
    //o map daqui tem que coincidir com a sql query de dbHelpers insert
    DBHelpers.insert(
      'places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image_path': newPlace.image.path,
      },
    );
  }

  Future<void> fetchAndSetPlaces() async {
    //mesmo nome da tabela definida em addPlace()
    final placesList = await DBHelpers.getData('places');

    //transformamos o mapa em uma lista com a ajuda do map
    _items = placesList
        .map(
          (item) => Place(
            id: item['id'],
            title: item['title'],
            image: File(item['image_path']),
            location: null,
          ),
        )
        .toList();
    notifyListeners();
  }
}

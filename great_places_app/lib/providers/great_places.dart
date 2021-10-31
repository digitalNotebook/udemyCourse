import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:great_places_app/helpers/location_helpers.dart';

import '../helpers/db_helpers.dart';
import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(
      String title, File image, PlaceLocation pickedLocation) async {
    //Para o location usamos o LocationHelper para traduzir a latidude e longitude
    final placeAddress = await LocationHelper.getPlaceAddress(
      pickedLocation.latitude,
      pickedLocation.longitude,
    );
    //criamos um novo objeto passando o endereço do http request para a API do Google
    final updatedLocation = PlaceLocation(
      latitude: pickedLocation.latitude,
      longitude: pickedLocation.longitude,
      address: placeAddress,
    );
    //criamos um novo Place
    var newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      location: updatedLocation,
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
        'loc_lat': newPlace.location!.latitude,
        'loc_lng': newPlace.location!.longitude,
        'address': newPlace.location!.address,
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
            location: PlaceLocation(
              latitude: item['loc_lat'],
              longitude: item['loc_lng'],
              address: item['address'],
            ),
          ),
        )
        .toList();
    notifyListeners();
  }
}

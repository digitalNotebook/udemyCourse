import 'package:flutter/material.dart';
import 'package:great_places_app/models/place.dart';
import 'package:great_places_app/screens/map_screen.dart';

import 'package:provider/provider.dart';

import '../providers/great_places.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const routeName = '/place-detail';

  const PlaceDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var id = ModalRoute.of(context)!.settings.arguments as String;
    var selectedPlace =
        Provider.of<GreatPlaces>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace.title),
      ),
      body: Column(
        children: [
          //Container que irá wrap de image
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              selectedPlace.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          //espaço entre o container e o texto
          SizedBox(
            height: 10,
          ),
          //ADDRESS
          Text(
            selectedPlace.location!.address as String,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              print('Testa: ${selectedPlace.location == null}');
              print('Testa: ${selectedPlace.location!.address}');
              print('Testa: ${selectedPlace.location!.latitude}');
              print('Testa: ${selectedPlace.location!.longitude}');

              Navigator.of(context).push(
                MaterialPageRoute(
                  //muda um pouco a aparencia da página
                  fullscreenDialog: true,
                  builder: (ctx) => MapScreen(
                    initialLocation: selectedPlace.location as PlaceLocation,
                    isSelecting: false,
                  ),
                ),
              );
            },
            child: Text('View on Map'),
          ),
        ],
      ),
    );
  }
}

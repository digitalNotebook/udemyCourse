import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../screens/add_place_screen.dart';
import '../providers/great_places.dart';

class PlaceListScreen extends StatelessWidget {
  const PlaceListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlacesScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      //deixamos o consumer saber qual dado ele deve consumir
      body: Consumer<GreatPlaces>(
        //definimos o child do consumer antes
        child: Center(
          child: const Text('Got no places yet, start adding some!'),
        ),
        builder: (ctx, greatPlaces, ch) => greatPlaces.items.length <= 0
            ? ch as Widget
            : ListView.builder(
                itemCount: greatPlaces.items.length,
                itemBuilder: (ctx, index) => ListTile(
                  leading: CircleAvatar(
                    //Podemos usar AssetImage, NetworkImage ou FileImage
                    backgroundImage: FileImage(
                      greatPlaces.items[index].image,
                    ),
                  ),
                  title: Text(greatPlaces.items[index].title),
                  onTap: () {
                    //go to details page
                  },
                ),
              ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:great_places_app/screens/place_detail_screen.dart';

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
      body: FutureBuilder(
        //apenas carregamos os dados
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        //testamos se estamos carregando os dados ainda
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            //deixamos o consumer saber qual dado ele deve consumir
            : Consumer<GreatPlaces>(
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
                          subtitle: Text(greatPlaces
                              .items[index].location!.address as String),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              PlaceDetailScreen.routeName,
                              arguments: greatPlaces.items[index].id,
                            );
                          },
                        ),
                      ),
              ),
      ),
    );
  }
}

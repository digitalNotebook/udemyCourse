import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places_app/screens/map_screen.dart';

import 'package:location/location.dart';
import '../helpers/location_helpers.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectedPlace;

  const LocationInput(this.onSelectedPlace, {Key? key}) : super(key: key);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  Future<void> _getCurrentUserLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    final staticImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: _locationData.latitude,
      longitude: _locationData.longitude,
    );
    setState(() {
      _previewImageUrl = staticImageUrl;
    });

    widget.onSelectedPlace(_locationData.latitude, _locationData.latitude);
  }

  // Future<bool> _getPermission() async {
  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;

  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }

  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }

  // }

  Future<void> _selectOnMap() async {
    //sabemos que o selectedLocation é LatLng, por conta do pop de MapScreen e setamos no push
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        //muda a animação e substitui o voltar por um cross
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    print(selectedLocation.latitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //mostra um preview do mapa
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
            ),
          ),
          width: double.infinity,
          height: 170,
          //conteudo centralizado verticalmente e horizontalmente
          alignment: Alignment.center,
          child: _previewImageUrl == null
              ? Text(
                  'No image chosen!',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: Icon(Icons.location_on),
              label: Text('Currrent Location'),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(Icons.map),
              label: Text('Select on Map'),
            ),
          ],
        )
      ],
    );
  }
}

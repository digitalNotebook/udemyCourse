import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  const MapScreen(
      {this.initialLocation = const PlaceLocation(
        latitude: 37.422,
        longitude: -122.084,
      ),
      Key? key,
      this.isSelecting = false})
      : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedPosition;

  void _pickedLocation(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
  }

  Completer<GoogleMapController> _controller = Completer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Map'),
        actions: [
          //checamos se estamos em modo seleção
          if (widget.isSelecting)
            //renderizamos o botão se estivermos em modo de seleção
            IconButton(
              onPressed: _pickedPosition == null
                  //desabilitamos o botão senão houver marker
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedPosition);
                    },
              icon: Icon(
                Icons.check,
              ),
            )
        ],
      ),
      //assume a altura e comprimento da parent widget
      //initialCameraPosition: a posição inicial quando o app starta
      //vamos exibir a localização selecionada, assim como permitir uma
      //nova localização
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        initialCameraPosition: CameraPosition(
          zoom: 16,
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
        ),
        onTap: widget.isSelecting ? _pickedLocation : null,
        markers: _pickedPosition == null
            ? {}
            : {
                Marker(
                  markerId: MarkerId('m1'),
                  position: _pickedPosition as LatLng,
                )
              },
      ),
    );
  }
}

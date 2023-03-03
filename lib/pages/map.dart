import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const LatLng currentLocation = LatLng(48.866667, 2.33333);

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _mapController;
  Map<String, Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(initialCameraPosition: const CameraPosition(
        target: currentLocation, 
        zoom: 12,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
          addMaker('test', currentLocation);
        },
        markers: _markers.values.toSet(),
        ),
    );
  }

  // TODO: ICI ajouter les Longitude pris depuis la base
  //Création de marqueur avec id et la postion aka la LatLng
  addMaker(String id, LatLng location){
    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
      infoWindow: InfoWindow(
        title: 'ICI LE NOM CONSEILLER',
        snippet: 'DESCRIPTION'
      ),
      );

      _markers[id] = marker;
      setState(() {
        
      });
  }
}

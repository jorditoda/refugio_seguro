import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:refugio_seguro/models/shelter.dart';

Future<Position> getCurrentLocation() {
  Permission.locationAlways.request();
  return Geolocator.getCurrentPosition(
      locationSettings:
          const LocationSettings(accuracy: LocationAccuracy.best));
}

Marker convertShelterToMarker(Shelter shelter) {
  //On tab show more info?
  return Marker(
      point: LatLng(shelter.location.latitud, shelter.location.longitud),
      child: Icon(Icons.location_on_outlined, key: UniqueKey()));
}


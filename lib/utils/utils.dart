import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:refugio_seguro/models/shelter.dart';

Future<Position> getCurrentLocation() {
  return Geolocator.getCurrentPosition(
      locationSettings:
          const LocationSettings(accuracy: LocationAccuracy.best));
}

Marker convertShelterToMarker(Shelter shelter) {
  //On tab show more info?
  return Marker(
      point: LatLng(shelter.location.latitude, shelter.location.longitude),
      child: Icon(Icons.location_on_outlined, key: UniqueKey()));
}

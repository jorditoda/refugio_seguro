import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:refugio_seguro/models/shelter.dart';

class ShelterMarker extends Marker {
  ShelterMarker({required this.event})
      : super(
          child: Icon(
            Icons.house_rounded,
            key: UniqueKey(),
            color: Colors.green,
          ),
          point: LatLng(event.location!.latitud!, event.location!.longitud!),
        );
  final Shelter event;
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

Future<Position> getCurrentLocation() {
  Permission.locationAlways.request();
  return Geolocator.getCurrentPosition(
      locationSettings:
          const LocationSettings(accuracy: LocationAccuracy.best));
}

Marker myLocationMarker(Position position) {
  return Marker(
      point: LatLng(position.latitude, position.longitude),
      child: Icon(
        Icons.location_on,
        key: UniqueKey(),
        color: Colors.greenAccent,
      ));
}

Future<void> initLocation(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    _showDialog(context, "Permiso geolocalizacion desabilitado",
        "Hay un problema con los permisos de geolocalizacion, comprueba tu dispositivo");
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      _showDialog(context, "Permiso geolocalizacion denegado",
          "Hay un problema con los permisos de geolocalizacion, comprueba tu dispositivo");
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    _showDialog(context, "Permiso geolocalizacion denegado",
        "Hay un problema con los permisos de geolocalizacion, comprueba los ajustes de tu dispositivo");
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
}

_showDialog(BuildContext context, String titleToShow, String textToShow) {
  showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titleToShow),
      content: Text(textToShow),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('ok'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Ajustes dispositivo'),
        ),
      ],
    ),
  );
}

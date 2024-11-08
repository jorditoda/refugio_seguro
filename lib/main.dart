import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/src/layer/marker_layer/marker_layer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:refugio_seguro/api/connector_api.dart';
import 'package:refugio_seguro/utils/utils.dart';
import 'package:refugio_seguro/widget/map_widget.dart';

import 'models/shelter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Refugio Seguro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _loading = true;
  double latToCenter = 39.466667;
  double longToCenter = -0.375000;
  List<Marker> markersToShow = List.empty(growable: true);

  @override
  void initState() {
    _initLocation();
    _getShelters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Stack(
        children: [
          MapWidget(latToCenter, longToCenter, markersToShow),
          if (_loading) const CircularProgressIndicator(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addShelter,
        tooltip: 'Añadir refugio',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addShelter() {
    floatingSnackBar(
      message: "Under construction",
      context: context,
      textColor: Colors.green,
      textStyle: const TextStyle(color: Colors.red),
      duration: const Duration(seconds: 6),
      backgroundColor: Colors.lightGreen,
    );
  }

  Future<void> _getShelters() async {
    Position p = await getCurrentLocation();
    getShelterByMyLocation(p).then((onValue) {
      for (Shelter shelter in onValue) {
        markersToShow.add(convertShelterToMarker(shelter));
      }
      setState(() {
        _loading = false;
      });
    });
  }

  _showDialog(String titleToShow, String textToShow) {
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
            child: Text('ok'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Ajustes dispositivo'),
          ),
        ],
      ),
    );
  }

  Future<void> _initLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showDialog("Permiso geolocalizacion desabilitado",
          "Hay un problema con los permisos de geolocalizacion, comprueba tu dispositivo");
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showDialog("Permiso geolocalizacion denegado",
            "Hay un problema con los permisos de geolocalizacion, comprueba tu dispositivo");
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showDialog("Permiso geolocalizacion denegado",
          "Hay un problema con los permisos de geolocalizacion, comprueba los ajustes de tu dispositivo");
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    _getShelters();
  }
}

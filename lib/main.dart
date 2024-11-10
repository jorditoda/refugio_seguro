import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:refugio_seguro/pages/map_page.dart';

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
  @override
  void initState() {
    _initLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MapPage(),
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
}

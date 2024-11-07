import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/src/layer/marker_layer/marker_layer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:refugio_seguro/api/connector_api.dart';
import 'package:refugio_seguro/widget/map_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _loading = true;
  double latToCenter = 39.466667;
  double longToCenter = -0.375000;
  List<Marker> markersToShow = List.empty(growable: true);

  @override
  void initState() {
    Permission.locationAlways.request();
    _getShelters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          if (_loading) const CircularProgressIndicator(),
          MapWidget(latToCenter, longToCenter, markersToShow),
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

  void _getShelters() {
    getShelterByMyLocation();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:refugio_seguro/api/connector_api.dart';
import 'package:refugio_seguro/models/shelter.dart';
import 'package:refugio_seguro/models/shelter_model_marker.dart';
import 'package:refugio_seguro/pages/add_shelter_page.dart';
import 'package:refugio_seguro/utils/utils.dart';
import 'package:refugio_seguro/widget/map_widget.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool _loadingLocation = false;
  bool _loadingShelters = false;
  double latToCenter = 39.466667;
  double longToCenter = -0.375000;
  List<Marker> markersToShow = List.empty(growable: true);
  late Position actualPosition;
  MapController _mapController = MapController();

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(latToCenter, longToCenter, markersToShow, _mapController),
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
                alignment: Alignment.topRight,
                child: FloatingActionButton(
                    heroTag: "btn3",
                    onPressed: _updateShelters,
                    child: _loadingShelters
                        ? const CircularProgressIndicator()
                        : const Icon(Icons.update))),
          ))
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: _addShelter,
            tooltip: 'Añadir refugio',
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            height: 12,
          ),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: _updateMyLocation,
            tooltip: 'Actualizar mi ubicación',
            child: _loadingLocation
                ? const CircularProgressIndicator()
                : const Icon(Icons.near_me),
          ),
          // const SizedBox(
          //   height: 12,
          // ),
          // FloatingActionButton(
          //   heroTag: "btn3",
          //   onPressed: _updateShelters,
          //   tooltip: 'Actualizar refugios',
          //   child: _loadingShelters
          //       ? const CircularProgressIndicator()
          //       : const Icon(Icons.update),
          // ),
        ],
      ),
    );
  }

  void _addShelter() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddShelterPage()),
    );
  }

  Future<void> _getShelters(Position position) async {
    getSheltersByLocation(position).then((onValue) {
      for (Shelter shelter in onValue) {
        markersToShow.add(
          ShelterMarker(event: shelter),
        );
      }
    }).whenComplete(() {
      setState(() {
        _loadingShelters = false;
      });
    });
  }

  Future<void> _updateMyLocation() async {
    setState(() {
      _loadingLocation = true;
    });
    actualPosition = await getCurrentLocation();
    setState(() {
      latToCenter = actualPosition.latitude;
      longToCenter = actualPosition.longitude;
      _mapController.move(LatLng(latToCenter, longToCenter), 18.0);
      var marketers =
          markersToShow.whereType<ShelterMarker>().toList(growable: true);
      markersToShow.add(myLocationMarker(actualPosition));
      markersToShow.addAll(marketers);
      _loadingLocation = false;
    });
  }

  void _updateShelters() {
    setState(() {
      _loadingShelters = true;
    });
    _getShelters(actualPosition);
  }

  Future<void> _init() async {
    initLocation(context).then((onValue) {
      _updateMyLocation().then((onValue) {
        _getShelters(actualPosition);
      });
    });
  }
}

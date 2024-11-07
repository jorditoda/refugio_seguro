import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  MapWidget(this.latToCenter, this.longToCenter, this.markersToShow,
      {super.key});

  final double latToCenter;
  final double longToCenter;
  final List<Marker> markersToShow;
  // final PopupController _popupLayerController = PopupController();

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: new MapOptions(
        initialCenter: new LatLng(latToCenter, longToCenter),
        initialZoom: 13.0,
        //plugins: [PopupMarkerPlugin()],
        // onTap: (_) => _popupLayerController.hidePopup(),
      ),
      children: [
        TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        MarkerLayer(
          markers: markersToShow,
        ),
      ],
    );
  }
}

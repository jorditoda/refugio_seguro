import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:refugio_seguro/models/shelter_model_marker.dart';
import 'package:refugio_seguro/widget/shelter_maker_popup.dart';

class MapWidget extends StatefulWidget {
  MapWidget(this.latToCenter, this.longToCenter, this.markersToShow,
      this.mapController,
      {super.key});

  final double latToCenter;
  final double longToCenter;
  List<Marker> markersToShow;
  MapController mapController;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final PopupController _popupLayerController = PopupController();

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(widget.latToCenter, widget.longToCenter),
        initialZoom: 13.0,
        onTap: (tapPosition, point) {
          _popupLayerController.hideAllPopups();
        },
      ),
      mapController: widget.mapController,
      children: [
        TileLayer(
          urlTemplate: "https://a.tile.openstreetmap.org/{z}/{x}/{y}.png",
          // subdomains: ['a', 'b', 'c']
        ),
        PopupMarkerLayer(
          options: PopupMarkerLayerOptions(
            markers: widget.markersToShow,
            popupController: _popupLayerController,
            popupDisplayOptions: PopupDisplayOptions(
              builder: (BuildContext context, Marker marker) {
                if (marker is ShelterMarker) {
                  return ShelterMakerPopup(event: marker.event);
                }
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(Icons.location_on),
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Latitud: ${widget.latToCenter}"),
                            Text("Longitud: ${widget.latToCenter}")
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

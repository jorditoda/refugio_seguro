import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refugio_seguro/models/location.dart';
import 'package:refugio_seguro/models/shelter.dart';
import 'package:refugio_seguro/pages/update_shelter_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ShelterMakerPopup extends StatefulWidget {
  const ShelterMakerPopup({super.key, required this.event});

  final Shelter event;

  @override
  _ShelterMakerPopupState createState() => _ShelterMakerPopupState(event);
}

class _ShelterMakerPopupState extends State<ShelterMakerPopup> {
  final Shelter event;

  _ShelterMakerPopupState(this.event);

  @override
  Widget build(BuildContext context) {
    return
        // InkWell(
        // child:
        SizedBox(
      width: 250,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: TextButton.icon(
                  onPressed: () => _showDialog(event),
                  icon: const Icon(Icons.house),
                  label: Text(event.name!),
                  // iconAlignment: _iconAlignment,
                ),
              ),
              TextButton.icon(
                onPressed: () => _showDialog(event),
                icon: const Icon(Icons.location_city),
                label: Text(
                    "${event.location!.streetName!} ${event.location!.city!}"),
              ),
              TextButton.icon(
                onPressed: () => _showDialog(event),
                icon: const Icon(Icons.location_on),
                label: Text(
                    "${event.location!.latitud!} ${event.location!.longitud!}"),
              ),
              TextButton.icon(
                onPressed: () => _showDialog(event),
                icon: const Icon(Icons.reduce_capacity),
                label: Text("Capacidad actual ${event.currentAvailability!}"),
              ),
              Center(
                child: OutlinedButton.icon(
                  onPressed: () => _showDialog(event),
                  icon: const Icon(Icons.info_outline),
                  label: const Text("Más Información"),
                ),
              )
            ],
          ),
        ),
      ),
    );
    // onTap: () => _showDialog(event),
    // );
  }

  _showDialog(Shelter shelter) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: Text(shelter.name!)),
        content: IntrinsicHeight(
          child: Column(
            children: [
              Text("Capacidad màxima: ${shelter.maxCapacity}"),
              Text("Sitios disponibles: ${shelter.currentAvailability}"),
              Text("Contacto: ${shelter.phoneNumber}"),
              Text("Ubicación: ${shelter.location!.getData()}"),
              Text("Longitud: ${shelter.location!.longitud}"),
              Text("Latitud: ${shelter.location!.latitud}"),
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    _copyLocation(shelter.location!);
                  },
                  icon: Icon(Icons.copy),
                  label: Text("Copiar Ubicación"),
                ),
              ),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _redirectToPhone(shelter.phoneNumber!);
                  },
                  icon: Icon(Icons.phone_forwarded),
                  label: Text("Llamar"),
                ),
              )
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  _redirectToUpdatePage(shelter);
                },
                label: Text('Editar'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                label: Text('Salir'),
              )
            ],
          ),
        ],
      ),
    );
  }

  _copyLocation(Location location) async {
    await Clipboard.setData(ClipboardData(text: location.getData()));
    Navigator.pop(context);
    floatingSnackBar(
      message: "Ubicación copiada",
      context: context,
      textColor: Colors.black,
      textStyle: const TextStyle(color: Colors.green),
      duration: const Duration(seconds: 6),
      backgroundColor: Color.fromARGB(255, 220, 234, 236),
    );
  }

  _redirectToPhone(String phoneNumber) {
    launchUrl(Uri.parse("tel://$phoneNumber"));
    Navigator.pop(context);
  }

  void _redirectToUpdatePage(Shelter shelter) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UpdateShelterPage(
                shelterToBeUpdated: shelter,
              )),
    );
  }
}

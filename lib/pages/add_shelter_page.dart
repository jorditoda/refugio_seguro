import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refugio_seguro/api/connector_api.dart';
import 'package:refugio_seguro/models/location.dart';
import 'package:refugio_seguro/models/shelter.dart';
import 'package:refugio_seguro/utils/utils.dart';

class AddShelterPage extends StatefulWidget {
  const AddShelterPage({super.key});

  @override
  State<AddShelterPage> createState() => _AddShelterPage();
}

class _AddShelterPage extends State<AddShelterPage> {
  Shelter shelterToBeCreated = Shelter();
  double latitud = 0.0;
  double longitud = 0.0;
  var city;
  var streetName;
  var door;
  TextEditingController _latitudeController =
      new TextEditingController(text: '...');
  TextEditingController _longitudeController =
      new TextEditingController(text: '...');

  bool loading = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loading = false;
    _getPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Añadir refugio",
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 30),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onSaved: (value) {
                              shelterToBeCreated.name = value;
                            },
                            decoration: _decoration("Nombre del refugio"),
                            validator: _validator,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onSaved: (value) {
                              shelterToBeCreated.phoneNumber = value;
                            },
                            keyboardType: TextInputType.number,
                            decoration:
                                _decoration("Número de teléfono de contacto"),
                            validator: _validator,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onSaved: (value) {
                              shelterToBeCreated.maxCapacity =
                                  int.parse(value!);
                            },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            decoration: _decoration("Capacidad máxima"),
                            validator: _validator,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onSaved: (value) {
                              city = value!;
                            },
                            decoration: _decoration("Ciudad"),
                            validator: _validator,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onSaved: (value) {
                              streetName = value!;
                            },
                            decoration: _decoration("Calle"),
                            validator: _validator,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onSaved: (value) {
                              door = value!;
                            },
                            decoration: _decoration("Número"),
                            validator: _validator,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _longitudeController,
                                  onSaved: (value) {
                                    longitud = double.parse(value!);
                                  },
                                  decoration: _decoration("Longitud"),
                                  validator: _validator,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _latitudeController,
                                  onSaved: (value) {
                                    latitud = double.parse(value!);
                                  },
                                  decoration: _decoration("Latitud"),
                                  validator: _validator,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
      floatingActionButton: _createButton(),
    );
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este Campo Es Obligatorio';
    }
    return null;
  }

  InputDecoration _decoration(String title) {
    return InputDecoration(
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      labelText: title,
    );
  }

  Widget _createButton() {
    return FilledButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          setState(() {
            loading = true;
          });
          _setLocation();
          saveShelter(shelterToBeCreated).then((onValue) {
            setState(() {
              loading = false;
            });
            Navigator.pop(context);
            floatingSnackBar(
              message: "Refugio Creado",
              context: context,
              textColor: Colors.green,
              textStyle: const TextStyle(color: Colors.red),
              duration: const Duration(seconds: 6),
              backgroundColor: Color.fromARGB(255, 220, 234, 236),
            );
          }).onError<Exception>((e, _) {
            print(e.toString());
            floatingSnackBar(
              message: e.toString(),
              context: context,
              textColor: Colors.black,
              textStyle: const TextStyle(color: Colors.red),
              duration: const Duration(seconds: 6),
              backgroundColor: Color.fromARGB(255, 220, 234, 236),
            );
          }).whenComplete(() {
            Navigator.pop(context);
            setState(() {
              loading = false;
            });
          });
        }
      },
      child: const Text('Crear'),
    );
  }

  void _setLocation() {
    shelterToBeCreated.location = Location(
        latitud: latitud,
        longitud: longitud,
        city: city,
        streetName: streetName,
        door: door);
  }

  _getPosition() {
    getCurrentLocation().then((onValue) {
      setState(() {
        latitud = onValue.latitude;
        longitud = onValue.longitude;
        _latitudeController.value = TextEditingValue(text: latitud.toString());
        _longitudeController.value =
            TextEditingValue(text: longitud.toString());
      });
    });
  }
}

import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refugio_seguro/api/connector_api.dart';
import 'package:refugio_seguro/models/shelter.dart';
import 'package:refugio_seguro/utils/utils.dart';

class UpdateShelterPage extends StatefulWidget {
  const UpdateShelterPage({super.key, required this.shelterToBeUpdated});

  final Shelter shelterToBeUpdated;

  @override
  State<UpdateShelterPage> createState() =>
      _UpdateShelterPage(shelterToBeUpdated);
}

class _UpdateShelterPage extends State<UpdateShelterPage> {
  Shelter shelterToBeUpdated;

  _UpdateShelterPage(this.shelterToBeUpdated);

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
    _initPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Actualizar refugio",
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
                              shelterToBeUpdated.name = value;
                            },
                            initialValue: shelterToBeUpdated.name,
                            decoration: _decoration("Nombre del refugio"),
                            validator: _validator,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onSaved: (value) {
                              shelterToBeUpdated.phoneNumber = value;
                            },
                            initialValue: shelterToBeUpdated.phoneNumber,
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
                              shelterToBeUpdated.maxCapacity =
                                  int.parse(value!);
                            },
                            initialValue:
                                shelterToBeUpdated.maxCapacity!.toString(),
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
                              shelterToBeUpdated.location!.city = value!;
                            },
                            initialValue: shelterToBeUpdated.location!.city,
                            decoration: _decoration("Ciudad"),
                            validator: _validator,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onSaved: (value) {
                              shelterToBeUpdated.location!.streetName = value!;
                            },
                            initialValue:
                                shelterToBeUpdated.location!.streetName,
                            decoration: _decoration("Calle"),
                            validator: _validator,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onSaved: (value) {
                              shelterToBeUpdated.location!.door = value!;
                            },
                            initialValue: shelterToBeUpdated.location!.door,
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
                                    shelterToBeUpdated.location!.longitud =
                                        double.parse(value!);
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
                                    shelterToBeUpdated.location!.latitud =
                                        double.parse(value!);
                                  },
                                  decoration: _decoration("Latitud"),
                                  validator: _validator,
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: _getPosition,
                              child: const Text("Actualizar Ubicación")),
                        )
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
          setState(() {
            loading = true;
          });
          _formKey.currentState!.save();
          updateShelter(shelterToBeUpdated).then((onValue) {
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
              backgroundColor: const Color.fromARGB(255, 220, 234, 236),
            );
          }).onError<Exception>((e, _) {
            if (kDebugMode) {
              print(e.toString());
            }
            floatingSnackBar(
              message: e.toString(),
              context: context,
              textColor: Colors.black,
              textStyle: const TextStyle(color: Colors.red),
              duration: const Duration(seconds: 6),
              backgroundColor: const Color.fromARGB(255, 220, 234, 236),
            );
          }).whenComplete(() {
            Navigator.pop(context);
            setState(() {
              loading = false;
            });
          });
        }
      },
      child: const Text('Actualizar'),
    );
  }

  _getPosition() {
    getCurrentLocation().then((onValue) {
      setState(() {
        _latitudeController.value =
            TextEditingValue(text: onValue.latitude.toString());
        _longitudeController.value =
            TextEditingValue(text: onValue.longitude.toString());
      });
    });
  }

  _initPosition() {
    _latitudeController.value =
        TextEditingValue(text: shelterToBeUpdated.location!.latitud.toString());
    _longitudeController.value = TextEditingValue(
        text: shelterToBeUpdated.location!.longitud.toString());
  }
}

import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:refugio_seguro/env/env.dart';
import 'package:refugio_seguro/models/shelter.dart';

Map<String, String> headers = {
  "Content-Type": "application/json",
  'Accept': '*/*'
};

const String shelterPath = '/shelters';

Future<List<Shelter>> getSheltersByLocation(Position p) async {
  print("Base url: " + Env.API_URL);
  var url = Uri.parse(Env.API_URL + shelterPath);

  final response = await http.get(url, headers: headers);
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body)["_embedded"];
    return jsonResponse['shelters']
            .map<Shelter>((v) => Shelter.fromJson(v))
            .toList() ??
        [];
  }
  return [];
  //  return [
  //   Shelter.withParams(
  //       id: 1,
  //       name: "name",
  //       phoneNumber: "654321654",
  //       maxCapacity: 2,
  //       currentAvailability: 1,
  //       roomsQty: 1,
  //       bathsQty: 1,
  //       washingMachinesQty: 1,
  //       location: Location(
  //           id: 2,
  //           latitud: p.latitude,
  //           longitud: p.longitude,
  //           postalCode: "45612",
  //           city: "city",
  //           streetName: "streetName"),
  //       food: Food(),
  //       cleaningUtilities: CleaningUtility(),
  //       toiletries: Toiletry(id: 2))
  // ];
}

Future<Shelter> saveShelter(Shelter shelterToBeCreated) async {
  var url = Uri.parse(Env.API_URL + shelterPath);

  print(jsonEncode(shelterToBeCreated.toJson()));
  final response = await http.post(url,
      headers: headers, body: jsonEncode(shelterToBeCreated.toJson()));
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body)["_embedded"];
    return Shelter.fromJson(jsonResponse['shelter']);
  }
  throw Future.error(jsonDecode(response.body));
}

Future<Shelter> updateShelter(Shelter shelterToBeUpdated) async {
  var url = Uri.parse(Env.API_URL + '$shelterPath/${shelterToBeUpdated.id!}');

  final response = await http.put(url,
      headers: headers, body: jsonEncode(shelterToBeUpdated.toJson()));
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body)["_embedded"];
    return Shelter.fromJson(jsonResponse['shelter']);
  }
  throw Future.error(jsonDecode(response.body));
}


import 'package:geolocator/geolocator.dart';
import 'package:refugio_seguro/models/shelter.dart';
import 'package:refugio_seguro/utils/utils.dart';

Future<List<Shelter>> getShelterByMyLocation() async {
  Position p = await getCurrentLocation();
  //api call
  return [Shelter(p)];
}

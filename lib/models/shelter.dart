import 'package:json_annotation/json_annotation.dart';
import 'package:refugio_seguro/models/cleaning_utility.dart';
import 'package:refugio_seguro/models/food.dart';
import 'package:refugio_seguro/models/location.dart';
import 'package:refugio_seguro/models/toiletry.dart';

part 'shelter.g.dart';

@JsonSerializable()
class Shelter {
  int? id;
  String? name;
  String? phoneNumber;
  int? maxCapacity;
  int? currentAvailability;
  int? roomsQty;
  int? bathsQty;
  int? washingMachinesQty;
  Location? location;
  Food? food;
  CleaningUtility? cleaningUtilities;
  Toiletry? toiletries;

  Shelter();

  Shelter.withParams({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.maxCapacity,
    required this.currentAvailability,
    required this.roomsQty,
    required this.bathsQty,
    required this.washingMachinesQty,
    required this.location,
    required this.food,
    required this.cleaningUtilities,
    required this.toiletries,
  });

  factory Shelter.fromJson(Map<String, dynamic> json) =>
      _$ShelterFromJson(json);

  Map<String, dynamic> toJson() => _$ShelterToJson(this);
}

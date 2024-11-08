import 'package:json_annotation/json_annotation.dart';
import 'package:refugio_seguro/models/cleaning_utility.dart';
import 'package:refugio_seguro/models/food.dart';
import 'package:refugio_seguro/models/location.dart';
import 'package:refugio_seguro/models/toiletry.dart';

part 'shelter.g.dart';

@JsonSerializable()
class Shelter {
  int id;

  String name;

  final int maxCapacity;

  final int currentAvailability;

  final int roomsQty;

  final int bathsQty;

  final int washingMachinesQty;

  final Location location;

  final Food food;

  final CleaningUtility cleaningUtilities;

  final Toiletry toiletries;

  Shelter({
    required this.id,
    required this.name,
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

  factory Shelter.fromJson(Map<String, dynamic> json) => _$ShelterFromJson(json);
  Map<String, dynamic> toJson() => _$ShelterToJson(this);
}


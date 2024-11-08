import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
  final int id;

  final double latitud;

  final double longitud;

  final String postalCode;

  final String city;

  final String streetName;

  final int? flat;

  final String? door;

  final String? other;

  Location({
    required this.id,
    required this.latitud,
    required this.longitud,
    required this.postalCode,
    required this.city,
    required this.streetName,
    this.flat,
    this.door,
    this.other,
  });

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}


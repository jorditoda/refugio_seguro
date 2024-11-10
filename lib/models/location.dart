import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
  final int? id;
  double? latitud;
  double? longitud;
  String? postalCode;
  String? city;
  String? streetName;
  int? flat;
  String? door;
  String? other;

  Location({
    this.id,
    required this.latitud,
    required this.longitud,
    this.postalCode,
    required this.city,
    required this.streetName,
    this.flat,
    this.door,
    this.other,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  String getData() {
    return "$streetName ${door ?? ""} ${flat ?? ""}, $city $postalCode, España";
  }
}

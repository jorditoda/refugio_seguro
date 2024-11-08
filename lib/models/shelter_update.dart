import 'package:json_annotation/json_annotation.dart';
import 'package:refugio_seguro/models/shelter.dart';
import 'package:refugio_seguro/models/user.dart';

part 'shelter_update.g.dart';

@JsonSerializable()
class ShelterUpdate {
  final int id;

  final String? shelterFrom;

  final String? shelterTo;

  final User user;

  final Shelter shelter;

  ShelterUpdate({
    required this.id,
    this.shelterFrom,
    this.shelterTo,
    required this.user,
    required this.shelter,
  });

  factory ShelterUpdate.fromJson(Map<String, dynamic> json) => _$ShelterUpdateFromJson(json);
  Map<String, dynamic> toJson() => _$ShelterUpdateToJson(this);
}


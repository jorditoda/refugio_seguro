import 'package:json_annotation/json_annotation.dart';

part 'cleaning_utility.g.dart';

@JsonSerializable()
class CleaningUtility {
  int? id;

  int? washingMachingDetergent;

  int? dishwasherMachineDetergent;

  int? dishwasherSoap;

  int? bleach;

  int? ammonia;

  int? insecticide;

  int? wcCleaningSoap;

  int? toiletCleaningSoap;

  String? other;

  CleaningUtility({
    this.id,
    this.washingMachingDetergent,
    this.dishwasherMachineDetergent,
    this.dishwasherSoap,
    this.bleach,
    this.ammonia,
    this.insecticide,
    this.wcCleaningSoap,
    this.toiletCleaningSoap,
    this.other,
  });

  factory CleaningUtility.fromJson(Map<String, dynamic> json) => _$CleaningUtilityFromJson(json);
  Map<String, dynamic> toJson() => _$CleaningUtilityToJson(this);
}


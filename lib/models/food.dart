import 'package:json_annotation/json_annotation.dart';

part 'food.g.dart';

@JsonSerializable()
class Food {
  int? id;

  int? fruitQty;

  String? fruidUnit;

  int? meatQty;

  String? meatUnit;

  int? vegetablesQty;

  String? vegetablesUnit;

  int? fishQty;

  String? fishUnit;

  int? riceQty;

  String? riceUnit;

  int? pastaQty;

  String? pastaUnit;

  Food({
    this.id,
    this.fruitQty,
    this.fruidUnit,
    this.meatQty,
    this.meatUnit,
    this.vegetablesQty,
    this.vegetablesUnit,
    this.fishQty,
    this.fishUnit,
    this.riceQty,
    this.riceUnit,
    this.pastaQty,
    this.pastaUnit,
  });

  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);
  Map<String, dynamic> toJson() => _$FoodToJson(this);
}


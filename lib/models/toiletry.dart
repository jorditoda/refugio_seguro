import 'package:json_annotation/json_annotation.dart';

part 'toiletry.g.dart';

@JsonSerializable()
class Toiletry {
  final int id;

  final int? wcPaper;

  final int? tissues;

  final int? pads;

  final int? tampons;

  final int? showerGel;

  final int? handSoap;

  final int? shampoo;

  final int? shavingSoap;

  final int? razors;

  final int? babyDiapers;

  final int? adultDiapers;

  final String? other;

  Toiletry({
    required this.id,
    this.wcPaper,
    this.tissues,
    this.pads,
    this.tampons,
    this.showerGel,
    this.handSoap,
    this.shampoo,
    this.shavingSoap,
    this.razors,
    this.babyDiapers,
    this.adultDiapers,
    this.other,
  });

  factory Toiletry.fromJson(Map<String, dynamic> json) =>
      _$ToiletryFromJson(json);

  Map<String, dynamic> toJson() => _$ToiletryToJson(this);
}

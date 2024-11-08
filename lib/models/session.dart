import 'package:json_annotation/json_annotation.dart';
import 'package:refugio_seguro/models/user.dart';

part 'session.g.dart';

@JsonSerializable()
class Session {
  final int id;

  final String token;

  final DateTime validUntil;

  final User user;

  Session({
    required this.id,
    required this.token,
    required this.validUntil,
    required this.user,
  });

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
  Map<String, dynamic> toJson() => _$SessionToJson(this);
}


import 'package:houser/models/User.dart';
import 'package:json_annotation/json_annotation.dart';
part 'AuthResult.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthResult{
  AuthResult(this.user, this.token, this.success, this.errors);

  User? user;
  String? token;
  bool? success;
  List<String>? errors;

  factory AuthResult.fromJson(Map<String, dynamic> json) => _$AuthResultFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResultToJson(this);
}
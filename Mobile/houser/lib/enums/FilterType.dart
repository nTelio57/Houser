import 'package:json_annotation/json_annotation.dart';

enum FilterType{
@JsonValue(0) room,
@JsonValue(1) user,
@JsonValue(2) none,
}
import 'package:json_annotation/json_annotation.dart';

enum SleepType{
@JsonValue(0) morning,
@JsonValue(1) none,
@JsonValue(2) evening,
}
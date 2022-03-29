import 'package:json_annotation/json_annotation.dart';

enum BedType{
  @JsonValue(0) noBed,
  @JsonValue(1) single,
  @JsonValue(2) double,
  @JsonValue(3) sofa,
}
import 'package:houser/enums/FilterType.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Filter.g.dart';

@JsonSerializable()
class Filter {
  Filter(this.id, this.userId, this.filterType);

  int id;
  String userId;
  FilterType filterType = FilterType.none;

  factory Filter.fromJson(Map<String, dynamic> json) => _$FilterFromJson(json);

  Map<String, dynamic> toJson() => _$FilterToJson(this);
}
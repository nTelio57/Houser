import 'package:json_annotation/json_annotation.dart';
part 'Filter.g.dart';

@JsonSerializable()
class Filter {
  Filter(this.id, this.userId, this.elo);

  int id;
  String userId;
  int? elo;

  factory Filter.fromJson(Map<String, dynamic> json) => _$FilterFromJson(json);

  Map<String, dynamic> toJson() => _$FilterToJson(this);
}
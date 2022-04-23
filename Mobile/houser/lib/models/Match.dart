import 'package:houser/enums/FilterType.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Match.g.dart';

@JsonSerializable()
class Match{
  Match(this.id, this.filterType, this.swiperId, this.userTargetId, this.roomId);

  int id;
  FilterType filterType;
  String swiperId;
  String userTargetId;
  int? roomId;

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);

  Map<String, dynamic> toJson() => _$MatchToJson(this);
}
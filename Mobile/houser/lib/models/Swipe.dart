import 'package:houser/enums/FilterType.dart';
import 'package:houser/enums/SwipeResult.dart';
import 'package:houser/enums/SwipeType.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Swipe.g.dart';

@JsonSerializable()
class Swipe{
  Swipe(this.id, this.swipeType, this.filterType, this.swiperId, this.userTargetId, this.roomId);

  int id;
  SwipeType swipeType;
  FilterType filterType;
  String swiperId;
  String userTargetId;
  int? roomId;
  SwipeResult? swipeResult;

  factory Swipe.fromJson(Map<String, dynamic> json) => _$SwipeFromJson(json);

  Map<String, dynamic> toJson() => _$SwipeToJson(this);
}
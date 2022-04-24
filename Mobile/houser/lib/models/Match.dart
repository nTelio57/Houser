import 'package:houser/enums/FilterType.dart';
import 'package:houser/models/Room.dart';
import 'package:houser/models/User.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Match.g.dart';

@JsonSerializable()
class Match{
  Match(this.id, this.filterType, this.firstUser, this.secondUser, this.room);

  int id;
  FilterType filterType;
  User firstUser;
  User secondUser;
  Room? room;

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);

  Map<String, dynamic> toJson() => _$MatchToJson(this);

  User getOtherUser(String currentUserId){
    if(firstUser.id == currentUserId) {
      return secondUser;
    }
    return firstUser;
  }
}
import 'package:flutter/cupertino.dart';
import 'package:houser/enums/FilterType.dart';
import 'package:houser/models/Message.dart';
import 'package:houser/models/Room.dart';
import 'package:houser/models/User.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Match.g.dart';

@JsonSerializable()
class Match{
  Match(this.id, this.filterType, this.userOfferer, this.roomOfferer, this.room);
  Match.empty();

  int id = 0;
  FilterType filterType = FilterType.none;
  User userOfferer = User("", "");
  User roomOfferer = User("", "");
  Room? room;

  @JsonKey(ignore: true)
  List<Message> messages = [];

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);

  Map<String, dynamic> toJson() => _$MatchToJson(this);

  User getOtherUser(String currentUserId){
    if(userOfferer.id == currentUserId) {
      return roomOfferer;
    }
    return userOfferer;
  }
}
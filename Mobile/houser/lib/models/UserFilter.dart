import 'package:houser/enums/FilterType.dart';
import 'package:houser/enums/SleepType.dart';
import 'package:houser/models/Filter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'UserFilter.g.dart';

@JsonSerializable()
class UserFilter extends Filter{
  UserFilter(int id, String userId, this.ageFrom, this.ageTo, this.sex, this.animalCount, this.isStudying, this.isWorking, this.isSmoking, this.guestCount, this.partyCount, this.sleepType)
      : super(id, userId, FilterType.user);

  int ageFrom;
  int ageTo;
  int sex;
  int animalCount;
  bool isStudying;
  bool isWorking;
  bool isSmoking;
  int guestCount;
  int partyCount;
  SleepType sleepType;

  factory UserFilter.fromJson(Map<String, dynamic> json) => _$UserFilterFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserFilterToJson(this);
}
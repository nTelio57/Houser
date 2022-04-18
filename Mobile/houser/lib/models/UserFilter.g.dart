// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserFilter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFilter _$UserFilterFromJson(Map<String, dynamic> json) => UserFilter(
      json['id'] as int,
      json['userId'] as String,
      json['elo'] as int?,
      json['ageFrom'] as int,
      json['ageTo'] as int,
      json['sex'] as int,
      json['animalCount'] as int,
      json['isStudying'] as bool,
      json['isWorking'] as bool,
      json['isSmoking'] as bool,
      json['guestCount'] as int,
      json['partyCount'] as int,
      $enumDecode(_$SleepTypeEnumMap, json['sleepType']),
    );

Map<String, dynamic> _$UserFilterToJson(UserFilter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'elo': instance.elo,
      'ageFrom': instance.ageFrom,
      'ageTo': instance.ageTo,
      'sex': instance.sex,
      'animalCount': instance.animalCount,
      'isStudying': instance.isStudying,
      'isWorking': instance.isWorking,
      'isSmoking': instance.isSmoking,
      'guestCount': instance.guestCount,
      'partyCount': instance.partyCount,
      'sleepType': _$SleepTypeEnumMap[instance.sleepType],
    };

const _$SleepTypeEnumMap = {
  SleepType.morning: 0,
  SleepType.none: 1,
  SleepType.evening: 2,
};

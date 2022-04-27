// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Match _$MatchFromJson(Map<String, dynamic> json) => Match(
      json['id'] as int,
      $enumDecode(_$FilterTypeEnumMap, json['filterType']),
      User.fromJson(json['userOfferer'] as Map<String, dynamic>),
      User.fromJson(json['roomOfferer'] as Map<String, dynamic>),
      json['room'] == null
          ? null
          : Room.fromJson(json['room'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MatchToJson(Match instance) => <String, dynamic>{
      'id': instance.id,
      'filterType': _$FilterTypeEnumMap[instance.filterType],
      'userOfferer': instance.userOfferer,
      'roomOfferer': instance.roomOfferer,
      'room': instance.room,
    };

const _$FilterTypeEnumMap = {
  FilterType.room: 0,
  FilterType.user: 1,
  FilterType.none: 2,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Match _$MatchFromJson(Map<String, dynamic> json) => Match(
      json['id'] as int,
      $enumDecode(_$FilterTypeEnumMap, json['filterType']),
      User.fromJson(json['firstUser'] as Map<String, dynamic>),
      User.fromJson(json['secondUser'] as Map<String, dynamic>),
      json['room'] == null
          ? null
          : Room.fromJson(json['room'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MatchToJson(Match instance) => <String, dynamic>{
      'id': instance.id,
      'filterType': _$FilterTypeEnumMap[instance.filterType],
      'firstUser': instance.firstUser,
      'secondUser': instance.secondUser,
      'room': instance.room,
    };

const _$FilterTypeEnumMap = {
  FilterType.room: 0,
  FilterType.user: 1,
  FilterType.none: 2,
};

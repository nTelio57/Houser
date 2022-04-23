// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Match _$MatchFromJson(Map<String, dynamic> json) => Match(
      json['id'] as int,
      $enumDecode(_$FilterTypeEnumMap, json['filterType']),
      json['swiperId'] as String,
      json['userTargetId'] as String,
      json['roomId'] as int?,
    );

Map<String, dynamic> _$MatchToJson(Match instance) => <String, dynamic>{
      'id': instance.id,
      'filterType': _$FilterTypeEnumMap[instance.filterType],
      'swiperId': instance.swiperId,
      'userTargetId': instance.userTargetId,
      'roomId': instance.roomId,
    };

const _$FilterTypeEnumMap = {
  FilterType.room: 0,
  FilterType.user: 1,
  FilterType.none: 2,
};

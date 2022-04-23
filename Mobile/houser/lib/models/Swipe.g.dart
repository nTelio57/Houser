// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Swipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Swipe _$SwipeFromJson(Map<String, dynamic> json) => Swipe(
      json['id'] as int,
      $enumDecode(_$SwipeTypeEnumMap, json['swipeType']),
      $enumDecode(_$FilterTypeEnumMap, json['filterType']),
      json['swiperId'] as String,
      json['userTargetId'] as String,
      json['roomId'] as int?,
    )..swipeResult =
        $enumDecodeNullable(_$SwipeResultEnumMap, json['swipeResult']);

Map<String, dynamic> _$SwipeToJson(Swipe instance) => <String, dynamic>{
      'id': instance.id,
      'swipeType': _$SwipeTypeEnumMap[instance.swipeType],
      'filterType': _$FilterTypeEnumMap[instance.filterType],
      'swiperId': instance.swiperId,
      'userTargetId': instance.userTargetId,
      'roomId': instance.roomId,
      'swipeResult': _$SwipeResultEnumMap[instance.swipeResult],
    };

const _$SwipeTypeEnumMap = {
  SwipeType.dislike: 0,
  SwipeType.like: 1,
};

const _$FilterTypeEnumMap = {
  FilterType.room: 0,
  FilterType.user: 1,
  FilterType.none: 2,
};

const _$SwipeResultEnumMap = {
  SwipeResult.swiped: 0,
  SwipeResult.matched: 1,
};

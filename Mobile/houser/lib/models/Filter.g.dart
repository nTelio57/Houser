// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Filter _$FilterFromJson(Map<String, dynamic> json) => Filter(
      json['id'] as int,
      json['userId'] as String,
      $enumDecode(_$FilterTypeEnumMap, json['filterType']),
    );

Map<String, dynamic> _$FilterToJson(Filter instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'filterType': _$FilterTypeEnumMap[instance.filterType],
    };

const _$FilterTypeEnumMap = {
  FilterType.room: 0,
  FilterType.user: 1,
  FilterType.none: 2,
};

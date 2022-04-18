// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Filter _$FilterFromJson(Map<String, dynamic> json) => Filter(
      json['id'] as int,
      json['userId'] as String,
      json['elo'] as int?,
    );

Map<String, dynamic> _$FilterToJson(Filter instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'elo': instance.elo,
    };

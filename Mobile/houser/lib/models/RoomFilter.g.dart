// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RoomFilter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomFilter _$RoomFilterFromJson(Map<String, dynamic> json) => RoomFilter(
      json['id'] as int,
      json['userId'] as String,
      json['elo'] as int?,
      (json['area'] as num?)?.toDouble(),
      (json['monthlyPrice'] as num?)?.toDouble(),
      json['city'] as String,
      DateTime.parse(json['availableFrom'] as String),
      DateTime.parse(json['availableTo'] as String),
      json['freeRoomCount'] as int?,
      json['bedCount'] as int?,
      json['ruleSmoking'] as bool?,
      json['ruleAnimals'] as bool?,
      json['accommodationTv'] as bool?,
      json['accommodationWifi'] as bool?,
      json['accommodationAc'] as bool?,
      json['accommodationParking'] as bool?,
      json['accommodationBalcony'] as bool?,
      json['accommodationDisability'] as bool?,
    );

Map<String, dynamic> _$RoomFilterToJson(RoomFilter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'elo': instance.elo,
      'area': instance.area,
      'monthlyPrice': instance.monthlyPrice,
      'city': instance.city,
      'availableFrom': instance.availableFrom.toIso8601String(),
      'availableTo': instance.availableTo.toIso8601String(),
      'freeRoomCount': instance.freeRoomCount,
      'bedCount': instance.bedCount,
      'ruleSmoking': instance.ruleSmoking,
      'ruleAnimals': instance.ruleAnimals,
      'accommodationTv': instance.accommodationTv,
      'accommodationWifi': instance.accommodationWifi,
      'accommodationAc': instance.accommodationAc,
      'accommodationParking': instance.accommodationParking,
      'accommodationBalcony': instance.accommodationBalcony,
      'accommodationDisability': instance.accommodationDisability,
    };

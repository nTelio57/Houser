// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Offer _$OfferFromJson(Map<String, dynamic> json) => Offer(
      title: json['title'] as String,
      uploadDate: DateTime.parse(json['uploadDate'] as String),
      address: json['address'] as String,
      city: json['city'] as String,
      freeRoomCount: json['freeRoomCount'] as int,
      totalRoomCount: json['totalRoomCount'] as int,
      isActive: json['isActive'] as bool? ?? false,
      isVisible: json['isVisible'] as bool,
    )
      ..monthlyPrice = (json['monthlyPrice'] as num).toDouble()
      ..utilityBillsRequired = json['utilityBillsRequired'] as bool
      ..availableFrom = DateTime.parse(json['availableFrom'] as String)
      ..availableTo = DateTime.parse(json['availableTo'] as String)
      ..ruleSmoking = json['ruleSmoking'] as bool
      ..ruleAnimals = json['ruleAnimals'] as bool
      ..bedCount = json['bedCount'] as int
      ..bedType = $enumDecode(_$BedTypeEnumMap, json['bedType'])
      ..accommodationTv = json['accommodationTv'] as bool
      ..accommodationWifi = json['accommodationWifi'] as bool
      ..accommodationAc = json['accommodationAc'] as bool;

Map<String, dynamic> _$OfferToJson(Offer instance) => <String, dynamic>{
      'isActive': instance.isActive,
      'isVisible': instance.isVisible,
      'uploadDate': instance.uploadDate.toIso8601String(),
      'title': instance.title,
      'city': instance.city,
      'address': instance.address,
      'monthlyPrice': instance.monthlyPrice,
      'utilityBillsRequired': instance.utilityBillsRequired,
      'availableFrom': instance.availableFrom.toIso8601String(),
      'availableTo': instance.availableTo.toIso8601String(),
      'freeRoomCount': instance.freeRoomCount,
      'totalRoomCount': instance.totalRoomCount,
      'ruleSmoking': instance.ruleSmoking,
      'ruleAnimals': instance.ruleAnimals,
      'bedCount': instance.bedCount,
      'bedType': _$BedTypeEnumMap[instance.bedType],
      'accommodationTv': instance.accommodationTv,
      'accommodationWifi': instance.accommodationWifi,
      'accommodationAc': instance.accommodationAc,
    };

const _$BedTypeEnumMap = {
  BedType.noBed: 0,
  BedType.single: 1,
  BedType.double: 2,
  BedType.sofa: 3,
};

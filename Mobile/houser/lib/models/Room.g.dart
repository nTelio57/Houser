// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
      title: json['title'] as String,
    )
      ..isActive = json['isActive'] as bool? ?? true
      ..isVisible = json['isVisible'] as bool
      ..uploadDate = DateTime.parse(json['uploadDate'] as String)
      ..userId = json['userId'] as String
      ..user = json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>)
      ..id = json['id'] as int
      ..city = json['city'] as String
      ..address = json['address'] as String
      ..monthlyPrice = (json['monthlyPrice'] as num).toDouble()
      ..utilityBillsRequired = json['utilityBillsRequired'] as bool? ?? true
      ..area = (json['area'] as num?)?.toDouble() ?? 0
      ..images = (json['images'] as List<dynamic>)
          .map((e) => Image.fromJson(e as Map<String, dynamic>))
          .toList()
      ..availableFrom = DateTime.parse(json['availableFrom'] as String)
      ..availableTo = DateTime.parse(json['availableTo'] as String)
      ..freeRoomCount = json['freeRoomCount'] as int? ?? 1
      ..totalRoomCount = json['totalRoomCount'] as int? ?? 1
      ..ruleSmoking = json['ruleSmoking'] as bool? ?? false
      ..ruleAnimals = json['ruleAnimals'] as bool? ?? false
      ..bedCount = json['bedCount'] as int? ?? 0
      ..bedType = $enumDecode(_$BedTypeEnumMap, json['bedType'])
      ..accommodationTv = json['accommodationTv'] as bool? ?? false
      ..accommodationWifi = json['accommodationWifi'] as bool? ?? false
      ..accommodationAc = json['accommodationAc'] as bool? ?? false
      ..accommodationParking = json['accommodationParking'] as bool? ?? false
      ..accommodationBalcony = json['accommodationBalcony'] as bool? ?? false
      ..accommodationDisability =
          json['accommodationDisability'] as bool? ?? false;

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'isActive': instance.isActive,
      'isVisible': instance.isVisible,
      'uploadDate': instance.uploadDate.toIso8601String(),
      'userId': instance.userId,
      'user': instance.user,
      'id': instance.id,
      'title': instance.title,
      'city': instance.city,
      'address': instance.address,
      'monthlyPrice': instance.monthlyPrice,
      'utilityBillsRequired': instance.utilityBillsRequired,
      'area': instance.area,
      'images': instance.images,
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
      'accommodationParking': instance.accommodationParking,
      'accommodationBalcony': instance.accommodationBalcony,
      'accommodationDisability': instance.accommodationDisability,
    };

const _$BedTypeEnumMap = {
  BedType.noBed: 0,
  BedType.single: 1,
  BedType.double: 2,
  BedType.sofa: 3,
};

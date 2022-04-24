// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['id'] as String,
      json['email'] as String,
      isVisible: json['isVisible'] as bool? ?? false,
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      city: json['city'] as String?,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      sex: json['sex'] as int?,
      animalCount: json['animalCount'] as int?,
      isStudying: json['isStudying'] as bool?,
      isWorking: json['isWorking'] as bool?,
      isSmoking: json['isSmoking'] as bool?,
      sleepType: $enumDecodeNullable(_$SleepTypeEnumMap, json['sleepType']),
      guestCount: json['guestCount'] as int?,
      partyCount: json['partyCount'] as int?,
      filter: json['filter'] == null
          ? null
          : Filter.fromJson(json['filter'] as Map<String, dynamic>),
    )..images = (json['images'] as List<dynamic>)
        .map((e) => Image.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'isVisible': instance.isVisible,
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'surname': instance.surname,
      'city': instance.city,
      'birthDate': instance.birthDate?.toIso8601String(),
      'sex': instance.sex,
      'animalCount': instance.animalCount,
      'isStudying': instance.isStudying,
      'isWorking': instance.isWorking,
      'isSmoking': instance.isSmoking,
      'sleepType': _$SleepTypeEnumMap[instance.sleepType],
      'guestCount': instance.guestCount,
      'partyCount': instance.partyCount,
      'images': instance.images,
      'filter': instance.filter,
    };

const _$SleepTypeEnumMap = {
  SleepType.morning: 0,
  SleepType.none: 1,
  SleepType.evening: 2,
};

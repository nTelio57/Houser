// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Image _$ImageFromJson(Map<String, dynamic> json) => Image(
      json['id'] as int,
      json['path'] as String,
      json['userId'] as String,
    );

Map<String, dynamic> _$ImageToJson(Image instance) => <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'userId': instance.userId,
    };

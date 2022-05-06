// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Match _$MatchFromJson(Map<String, dynamic> json) => Match(
      json['id'] as int,
      User.fromJson(json['userOfferer'] as Map<String, dynamic>),
      User.fromJson(json['roomOfferer'] as Map<String, dynamic>),
      json['room'] == null
          ? null
          : Room.fromJson(json['room'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MatchToJson(Match instance) => <String, dynamic>{
      'id': instance.id,
      'userOfferer': instance.userOfferer,
      'roomOfferer': instance.roomOfferer,
      'room': instance.room,
    };

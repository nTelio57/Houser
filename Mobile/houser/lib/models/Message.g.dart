// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      json['id'] as int,
      json['senderId'] as String,
      json['matchId'] as int,
      DateTime.parse(json['sendTime'] as String),
      json['content'] as String,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'matchId': instance.matchId,
      'sendTime': instance.sendTime.toIso8601String(),
      'content': instance.content,
    };

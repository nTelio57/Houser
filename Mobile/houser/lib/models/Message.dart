import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Message.g.dart';

@JsonSerializable()
class Message extends Equatable{
  Message(this.id, this.senderId, this.matchId, this.sendTime, this.content);

  int id;
  String senderId;
  int matchId;
  DateTime? sendTime;
  String content;

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  @override
  List<Object?> get props => [id, senderId, matchId, sendTime, content];
}
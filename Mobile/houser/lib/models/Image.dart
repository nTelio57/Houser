import 'package:json_annotation/json_annotation.dart';
part 'Image.g.dart';

@JsonSerializable()
class Image {
  Image(this.id, this.path, this.userId, this.offerId, this.isMain);

  int id;
  String path;
  String userId;
  int? offerId;
  bool isMain;

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);
}
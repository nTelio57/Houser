import 'package:flutter/animation.dart';
import 'package:houser/enums/BedType.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Offer.g.dart';

@JsonSerializable()
class Offer{
  @JsonKey(defaultValue: true)
  bool isActive = true;
  bool isVisible = true;
  DateTime uploadDate = DateTime.now();
  @JsonKey(name: 'userId')
  String ownerId = '';
  int id = 0;

  String title = 'Ieškomas vienas kambariokas dviem mėnesiams';
  String city = 'Kaunas';
  String address = 'Studentų g. 50 ';

  double monthlyPrice  = 100;
  @JsonKey(defaultValue: true)
  bool utilityBillsRequired = true;
  @JsonKey(defaultValue: 0)
  double? area = 75;

  DateTime availableFrom = DateTime.now();
  DateTime availableTo = DateTime.now().add(const Duration(days: 90));

  @JsonKey(defaultValue: 1)
  int freeRoomCount = 1;
  @JsonKey(defaultValue: 1)
  int totalRoomCount = 3;

  @JsonKey(defaultValue: false)
  bool ruleSmoking = true;
  @JsonKey(defaultValue: false)
  bool ruleAnimals = true;

  @JsonKey(defaultValue: 0)
  int? bedCount = 1;
  BedType bedType = BedType.single;

  @JsonKey(defaultValue: false)
  bool accommodationTv = true;
  @JsonKey(defaultValue: false)
  bool accommodationWifi = true;
  @JsonKey(defaultValue: false)
  bool accommodationAc = true;
  @JsonKey(defaultValue: false)
  bool accommodationParking = true;
  @JsonKey(defaultValue: false)
  bool accommodationBalcony = true;
  @JsonKey(defaultValue: false)
  bool accommodationDisability = true;

  Offer({required this.title});

  Offer.placeholder(this.isVisible);

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

  Map<String, dynamic> toJson() => _$OfferToJson(this);

}
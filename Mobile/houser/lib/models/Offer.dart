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

  String title = 'Ieškomas vienas kambariokas dviem mėnesiams';
  String city = 'Kaunas';
  String address = 'Studentų g. 50 ';

  double monthlyPrice  = 100;
  bool utilityBillsRequired = true;

  DateTime availableFrom = DateTime.now();
  DateTime availableTo = DateTime.now().add(const Duration(days: 90));
  int freeRoomCount = 1;
  int totalRoomCount = 3;

  bool ruleSmoking = true;
  bool ruleAnimals = true;

  int bedCount = 1;
  BedType bedType = BedType.single;

  bool accommodationTv = true;
  bool accommodationWifi = true;
  bool accommodationAc = true;

  Offer({required this.title, required this.uploadDate, required this.address, required this.city, required this.freeRoomCount, required this.totalRoomCount, required this.isActive, required this.isVisible});

  Offer.placeholder(this.isVisible);

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

  Map<String, dynamic> toJson() => _$OfferToJson(this);

}
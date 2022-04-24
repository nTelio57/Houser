import 'package:equatable/equatable.dart';
import 'package:houser/enums/FilterType.dart';
import 'package:houser/models/Filter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'RoomFilter.g.dart';

@JsonSerializable()
class RoomFilter extends Filter {
  RoomFilter(int id, String userId, this.area, this.monthlyPrice, this.city, this.availableFrom, this.availableTo, this.freeRoomCount, this.bedCount, this.ruleSmoking,
      this.ruleAnimals, this.accommodationTv, this.accommodationWifi, this.accommodationAc, this.accommodationParking, this.accommodationBalcony, this.accommodationDisability)
      : super(id, userId, FilterType.room);

  double? area;
  double? monthlyPrice;
  String? city;
  DateTime? availableFrom;
  DateTime? availableTo;
  int? freeRoomCount;
  int? bedCount;
  //--------Rules-----
  bool? ruleSmoking;
  bool? ruleAnimals;
  //--------Accommodations----------
  bool? accommodationTv;
  bool? accommodationWifi;
  bool? accommodationAc;
  bool? accommodationParking;
  bool? accommodationBalcony;
  bool? accommodationDisability;

  factory RoomFilter.fromJson(Map<String, dynamic> json) => _$RoomFilterFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RoomFilterToJson(this);

  @override
  List<Object?> get props => [id, userId, filterType, area, monthlyPrice, city, availableFrom,
    availableTo, freeRoomCount, bedCount, ruleSmoking, ruleAnimals, accommodationTv, accommodationWifi, accommodationAc, accommodationParking, accommodationBalcony, accommodationDisability];
}
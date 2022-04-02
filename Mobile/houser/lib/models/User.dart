import 'package:houser/enums/SleepType.dart';
import 'package:houser/extensions/dateTime_extensions.dart';
import 'package:json_annotation/json_annotation.dart';
part 'User.g.dart';

@JsonSerializable()
class User {
User(this.id, this.email,{ this.name, this.surname, this.city, this.birthDate, this.sex, this.animalCount, this.isStudying, this.isWorking, this.isSmoking, this.sleepType, this.guestCount, this.partyCount});

String id;
String email;
String? name;
String? surname;
int get age => birthDate!.age;
String? city;
DateTime? birthDate;
int? sex;
int? animalCount;
bool? isStudying;
bool? isWorking;
bool? isSmoking;
SleepType? sleepType;
int? guestCount;
int? partyCount;

factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

Map<String, dynamic> toJson() => _$UserToJson(this);
}
import 'package:json_annotation/json_annotation.dart';
part 'User.g.dart';

@JsonSerializable()
class User {
User(this.id, this.email,{ this.name, this.surname, this.age, this.city});

String id;
String email;
String? name;
String? surname;
int? age;
String? city;

factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

Map<String, dynamic> toJson() => _$UserToJson(this);
}
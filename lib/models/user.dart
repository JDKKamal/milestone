import 'package:meta/meta.dart';

@immutable
class User {
  final int id;
  final String name;
  final String mobile;
  final String message;

  User({this.id, this.name, this.mobile, this.message});

  User copyWith(Map<String, dynamic> json) {
    return User(
        id: json["EMPID"] ?? this.id,
        name: json["EMPNAME"] ?? this.name,
        mobile: json["EMPMBNO"] ?? this.mobile,
        message: json["Message"] ?? this.message);
  }

  User.fromJson(Map<String, dynamic> json)
      : id = json["EMPID"],
        name = json["EMPNAME"],
        mobile = json["EMPMBNO"],
        message = json["Message"];
}

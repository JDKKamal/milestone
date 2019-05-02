import 'package:meta/meta.dart';

@immutable
class School {
  final int id;
  final String description;

  School({this.id, this.description});

  School copyWith(Map<String, String> json) {
    return School(
      id: json["ID"] ?? this.id,
      description: json["LISTDESC"] ?? this.description,
    );
  }

  factory School.fromJson(Map<String, dynamic> json) {
    return new School(
      id: json['ID'],
      description: json['LISTDESC'],
    );
  }
}

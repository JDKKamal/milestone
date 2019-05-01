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

  School.fromJson(Map<String, dynamic> json)
      : id = json != null ? json["ID"] : null,
        description = json != null ? json["LISTDESC"] : null;
}

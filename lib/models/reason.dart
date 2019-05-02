import 'package:meta/meta.dart';

@immutable
class Reason {
  final int id;
  final String description;

  Reason({this.id, this.description});

  Reason copyWith(Map<String, String> json) {
    return Reason(
      id: json["ID"] ?? this.id,
      description: json["LISTDESC"] ?? this.description,
    );
  }

  Reason.fromJson(Map<String, dynamic> json)
      : id = json != null ? json["ID"] : null,
        description = json != null ? json["LISTDESC"] : null;
}

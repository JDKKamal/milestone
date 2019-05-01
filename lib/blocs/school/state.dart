import 'package:meta/meta.dart';
import 'package:milestone/src/models/school.dart';

@immutable
class SchoolState {
  final bool loading;
  final bool loaded;
  final Map error;
  final List<School> schools;

  SchoolState({
    @required this.loading,
    @required this.loaded,
    @required this.error,
    @required this.schools,
  });

  factory SchoolState.initial() {
    return SchoolState(
      loading: false,
      loaded: false,
      error: null,
      schools: List<School>(),
    );
  }

  SchoolState copyWith({
    bool loading,
    bool loaded,
    Map error,
    List<School> schools,
  }) {
    return SchoolState(
      loading: loading ?? this.loading,
      loaded: loaded ?? this.loaded,
      error: error ?? this.error,
      schools: schools ?? this.schools,
    );
  }
}

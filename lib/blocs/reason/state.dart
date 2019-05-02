import 'package:meta/meta.dart';
import 'package:milestone/models/reason.dart';

@immutable
class SchoolState {
  final bool loading;
  final bool loaded;
  final Map error;
  final List<Reason> reasons;

  SchoolState({
    @required this.loading,
    @required this.loaded,
    @required this.error,
    @required this.reasons,
  });

  factory SchoolState.initial() {
    return SchoolState(
      loading: false,
      loaded: false,
      error: null,
      reasons: List<Reason>(),
    );
  }

  SchoolState copyWith({
    bool loading,
    bool loaded,
    Map error,
    List<Reason> schools,
  }) {
    return SchoolState(
      loading: loading ?? this.loading,
      loaded: loaded ?? this.loaded,
      error: error ?? this.error,
      reasons: schools ?? this.reasons,
    );
  }
}

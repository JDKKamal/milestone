import 'package:meta/meta.dart';

@immutable
class RegisterState {
  final bool loading;
  final bool loaded;
  final Map error;
  final String mobile;
  final String uid;

  RegisterState({
    @required this.loading,
    @required this.loaded,
    @required this.error,
    @required this.mobile,
    @required this.uid,
  });

  factory RegisterState.initial() {
    return RegisterState(
      loading: false,
      loaded: false,
      error: null,
      mobile: "",
      uid: "",
    );
  }

  RegisterState copyWith({
    bool loading,
    bool loaded,
    Map error,
    String mobile,
    String uid,
  }) {
    return RegisterState(
      loading: loading ?? this.loading,
      loaded: loaded ?? this.loaded,
      error: error ?? this.error,
      mobile: mobile ?? this.mobile,
      uid: uid ?? this.uid,
    );
  }
}

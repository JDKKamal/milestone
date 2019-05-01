import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:milestone/src/blocs/register/event.dart';
import 'package:milestone/src/blocs/register/state.dart';
import 'package:milestone/src/resources/api.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final ApiProvider _apiProvider = ApiProvider();

  void onChangeMobile(mobile) {
    dispatch(ChangeMobile(mobile: mobile));
  }

  void setUid(uid) {
    dispatch(SetUid(uid: uid));
  }

  void registerDevice(callback) {
    dispatch(RegisterDevice(callback: callback));
  }

  @override
  RegisterState get initialState => RegisterState.initial();

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is ChangeMobile) {
      yield currentState.copyWith(mobile: event.mobile, error: {});
    }

    if (event is SetUid) {
      yield currentState.copyWith(uid: event.uid);
    }

    if (event is RegisterDevice) {
      yield currentState.copyWith(loading: true);

      try {
        final response = await _apiProvider.authenticate(
          currentState.mobile,
          currentState.uid,
        );

        if (response.body != null) {
          final results = json.decode(response.body);

          if (results['user'] != null) {
            yield currentState.copyWith(
              loaded: true,
              loading: false,
              error: {},
            );

            event.callback(results);
          } else {
            yield currentState.copyWith(
              loaded: true,
              loading: false,
              error: results['errors'],
            );

            event.callback(false);
          }
        }
      } catch (e) {
        yield currentState.copyWith(
          loaded: true,
          loading: false,
          error: {"error": "Error, Something bad happened."},
        );

        event.callback(false);
      }
    }
  }
}

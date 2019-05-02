import 'dart:async';

import 'package:milestone/bloc.dart';
import 'package:milestone/blocs/Register/event.dart';
import 'package:milestone/blocs/Register/state.dart';
import 'package:milestone/helpers/vars.dart';
import 'package:milestone/models/user.dart';
import 'package:milestone/viewmodel/api_provider.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final ApiProvider apiProvider = ApiProvider();

  void onChangeMobile(mobile) {
    dispatch(ChangeMobile(mobile: mobile));
  }

  void onChangePassword(password) {
    dispatch(ChangePassword(password: password));
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

    if (event is ChangePassword) {
      yield currentState.copyWith(password: event.password, error: {});
    }

    if (event is SetUid) {
      yield currentState.copyWith(uid: event.uid);
    }

    if (event is RegisterDevice) {
      yield currentState.copyWith(loading: true);
      await apiProvider.getLogin(currentState.mobile, currentState.password);
      try {
        User user = apiProvider.apiResult.response;
        if (apiProvider.apiResult.responseCode == ok200) {
          yield currentState.copyWith(
            loaded: true,
            loading: false,
            error: {},
          );
          event.callback(user);
        } else {

          yield currentState.copyWith(
            loaded: true,
            loading: false,
            error: {"error": apiProvider.apiResult.responseCode == 404 ? 'Record not found': 'Enter mobile or password'},
          );

          event.callback(false);
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

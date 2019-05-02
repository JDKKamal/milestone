import 'dart:async';
import 'dart:convert';

import 'package:milestone/bloc.dart';
import 'package:milestone/blocs/user/event.dart';
import 'package:milestone/blocs/user/state.dart';
import 'package:milestone/models/user.dart';
import 'package:milestone/viewmodel/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final ApiProvider apiProvider = ApiProvider();

  void updateState(key, value) {
    dispatch(UpdateState(key: key, value: value));
  }

  void getAuthUser() {
    dispatch(GetAuthUser());
  }

  void setAuthUser(user) {
    dispatch(SetAuthUser(user: user));
  }

  void setAuthToken(token) {
    dispatch(SetAuthToken(token: token));
  }

  void removeAuth(token) {
    dispatch(SetAuthToken(token: token));
  }

  void updateProfile(callback) {
    dispatch(UpdateProfile(callback: callback));
  }

  @override
  UserState get initialState => UserState.initial();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is UpdateState) {
      User user = currentState.user.copyWith({event.key: event.value});
      yield currentState.copyWith(user: user, error: {});
    }

    if (event is GetAuthUser) {
      yield currentState.copyWith(loaded: false, loading: true);

     /* try {
        final response = await apiProvider.getAuthUser();
        final results = json.decode(response.body);

        if (results['user'] != null) {
          dispatch(SetAuthUser(user: results['user']));
        } else {
          dispatch(RemoveAuth());
        }
      } catch (e) {
        yield currentState.copyWith(
          error: {"errors": "Error, Something bad happened."},
          loaded: true,
          loading: false,
        );
      }*/
    }

    if (event is SetAuthToken) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("authToken", event.token);
    }

    if (event is SetAuthUser) {
      yield currentState.copyWith(
        loaded: true,
        loading: false,
        user: event.user,
      );
    }

    if (event is RemoveAuth) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.remove("authToken");

      yield currentState.copyWith(
        loaded: true,
        loading: false,
        user: null,
      );
    }
  }
}

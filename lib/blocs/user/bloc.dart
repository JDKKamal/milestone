import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:milestone/src/blocs/user/event.dart';
import 'package:milestone/src/blocs/user/state.dart';
import 'package:milestone/src/models/user.dart';
import 'package:milestone/src/resources/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final ApiProvider _apiProvider = ApiProvider();

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

      try {
        final response = await _apiProvider.getAuthUser();
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
      }
    }

    if (event is UpdateProfile) {
      yield currentState.copyWith(loaded: false, loading: true);

      try {
        final response = await _apiProvider.updateProfile(currentState.user);
        final results = json.decode(response.body);

        if (results['user'] != null) {
          dispatch(SetAuthUser(user: results['user']));
          event.callback(true);
        } else {
          yield currentState.copyWith(
            error: results['errors'],
            loaded: true,
            loading: false,
          );

          event.callback(false);
        }
      } catch (e) {
        yield currentState.copyWith(
          error: {"errors": "Error, Something bad happened."},
          loaded: true,
          loading: false,
        );

        event.callback(false);
      }
    }

    if (event is SetAuthToken) {
      print("Tag" + event.token.toString());

      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("authToken", event.token);
    }

    if (event is SetAuthUser) {
      yield currentState.copyWith(
        loaded: true,
        loading: false,
        user: User.fromJson(event.user),
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

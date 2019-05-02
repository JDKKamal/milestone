import 'package:flutter/material.dart';
import 'package:milestone/blocs/user/state.dart';
import 'package:milestone/screens/login.dart';
import 'package:milestone/screens/reason.dart';

Widget getInitialScreen(bool authenticated, UserState userState) {

  if (authenticated == false) {
    return LoginPage();
  }

  if (userState != null && userState.loaded == true) {
    if (userState.user != null) {
      return ChooseReason();
    }
  }

  return Center(child: ChooseReason());
}

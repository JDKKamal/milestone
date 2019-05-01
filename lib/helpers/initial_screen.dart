import 'package:flutter/material.dart';
import 'package:milestone/src/blocs/user/state.dart';
import 'package:milestone/src/screens/login.dart';
import 'package:milestone/src/screens/review.dart';
import 'package:milestone/src/screens/tab.dart';
import 'package:milestone/src/screens/users/edit_profile.dart';

Widget getInitialScreen(bool authenticated, UserState userState) {
  if (authenticated == false) {
    return LoginPage();
  }

  if (userState != null && userState.loaded == true) {
    if (userState.user != null) {
      if (userState.user.status == 1) {
        if (userState.user.accountStatus == "Pending") {
          return Review();
        }

        return TabPage();
      }

      return EditProfilePage(shouldPop: false);
    }

    return LoginPage();
  }

  return Center(child: CircularProgressIndicator());
}

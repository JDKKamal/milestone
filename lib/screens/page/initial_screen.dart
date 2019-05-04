import 'package:flutter/material.dart';
import 'package:milestone/blocs/user/state.dart';
import 'package:milestone/screens/page/login.dart';
import 'package:milestone/screens/page/reason.dart';

Widget getInitialScreen(bool authenticated, UserState userState) {

  if (authenticated == false) {
    return LoginPage();
    /*
    LoginPage
    LoginScreen
    HospitalDashboardHome
    ThreeDimenssionBottomNavigationBar
    GreeneryHome
    DaycareHome
    RealEstateHome
    SmartPlantHome
    */

    /*
    custom text type
    "25 ºC",
    */
  }

  if (userState != null && userState.loaded == true) {
    if (userState.user != null) {
      return ChooseReason();
    }
  }

  return Center(child: ChooseReason());
}

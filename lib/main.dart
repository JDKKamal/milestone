import 'package:flutter/material.dart';
import 'package:milestone/blocs/Register/bloc.dart';
import 'package:milestone/blocs/school/bloc.dart';
import 'package:milestone/blocs/user/bloc.dart';
import 'package:milestone/flutter_bloc.dart';
import 'package:milestone/flutter_bloc/bloc_provider_tree.dart';
import 'package:milestone/screens/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String authToken = prefs.getString("authToken");

  runApp(
    BlocProviderTree(
      blocProviders: [
        BlocProvider<UserBloc>(bloc: UserBloc()),
        BlocProvider<RegisterBloc>(bloc: RegisterBloc()),
        BlocProvider<SchoolBloc>(bloc: SchoolBloc())
      ],
      child: MyApp(authToken: authToken),
    ),
  );
}

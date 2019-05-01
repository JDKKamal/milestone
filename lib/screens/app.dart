import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milestone/src/blocs/user/bloc.dart';
import 'package:milestone/src/blocs/user/state.dart';
import 'package:milestone/src/helpers/initial_screen.dart';
import 'package:milestone/src/screens/no_network.dart';

class MyApp extends StatefulWidget {
  final String authToken;

  MyApp({this.authToken});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserBloc userBloc;
  UserState userState;

  ConnectivityResult connectivityResult;
  var subscription;

  @override
  void initState() {
    super.initState();

    checkConnection();

    setState(() {
      userBloc = BlocProvider.of<UserBloc>(context);
    });

    userBloc.getAuthUser();

    userBloc.state.listen((state) {
      if (userState == null && state.user != null) {
        setState(() {
          userState = state;
        });
      }
    });
  }

  void checkConnection() {
    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        setState(() => connectivityResult = result);
      },
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(platform: TargetPlatform.iOS),
      home: connectivityResult == ConnectivityResult.none
          ? NoNetwork()
          : getInitialScreen(widget.authToken != null, userState),
    );
  }
}

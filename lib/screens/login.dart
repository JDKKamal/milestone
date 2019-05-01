import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milestone/src/blocs/register/bloc.dart';
import 'package:milestone/src/blocs/register/event.dart';
import 'package:milestone/src/blocs/register/state.dart';
import 'package:milestone/src/blocs/user/bloc.dart';
import 'package:milestone/src/helpers/initial_screen.dart';
import 'package:milestone/src/helpers/validation.dart';
import 'package:milestone/src/screens/users/editable.dart';
import 'package:xs_progress_hud/xs_progress_hud.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  RegisterBloc registerBloc;
  UserBloc userBloc;

  @override
  void initState() {
    super.initState();

    setState(() {
      registerBloc = BlocProvider.of<RegisterBloc>(context);
      userBloc = BlocProvider.of<UserBloc>(context);
    });

    setUid();
  }

  setUid() async {
    String uid = await DeviceId.getID;
    registerBloc.setUid(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Container(height: 30.0),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                width: double.infinity,
                child: Image.asset(
                  "assets/images/book.png",
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                width: double.infinity,
                child: Text(
                  "MileStone",
                  style: TextStyle(
                    fontFamily: 'TitilliumWeb-Regular',
                    fontWeight: FontWeight.bold,
                    fontSize: 36.0,
                    letterSpacing: 2.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            BlocBuilder<RegisterEvent, RegisterState>(
              bloc: registerBloc,
              builder: (BuildContext context, RegisterState state) {
                return EditableFormField(
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  controller: null,
                  labelText: "Mobile Number",
                  errorText: getErrorText(state, 'mobile'),
                  onChanged: registerBloc.onChangeMobile,
                );
              },
            ),
            BlocBuilder<RegisterEvent, RegisterState>(
              bloc: registerBloc,
              builder: (BuildContext context, RegisterState state) {
                return FlatButton(
                  onPressed: onRegisterDevice,
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    "Register".toUpperCase(),
                    style: TextStyle(
                      color: state.mobile != null && state.error != null
                          ? Colors.white
                          : Colors.white30,
                      fontFamily: 'TitilliumWeb-SemiBold',
                    ),
                  ),
                  color: state.mobile != null && state.error != null
                      ? Colors.red
                      : Colors.grey,
                );
              },
            ),
            Container(height: 50.0),
          ],
        ),
      ),
    );
  }

  void onRegisterDevice() async {
    XsProgressHud.show(context);

    registerBloc.registerDevice((results) {
      XsProgressHud.hide();

      if (results != false) {
        userBloc.setAuthToken(results['access_token']);
        userBloc.setAuthUser(results['user']);

        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return getInitialScreen(true, userBloc.currentState);
            },
          ),
        );
      }
    });
  }
}

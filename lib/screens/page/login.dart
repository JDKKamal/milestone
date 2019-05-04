import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:milestone/blocs/Register/bloc.dart';
import 'package:milestone/blocs/Register/event.dart';
import 'package:milestone/blocs/Register/state.dart';
import 'package:milestone/blocs/user/bloc.dart';
import 'package:milestone/flutter_bloc.dart';
import 'package:milestone/flutter_bloc/bloc_provider.dart';
import 'package:milestone/screens/page/initial_screen.dart';
import 'package:milestone/helpers/vars.dart';
import 'package:milestone/models/user.dart';
import 'package:milestone/screens/widgets/animatedbutton.dart';
import 'package:milestone/screens/widgets/editable.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  RegisterBloc registerBloc;
  UserBloc userBloc;
  final LoginErrorMessageController loginErrorMessageController =
      LoginErrorMessageController();

  @override
  void initState() {
    super.initState();

    setState(() {
      registerBloc = BlocProvider.of<RegisterBloc>(context);
      userBloc = BlocProvider.of<UserBloc>(context);
    });
  }

  setUid() async {
    String uid = await DeviceId.getID;
    registerBloc.setUid(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                width: double.infinity,
                child: Text(
                  "MileStone",
                  style: TextStyle(
                    fontFamily: '$ralewayFont',
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
                  labelText: "Mobile",
                  //errorText: getErrorText(state, 'mobile'),
                  onChanged: registerBloc.onChangeMobile,
                );
              },
            ),
            BlocBuilder<RegisterEvent, RegisterState>(
              bloc: registerBloc,
              builder: (BuildContext context, RegisterState state) {
                return EditableFormField(
                  keyboardType: TextInputType.number,
                  controller: null,
                  labelText: "Password",
                  onChanged: registerBloc.onChangePassword,
                );
              },
            ),
            BlocBuilder<RegisterEvent, RegisterState>(
                bloc: registerBloc,
                builder: (BuildContext context, RegisterState state) {
                  if (state.error != null && state.error.containsKey('error')) {
                    loginErrorMessageController
                        .showErrorMessage('Loading'); //state.error['error']
                  }
                  return new AnimatedButton(
                    loginErrorMessageController: loginErrorMessageController,
                    loginTip: 'Login',
                    onTap: () async {
                      onRegisterDevice();
                      loginErrorMessageController.showErrorMessage("Loading");
                    },
                  );
                }),

            /*BlocBuilder<RegisterEvent, RegisterState>(
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
                          : Colors.black,
                      fontFamily: '$ralewayFont',
                    ),
                  ),
                  color: state.mobile != null && state.error != null
                      ? Colors.red
                      : Colors.white,
                );
              },
            ),*/

            Container(height: 30.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Center(
                child: Container(
                  child: RaisedButton(
                    elevation: 40.0,
                    color: Colors.white,
                    splashColor: Colors.orangeAccent,
                    onPressed: () {
                      //do nothing
                    },
                    shape: CircleBorder(
                      side: BorderSide(style: BorderStyle.none),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          FontAwesomeIcons.google,
                          color: Color(0xffCE107c),
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  child: RaisedButton(
                    elevation: 40.0,
                    color: Colors.white,
                    splashColor: Colors.orangeAccent,
                    onPressed: () {
                      //do nothing
                    },
                    shape: CircleBorder(
                      side: BorderSide(style: BorderStyle.none),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          FontAwesomeIcons.facebookF,
                          color: Color.fromRGBO(59, 89, 152, 1.0),
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
            Container(height: 30.0),
          ],
        ),
      ),
    );
  }

  void onRegisterDevice() async {
    //showProgress(context);

    registerBloc.registerDevice((results) {
      //hideProgress(context);

      if (results != false) {
        User user = results;
        userBloc.setAuthToken(user.id.toString());
        userBloc.setAuthUser(results);

        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return getInitialScreen(true, userBloc.currentState);
            },
          ),
        );
      } else {}
    });
  }
}

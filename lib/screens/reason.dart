import 'package:flutter/material.dart';
import 'package:milestone/blocs/school/bloc.dart';
import 'package:milestone/blocs/school/state.dart';
import 'package:milestone/blocs/user/bloc.dart';
import 'package:milestone/flutter_bloc/bloc_builder.dart';
import 'package:milestone/flutter_bloc/bloc_provider.dart';
import 'package:milestone/helpers/vars.dart';
import 'package:milestone/models/school.dart';

class ChooseSchool extends StatefulWidget {
  @override
  _ChooseSchoolState createState() => _ChooseSchoolState();
}

class _ChooseSchoolState extends State<ChooseSchool> {
  SchoolBloc schoolBloc;
  String keywords;

  @override
  void initState() {
    super.initState();

    setState(() {
      schoolBloc = BlocProvider.of<SchoolBloc>(context);
    });

    if (schoolBloc.currentState.loaded == false) {
      schoolBloc.getSchool();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: BlocBuilder(
          bloc: schoolBloc,
          builder: (context, SchoolState state) {
            if (state.loading) {
              return Center(child: CircularProgressIndicator());
            }

            List schools = state.schools;
            if (keywords != null) {
              schools = state.schools.where((school) {
                return school.description
                    .toLowerCase()
                    .contains(keywords.toLowerCase());
              }).toList();
            }

            return Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(20.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        keywords = value;
                      });
                    },
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontFamily: '$ralewayFont',
                    ),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      labelText: "Filter School",
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontFamily: '$ralewayFont',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: ListView.builder(
                      itemCount: schools.length,
                      itemBuilder: (BuildContext context, index) {
                        final School school = schools[index];
                        return GestureDetector(
                          onTap: () {

                          },
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              '${schools[index].description}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontFamily: '$ralewayFont',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

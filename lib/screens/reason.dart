import 'package:flutter/material.dart';
import 'package:milestone/blocs/reason/bloc.dart';
import 'package:milestone/blocs/reason/state.dart';
import 'package:milestone/flutter_bloc/bloc_builder.dart';
import 'package:milestone/flutter_bloc/bloc_provider.dart';
import 'package:milestone/helpers/vars.dart';
import 'package:milestone/models/reason.dart';

class ChooseReason extends StatefulWidget {
  @override
  _ChooseReasonState createState() => _ChooseReasonState();
}

class _ChooseReasonState extends State<ChooseReason> {
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
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: BlocBuilder(
          bloc: schoolBloc,
          builder: (context, SchoolState state) {
            if (state.loading) {
              return Center(child: CircularProgressIndicator());
            }

            var reasonList = state.reasons;
            if (keywords != null) {
              reasonList = state.reasons.where((school) {
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
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      labelText: "Filter Reason",
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
                      itemCount: reasonList.length,
                      itemBuilder: (BuildContext context, index) {
                        final Reason reason = reasonList[index];
                        return GestureDetector(
                          onTap: () {

                          },
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              '${reasonList[index].description}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
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

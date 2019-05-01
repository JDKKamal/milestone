import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:milestone/src/blocs/school/event.dart';
import 'package:milestone/src/blocs/school/state.dart';
import 'package:milestone/src/models/school.dart';
import 'package:milestone/src/resources/api.dart';

class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final ApiProvider _apiProvider = ApiProvider();

  void getSchool() {
    dispatch(GetSchool());
  }

  @override
  SchoolState get initialState => SchoolState.initial();

  @override
  Stream<SchoolState> mapEventToState(SchoolEvent event) async* {
    if (event is GetSchool) {
      yield currentState.copyWith(loading: true);

      try {
        final response = await _apiProvider.getSchools();
        final results = json.decode(response.body);

        if (results['schools'] != null) {
          List<School> schools = List<School>();

          for (Map school in results['schools']) {
            schools.add(
              School.fromJson({
                "id": school['id'],
                "name": school['name'],
                "location": school['location'],
              }),
            );
          }

          yield currentState.copyWith(
            schools: schools,
            loaded: true,
            loading: false,
          );
        }
      } catch (e) {
        yield currentState.copyWith(
          error: {"error": "Error, Something bad happened."},
          loaded: true,
          loading: false,
        );
      }
    }
  }
}

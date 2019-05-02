import 'dart:async';

import 'package:milestone/bloc.dart';
import 'package:milestone/blocs/reason/event.dart';
import 'package:milestone/blocs/reason/state.dart';
import 'package:milestone/viewmodel/api_provider.dart';

class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final ApiProvider apiProvider = ApiProvider();

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
        await apiProvider.getPostPonCancelReasonList();

        if (apiProvider.apiResult != null) {
          yield currentState.copyWith(
            schools: apiProvider.apiResult.response,
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

import 'dart:async';

import 'package:milestone/helpers/vars.dart';
import 'package:milestone/models/reason.dart';
import 'package:milestone/models/user.dart';
import 'package:milestone/service/abstract/api_service.dart';
import 'package:milestone/viewmodel/reason_postpone_cancel_view_model.dart';
import 'package:milestone/service/network_service_response.dart';

class MockService implements APIService {
  @override
  Future<NetworkServiceResponse<User>> login(
      String phoneNumber, String password) async {
    await Future.delayed(Duration(seconds: 2));
    return Future.value(NetworkServiceResponse(
        responseCode: ok200,
        response: User(
          id: 000,
          name: 'Lakhani kamlesh',
          mobile: '9586331823',
          message: '',
        )));
  }

  @override
  Future<NetworkServiceResponse<List<Reason>>> postPonCancelReasonList() {
    // await Future.delayed(Duration(seconds: 2));
    final _reasonPostPoneCancelVM = ReasonPostPoneCancelViewModel();
    return Future.value(NetworkServiceResponse(
        responseCode: ok200,
        response: _reasonPostPoneCancelVM.getReasonPostPoneCancel()));
  }
}

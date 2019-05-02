import 'dart:async';

import 'package:meta/meta.dart';
import 'package:milestone/models/reason.dart';
import 'package:milestone/models/user.dart';
import 'package:milestone/service/abstract/api_service.dart';
import 'package:milestone/service/di/dependency_injection.dart';
import 'package:milestone/service/network_service_response.dart';

class ApiProvider {
  NetworkServiceResponse apiResult;
  APIService apiService = new Injector().flavor;

  Future<Null> getLogin(String phoneNumber, String password) async {
    NetworkServiceResponse<User> result =
    await apiService.login(phoneNumber, password);
    this.apiResult = result;
  }

  Future<Null> getPostPonCancelReasonList() async {
    NetworkServiceResponse<List<Reason>> result =
    await apiService.postPonCancelReasonList();
    this.apiResult = result;
  }
}

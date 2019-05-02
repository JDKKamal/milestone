import 'dart:async';

import 'package:milestone/models/reason.dart';
import 'package:milestone/models/user.dart';
import 'package:milestone/service/network_service_response.dart';

abstract class APIService {
  Future<NetworkServiceResponse<User>> login(String phoneNumber, String password);
  Future<NetworkServiceResponse<List<Reason>>> postPonCancelReasonList();
}

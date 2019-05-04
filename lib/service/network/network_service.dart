import 'dart:async';
import 'dart:convert';

import 'package:milestone/models/reason.dart';
import 'package:milestone/models/user.dart';
import 'package:milestone/service/abstract/api_service.dart';
import 'package:milestone/service/network_service_response.dart';
import 'package:milestone/service/network_type.dart';
import 'package:milestone/service/restclient.dart';

class NetworkService extends NetworkType implements APIService {
  static final _baseUrl = 'http://track.quik-e.mobi';
  final _loginUrl = _baseUrl + '/api/CheckLogisticUser';

  //PICKUP - DISPATCH UNDELIVERED REASON LIST
  final _postPoneCancelReasonListUrl = _baseUrl + '/api/PostponeReasonList';

  Map<String, String> headers = {
    "Content-Type": 'application/json',
    "AUTH_KEY": 'MOBEXLOGIBR8T23',
  };

  NetworkService(RestClient rest) : super(rest);

  @override
  Future<NetworkServiceResponse<User>> login(
      String phoneNumber, String password) async {
    var result = await rest.get<User>(
        '$_loginUrl?MobileNo=$phoneNumber&Password=$password&DeviceId=""',
        headers);
    if (result.mappedResult != null) {
      var res = User.fromJson(json.decode(result.mappedResult));
      return new NetworkServiceResponse(
          response: res,
          responseCode: result.networkServiceResponse.responseCode);
    }
    return new NetworkServiceResponse(
        responseCode: result.networkServiceResponse.responseCode);
  }

  @override
  Future<NetworkServiceResponse<List<Reason>>> postPonCancelReasonList() async {
    var result =
        await rest.get<Reason>('$_postPoneCancelReasonListUrl', headers);
    if (result.networkServiceResponse.responseCode == 200) {
      List<Reason> list = (json.decode(result.mappedResult) as List)
          .map((data) => new Reason.fromJson(data))
          .toList();
      return new NetworkServiceResponse(
          response: list,
          responseCode: result.networkServiceResponse.responseCode);
    }
    return new NetworkServiceResponse(
        responseCode: result.networkServiceResponse.responseCode);
  }
}

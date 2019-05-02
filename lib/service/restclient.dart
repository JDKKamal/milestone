import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:milestone/helpers/vars.dart';
import 'package:milestone/service/network_service_response.dart';

class RestClient {
  Future<MappedNetworkServiceResponse<T>> get<T>(String url, Map headers) async{
    try {
      var response = await http.get(url, headers: headers);
      return processResponse<T>(response);

    }
    catch(e) {
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              responseCode: 0));
    }
  }

  Future<MappedNetworkServiceResponse<T>> post<T>(String url, {Map headers, body, encoding}) async{
    try {
      var response = await http.post(url, headers: headers, body: body, encoding: encoding);
      return processResponse<T>(response);
    }
    catch(e) {
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              responseCode: 0));
    }
  }

  MappedNetworkServiceResponse<T> processResponse<T>(http.Response response) {
    if ((response.statusCode > ok200)) {
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              responseCode: response.statusCode));
    } else {
      return new MappedNetworkServiceResponse<T>(
          mappedResult: response.body,
          networkServiceResponse:
          new NetworkServiceResponse<T>(responseCode: response.statusCode));
    }
  }
}

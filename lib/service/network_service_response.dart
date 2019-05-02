class NetworkServiceResponse<T> {
  T response;
  int responseCode;

  NetworkServiceResponse({this.response, this.responseCode});
}

class MappedNetworkServiceResponse<T> {
  dynamic mappedResult;
  NetworkServiceResponse<T> networkServiceResponse;
  MappedNetworkServiceResponse(
      {this.mappedResult, this.networkServiceResponse});
}

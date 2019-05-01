import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future sendRequest(api, [body, type = "POST"]) async {
  final headers = await getHeaders();

  if (type == "GET") {
    return http.get(
      Uri.encodeFull(api),
      headers: headers,
    );
  }

  if (type == "POST") {
    return http.post(
      Uri.encodeFull(api),
      body: json.encode(body),
      headers: headers,
    );
  }
}

getHeaders() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String token = pref.getString("authToken");

  return {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": "Bearer $token",
  };
}

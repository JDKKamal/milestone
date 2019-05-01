import 'package:flutter/foundation.dart' show kReleaseMode;

String appName = "MileStone";
String baseUrl = kReleaseMode
    ? "https://milestone-laravel.herokuapp.com"
    : "https://milestone-laravel.herokuapp.com";

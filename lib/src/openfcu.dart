import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:openfcu/src/timetable.dart';

import 'asp_interceptor.dart';
import 'clocking.dart';

class OpenFcu {
  final Dio _client;
  final String _user;
  final String _password;

  final ClockingManager clocking;
  final TimetableManager timetable;

  OpenFcu._(this._client, this._user, this._password)
      : clocking = ClockingManager(_client, _user, _password),
        timetable = TimetableManager(_client, _user, _password) {
    _client.options
      ..followRedirects = true
      ..validateStatus = ((code) => code! < 400)
      ..headers['User-Agent'] =
          'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/999.0.0.0 Mobile Safari/537.36';
    _client.interceptors
      ..add(AspStateInterceptor())
      ..add(CookieManager(CookieJar()));
  }

  factory OpenFcu(String user, String password) =>
      OpenFcu._(Dio(), user, password);

  void close({bool force = false}) {
    _client.close(force: force);
  }
}

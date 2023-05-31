import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:openfcu/src/util.dart';

class QuickLoginManager {
  final Dio _client;
  final String _user;
  final String _password;

  const QuickLoginManager(this._client, this._user, this._password);

  Future<Uri?> login(LoginTarget target) async {
    final resp = await _client.post(
        'https://service206-sds.fcu.edu.tw/mobileservice/RedirectService.svc/Redirect',
        data: jsonEncode({
          'Account': _user,
          'Password': _password,
          'RedirectService': target.service,
        }),
        options: jsonOptions);
    return Uri.tryParse(resp.data['RedirectUrl']);
  }
}

sealed class LoginTarget {
  String get service;
}

class GeneralTarget implements LoginTarget {
  static final iLearn = GeneralTarget('iLearn 2.0');

  @override
  final String service;

  const GeneralTarget(this.service);
}

class MyFcuTarget implements LoginTarget {
  static final main = MyFcuTarget('/webClientMyFcuMain.aspx');
  static final absence = MyFcuTarget('/S3401/s3401_leave.aspx');
  static final borrowSpace = MyFcuTarget('/S5672/S5672_mainApply.aspx');

  final String _path;

  const MyFcuTarget(this._path);

  @override
  String get service => "https://myfcu.fcu.edu.tw/main$_path";
}

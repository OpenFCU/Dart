import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class ClockingManager {
  static const String _clockInBaseUrl = 'https://signin.fcu.edu.tw/clockin';

  final Dio _client;
  final String _user;
  final String _password;

  ClockingManager(this._client, this._user, this._password);

  Future<bool> login() async {
    try {
      final resp = await _client.post('$_clockInBaseUrl/login.aspx',
          data: 'username=$_user&password=$_password&appversion=2');
      if (resp.statusCode != 302) return false;
      await _client.get('$_clockInBaseUrl/Student.aspx');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<ClockingPageStatus> currentStatus() async {
    try {
      var resp = await _client.post('$_clockInBaseUrl/Student.aspx',
          data: {'ButtonClassClockin': '學生課堂打卡'},
          options: Options(
            contentType: 'application/x-www-form-urlencoded',
          ));
      resp = await _client.get('$_clockInBaseUrl/ClassClockin.aspx',
          options: Options(headers: {
            'referer': '$_clockInBaseUrl/Student.aspx',
          }));
      final doc = parse(resp.data);
      final status = _extractStatus(doc);
      final buttonValue = _extractButtonValue(doc);
      final captchaImage = status == ClockingStatus.available
          ? await _fetchCaptchaImage()
          : null;
      return ClockingPageStatus(status, buttonValue, captchaImage);
    } catch (e) {
      print(e);
      return ClockingPageStatus(ClockingStatus.unavailable, null, null);
    }
  }

  ClockingStatus _extractStatus(Document doc) {
    final button = doc.getElementById('Button0');
    if (button != null) {
      return button.attributes.containsKey('disabled')
          ? ClockingStatus.done
          : ClockingStatus.available;
    }
    return ClockingStatus.unavailable;
  }

  String? _extractButtonValue(Document doc) {
    return doc.getElementById('Button0')?.attributes['value'];
  }

  Future<Uint8List> _fetchCaptchaImage() async {
    final resp = await _client.get('$_clockInBaseUrl/validateCode.aspx',
        options: Options(headers: {
          'referer': '$_clockInBaseUrl/ClassClockin.aspx',
        }));
    return Uint8List.fromList(resp.data);
  }

  Future<bool> clock(String captcha) async {
    try {
      var resp = await _client.post('$_clockInBaseUrl/Student.aspx',
          data: {'validateCode': captcha},
          options: Options(
            contentType: 'application/x-www-form-urlencoded',
          ));
      return _extractStatus(resp.data) == ClockingStatus.done;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

class ClockingPageStatus {
  final ClockingStatus status;
  final String? buttonValue;
  final Uint8List? captchaImage;

  ClockingPageStatus(this.status, this.buttonValue, this.captchaImage);
}

enum ClockingStatus {
  available,
  unavailable,
  done;
}

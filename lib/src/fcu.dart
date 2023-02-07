import 'package:http/http.dart' as http;
import 'dart:convert';

import 'data.dart';

final timetableDataURL = Uri.https('service206-sds.fcu.edu.tw', '/mobileservice/CourseService.svc/Timetable2');

class FCU {
  final String _id;
  final String _password;
  final http.Client _client = http.Client();

  FCU(this._id, this._password);

  void close() {
    _client.close();
  }

  Future<Timetable> fetchTimetable() async {
    final resp = await _client.post(timetableDataURL,
        headers: {'Content-type': 'application/json'}, body: jsonEncode({'Account': _id, 'Password': _password}));
    return Timetable.fromJson(jsonDecode(resp.body));
  }
}

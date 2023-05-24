import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class TimetableManager {
  final Dio _client;
  final String _user;
  final String _password;

  TimetableManager(this._client, this._user, this._password);

  Future<Iterable<Section>> fetchTimetable() async {
    try {
      final resp = await _client.post(
          'https://service206-sds.fcu.edu.tw/mobileservice/CourseService.svc/Timetable2',
          data: jsonEncode({'Account': _user, 'Password': _password}),
          options: Options(
              headers: {HttpHeaders.contentTypeHeader: 'application/json'}));
      final sections = (resp.data['TimetableTw'] as List<dynamic>)
          .map((x) => Section.fromJson(x))
          .where((x) => x.day >= 1 && x.day <= 7);
      return sections;
    } catch (e) {
      print(e);
      return Iterable.empty();
    }
  }
}

class Section implements Comparable<Section> {
  final int day;
  final int section;
  final String loc;
  final String name;

  Section(
      {required this.day,
      required this.section,
      required this.loc,
      required this.name});

  @override
  int compareTo(Section other) {
    if (day != other.day) return day - other.day;
    if (section != other.section) return section - other.section;
    return 0;
  }

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
        day: json['SctWeek'],
        section: json['SctPeriod'],
        loc: json['RomName'],
        name: json['SubName']);
  }
}

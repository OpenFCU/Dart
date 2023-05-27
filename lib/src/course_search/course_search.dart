import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'course.dart';
import 'basic_search_filter.dart';
import 'extra_search_filter.dart';

class CourseSearchManager {
  final Dio _client;

  CourseSearchManager(this._client);

  Future<Set<Course>> search(BasicSearchFilter filter,
      [List<ExtraFilter>? extraFilters]) async {
    try {
      final resp = await _client.post(
          'https://coursesearch04.fcu.edu.tw/Service/Search.asmx/GetType2Result',
          data: jsonEncode(filter.toDTO()),
          options: Options(
              headers: {HttpHeaders.contentTypeHeader: 'application/json'}));
      final coursesJson = jsonDecode(resp.data['d'])['items'] as List<dynamic>;
      Iterable<Course> courses = coursesJson
          .map((x) => Course.fromJson(x, filter.year, filter.semester));
      if (extraFilters != null) {
        for (final extraFilter in extraFilters) {
          courses = extraFilter.filter(courses);
        }
      }
      return courses.toSet();
    } catch (e) {
      return {};
    }
  }
}

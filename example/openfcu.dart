import 'package:openfcu/openfcu.dart';
import 'package:openfcu/src/course_search/basic_search_filter.dart';
import 'package:openfcu/src/course_search/extra_search_filter.dart';

Future<void> main(List<String> arguments) async {
  final api = OpenFcu('D1234567', 'password');

  await clocking(api);
  await timetable(api);
  await courseSearch(api);

  api.close();
}

Future<void> clocking(OpenFcu api) async {
  final success = await api.clocking.login();
  if (success) {
    final status = await api.clocking.currentStatus();
    print('clocking status: ${status.status}');
    print('button value: ${status.buttonValue}');
  } else {
    print('Login failed');
  }
}

Future<void> timetable(OpenFcu api) async {
  final sections = await api.timetable.fetchTimetable();
  for (final section in sections) {
    print('${section.day}-${section.section} ${section.name}');
  }
}

Future<void> courseSearch(OpenFcu api) async {
  final courses = await api.courseSearch.search(
      BasicSearchFilter(year: 111, semester: 2, day: 2),
      [LocationExtraFilter("資電234")]);
  for (final c in courses) {
    print("${c.code} ${c.name}");
  }
}

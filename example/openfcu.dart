import 'package:openfcu/openfcu.dart';

Future<void> main(List<String> arguments) async {
  final api = OpenFcu('D1234567', 'password');

  await clocking(api);
  await timetable(api);

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

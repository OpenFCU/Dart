import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:fcu/fcu.dart';

class ClassListCommand extends Command {
  @override
  final name = 'class';
  @override
  final description = '列出所有課堂';

  final FCU _api;

  ClassListCommand(this._api);

  @override
  Future<void> run() async {
    final tt = await _api.fetchTimetable();
    print(jsonEncode(tt));
  }
}

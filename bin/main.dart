import 'package:args/command_runner.dart';
import 'package:dotenv/dotenv.dart';
import 'package:fcu/fcu.dart';

import 'command.dart';

void main(List<String> args) {
  final env = DotEnv()..load();
  final api = FCU(env['FCU_USER']!, env['FCU_PASS']!);
  CommandRunner('fcu-cli', 'Unofficial FCU Service SDK')
    ..addCommand(ClassListCommand(api))
    ..run(args);
  api.close();
}

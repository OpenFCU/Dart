# Unofficial FCU Dart SDK

Access to services by emulating HTTP requests and parsing responses.

## Features

- FCU Mobile
  - Fetch classes

## Usage

### Import as Library

```dart
Future<void> main() async {
  final api = FCU('D1234567', 'password');
  final timetable = await api.fetchTimetable();
  print(jsonEncode(timetable));
}
```

### Standalone Executable

Create `.env` file at project root like following:

```shell
FCU_USER=D1234567
FCU_PASS=password
```

`FCU_USER` is your NID ,`FCU_PASS` is your NID password.

Run with:

```shell
dart compile exe -o fcu ./cmd/main.dart
./fcu class
```

It will print all classes in JSON format.

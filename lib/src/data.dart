import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class Timetable {
  final int year;
  final int semester;
  final int count;
  final List<Clazz> clazzs;

  Timetable(this.year, this.semester, this.count, this.clazzs);

  factory Timetable.fromJson(Map<String, dynamic> json) {
    final l = (json['TimetableTw'] as List<dynamic>)
        .where((x) => x != null && x['SubId'] != null && (x['SubId'] as String).isNotEmpty)
        .map((x) => Clazz.fromJson(x))
        .toList();
    final year = l.isNotEmpty ? json['TimetableTw'][0]['YmsYear'] : 0;
    final semester = l.isNotEmpty ? json['TimetableTw'][0]['YmsSmester'] : 0;
    return Timetable(year, semester, l.length, l);
  }

  Map<String, dynamic> toJson() => _$TimetableToJson(this);
}

@JsonSerializable()
class Clazz {
  final String id;
  final String name;
  final int day;
  final int section;
  final String location;

  Clazz(this.id, this.name, this.day, this.section, this.location);

  factory Clazz.fromJson(Map<String, dynamic> json) => Clazz(
        json['ClsId'] as String,
        json['SubName'] as String,
        json['SctWeek'] as int,
        json['SctPeriod'] as int,
        json['RomName'] as String,
      );

  Map<String, dynamic> toJson() => _$ClazzToJson(this);
}

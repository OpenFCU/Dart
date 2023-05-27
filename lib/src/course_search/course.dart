import 'package:openfcu/src/util.dart';

class Course {
  final String name;
  final String id;
  final String fullID;
  final int code;
  final String teacher;
  final List<Period> periods;
  final int credit;
  final Opener opener;
  final int openNum;
  final int acceptNum;
  final String? remark;

  const Course(
      {required this.name,
      required this.id,
      required this.fullID,
      required this.code,
      required this.teacher,
      required this.periods,
      required this.credit,
      required this.opener,
      required this.openNum,
      required this.acceptNum,
      required this.remark});

  @override
  bool operator==(Object other) {
    if (other is! Course) return false;
    return code == other.code;
  }

  @override
  int get hashCode => code.hashCode;

  factory Course.fromJson(Map<String, dynamic> json, int year, int semester) {
    final (periods, teacher) = Period.parse(json['scr_period']);
    final classId = json['cls_id']! as String;
    return Course(
        name: json['sub_name'],
        id: json['sub_id3'],
        fullID:
            "$year$semester${json['cls_id']}${json['sub_id']}${json['scr_dup']}",
        code: int.parse(json['scr_selcode']),
        teacher: teacher,
        periods: periods.toList(growable: false),
        credit: (json['scr_credit'] as double).round(),
        opener: Opener(
            name: json['cls_name'],
            academyId: classId.substring(0, 2),
            departId: classId.substring(2, 4),
            idk: classId[4],
            grade: classId[5],
            clazz: classId[6]),
        openNum: (json['scr_precnt'] as double).round(),
        acceptNum: (json['scr_acptcnt'] as double).round(),
        remark: json['scr_remarks']);
  }

}

// CE 電資學院
// 07 資訊系
// 1 IDK what's this
// 3 年級
// 1 班級
class Opener {
  final String name;
  final String academyId;
  final String departId;
  final String idk;
  final String grade;
  final String clazz;

  const Opener(
      {required this.name,
      required this.academyId,
      required this.departId,
      required this.idk,
      required this.grade,
      required this.clazz});
}

class Period {
  final int day;
  final int start;
  final int end;
  final String location;

  const Period(this.day, this.start, this.end, this.location);

  static (Iterable<Period>, String) parse(String raw) {
    final periods = RegExp(r"\((.)\)(\d{2}) +(\S+)").allMatches(raw).map((x) {
      final week = x.group(1)!;
      final st = int.parse(x.group(2)!);
      final loc = x.group(3)!;
      return Period(str2day[week] ?? 0, st - 1, st - 1, loc);
    }).followedBy(
        RegExp(r"\((.)\)(\d{2})-(\d{2}) +(\S+)").allMatches(raw).map((x) {
      final week = x.group(1)!;
      final st = int.parse(x.group(2)!);
      final ed = int.parse(x.group(3)!);
      final loc = x.group(4)!;
      return Period(str2day[week] ?? 0, st - 1, ed - 1, loc);
    }));
    final index = raw.lastIndexOf(" ");
    var teacher = raw.substring(index).trimChars(",").replaceAll(",", "、");
    if (periods.map((x) => x.location).any((loc) => loc.contains(teacher))) {
      teacher = "";
    }
    return (periods, teacher);
  }
}

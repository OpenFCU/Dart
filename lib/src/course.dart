class Course {
  final String name;
  final String id;
  final String fullID;
  final int code;
  final String teacher;
  final List<Period> periods;
  final int credit;
  final String opener;
  final int openNum;
  final int acceptNum;
  final String remark;

  Course(this.name, this.id, this.fullID, this.code, this.teacher, this.periods,
      this.credit, this.opener, this.openNum, this.acceptNum, this.remark);
}

class Period {
  final int day;
  final int start;
  final int end;
  final String location;

  Period(this.day, this.start, this.end, this.location);
}

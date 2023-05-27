import 'course.dart';

abstract interface class ExtraFilter {
  Iterable<Course> filter(Iterable<Course> courses);
}

class CreditExtraFilter implements ExtraFilter {
  final int credit;

  CreditExtraFilter(this.credit);

  @override
  Iterable<Course> filter(Iterable<Course> courses) =>
      courses.where((course) => course.credit == credit);
}

class OpenerNameExtraFilter implements ExtraFilter {
  final String name;

  OpenerNameExtraFilter(this.name);

  @override
  Iterable<Course> filter(Iterable<Course> courses) =>
      courses.where((course) => course.opener.name.contains(name));
}

class DayExtraFilter implements ExtraFilter {
  final int day;

  DayExtraFilter(this.day);

  @override
  Iterable<Course> filter(Iterable<Course> courses) => courses
      .where((course) => course.periods.any((period) => period.day == day));
}

class SectionExtraFilter implements ExtraFilter {
  final int section;

  SectionExtraFilter(this.section);

  @override
  Iterable<Course> filter(Iterable<Course> courses) =>
      courses.where((course) => course.periods
          .any((period) => period.start < section && period.end > section));
}

class LocationExtraFilter implements ExtraFilter {
  final String location;

  LocationExtraFilter(this.location);

  @override
  Iterable<Course> filter(Iterable<Course> courses) => courses.where((course) =>
      course.periods.any((period) => period.location.contains(location)));
}

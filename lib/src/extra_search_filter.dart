import 'course.dart';

abstract interface class ExtraFilter {
  Iterable<Course> filter(Iterable<Course> courses);
}

class CreditExtraFilter implements ExtraFilter {
  final int value;

  CreditExtraFilter(this.value);

  @override
  Iterable<Course> filter(Iterable<Course> courses) =>
      courses.where((course) => course.credit == value);
}

class OpenerExtraFilter implements ExtraFilter {
  final String value;

  OpenerExtraFilter(this.value);

  @override
  Iterable<Course> filter(Iterable<Course> courses) =>
      courses.where((course) => course.opener.contains(value));
}

class DayExtraFilter implements ExtraFilter {
  final int value;

  DayExtraFilter(this.value);

  @override
  Iterable<Course> filter(Iterable<Course> courses) => courses
      .where((course) => course.periods.any((period) => period.day == value));
}

class SectionExtraFilter implements ExtraFilter {
  final int value;

  SectionExtraFilter(this.value);

  @override
  Iterable<Course> filter(Iterable<Course> courses) =>
      courses.where((course) => course.periods
          .any((period) => period.start < value && period.end > value));
}

class LocationExtraFilter implements ExtraFilter {
  final String value;

  LocationExtraFilter(this.value);

  @override
  Iterable<Course> filter(Iterable<Course> courses) => courses.where((course) =>
      course.periods.any((period) => period.location.contains(value)));
}

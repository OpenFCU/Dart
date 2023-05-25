class BasicSearchFilter {
  final int year;
  final int semester;
  final String name;
  final String teacher;
  final int? code;
  final int? day;
  final int? sections;

  BasicSearchFilter(
      {required this.year,
      required this.semester,
      this.name = '',
      this.teacher = '',
      this.code,
      this.day,
      this.sections});

  Map<String, dynamic> toDTO() => {
        'baseOptions': _getBaseOptions(),
        'typeOptions': _getTypeOptions(),
      };

  Map<String, dynamic> _getBaseOptions() => {
        'lang': 'cht',
        'year': year,
        'sms': semester,
      };

  Map<String, dynamic> _getTypeOptions() {
    final options = <String, dynamic>{};
    if (name.isNotEmpty) {
      options['course'] = {'enabled': true, 'value': name};
    }
    if (teacher.isNotEmpty) {
      options['teacher'] = {'enabled': true, 'value': teacher};
    }
    if (code != null) {
      options['code'] = {'enabled': true, 'value': code.toString()};
    }
    if (day != null || sections != null) {
      options['weekPeriod'] = {
        'enabled': true,
        'week': day?.toString() ?? '*',
        'period': sections?.toString() ?? '*',
      };
    }
    return options;
  }
}

extension UrlOrigin on Uri {
  get page => origin + path;
}

extension StringExt on String {
  String trimChars(String chars) => trimLeftChars(chars).trimRightChars(chars);

  String trimLeftChars(String chars) {
    for (int i = 0; i < length; i++) {
      if (!chars.contains(this[i])) {
        return substring(i);
      }
    }
    return "";
  }

  String trimRightChars(String chars) {
    for (int i = length - 1; i >= 0; i--) {
      if (!chars.contains(this[i])) {
        return i == length - 1 ? this : substring(0, i+1);
      }
    }
    return "";
  }
}

Map<String, int> str2day = {
  '一': 0,
  '二': 1,
  '三': 2,
  '四': 3,
  '五': 4,
  '六': 5,
  '日': 6,
};
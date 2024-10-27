extension StringCaseExtension on String {
  bool get isLowerCase {
    if (length > 1) throw Exception('isLowerCase called on list of char, length $length');
    for (final char in runes) { if (char >= 65 && char <= 90) return false; }
    return isNotEmpty && isNotBlank;
  }

  String replaceCharAt(int index, String replacement) {
    try {
      // return replaceRange(index, index, replacement);
      return substring(0, index) + replacement + substring(index + 1);
    } catch (e) {
      throw Exception('replaceCharAt Error - $e');
    }
  }

  String get lowerOrUpper {
    if (length > 1) throw Exception('lowerOrUpper called on list of char, length $length');
    return isLowerCase ? toUpperCase() : toLowerCase();
  }

  bool get isNotBlank => this != ' ';
  bool equalsIgnoreCase(String other) => toUpperCase() == other.toUpperCase();
}
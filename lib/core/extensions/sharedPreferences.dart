import 'package:shared_preferences/shared_preferences.dart';

extension SharedPreferencesExtension on SharedPreferences {
  String get _intListSeparator => '/';

  Set<int>? getIntSet(String key) {
    final str = getString(key);
    if (str == null) return null;
    return str.split(_intListSeparator).map((s) => int.parse(s)).toSet();
  }

  void setIntSet(String key, Set<int> intSet) {
    final str = intSet.map((i) => i.toString() ).join(_intListSeparator);
    setString(key, str);
  }

  List<int>? getIntList(String key) {
    final str = getString(key);
    if (str == null) return null;
    return str.split(_intListSeparator).map((s) => int.parse(s)).toList();
  }

  void setIntList(String key, List<int> intList) {
    final str = intList.map((i) => i.toString() ).join(_intListSeparator);
    setString(key, str);
  }
}
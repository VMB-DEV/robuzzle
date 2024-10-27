extension ListIntExtension on List<int> {
  List<int> noZero() => where((integer) => integer != 0).toList();
}

extension ListStringExtension on List<String> {
  List<String> switchHorizontalAndVertical() {
    if (isEmpty) return [];
    final List<String> list = List.generate(first.length, (colNumber) {
      String col = '';
      for (final row in this) { col += row[colNumber]; }
      return col;
    });
    return list;
  }
}

extension ListExtension<T> on List<T> {
  int safeIndex(int i) {
    if (i < 0) { throw RangeError('Index cannot be negative'); }
    return i < length ? i : length - 1;
  }

  int? indexOrNull(int i) {
    if (i < 0) { throw RangeError('Index cannot be negative'); }
    return i < length ? i : null;
  }

  List<T> safeRemoveAt(int index) {
    if (index >= 0 && index < length) {
      removeAt(index);
    }
    return this;
  }


  // List<T> copy() => List.from(this);
  List<T> get copy => List.from(this);
}

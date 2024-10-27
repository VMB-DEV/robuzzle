extension ExtendedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int i, E e) f) {
    var i = 0;
    return map((e) => f(i++, e));
  }

  void forEachIndexed(void Function(int i, E e) f) {
    var i = 0;
    forEach((e) => f(i++, e));
  }
}

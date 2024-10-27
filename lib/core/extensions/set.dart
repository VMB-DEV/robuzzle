extension SetExtension<T> on Set<T> {
  Set<T> get copy => Set.from(this);

  Iterable<T> get _asIterable => this;

  T operator [] (int index) {
    if (index < 0 || index >= length) throw RangeError('index $index : $this');
    return elementAt(index);
  }
}

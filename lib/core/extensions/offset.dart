import 'dart:ui';

extension OffsetExtension on Offset {
  Offset get copy => Offset(dx, dy);

  Offset minusX(double x) => Offset(dx - x, dy);
  Offset minusY(double y) => Offset(dx, dy - y);
  Offset plusX(double x) => Offset(dx + x, dy);
  Offset plusY(double y) => Offset(dx, dy + y);

  // Offset operator + (double x) => Offset(double)
}
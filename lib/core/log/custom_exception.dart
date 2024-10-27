import 'package:robuzzle/core/log/method_name.dart';

class MyException implements Exception {
  final dynamic message;

  MyException([this.message]);

  String toString() {
    Object? message = this.message;
    if (message == null) return "Exception";
    return "Exception: ${callerMethodNameFrom(StackTrace.current)} $message";
  }
}


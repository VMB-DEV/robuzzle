String methodNameFrom(StackTrace stackTrace) {
  final trace = stackTrace.toString().split('\n')[0];
  final indexOfWhiteSpace = trace.indexOf(' ');
  final subStr = trace.substring(indexOfWhiteSpace);
  final indexOfFunction = subStr.indexOf(RegExp('[A-Za-z0-9]'));

  return subStr
      .substring(indexOfFunction)
      .substring(0, subStr.substring(indexOfFunction).indexOf(' '));
}

String callerMethodNameFrom(StackTrace stackTrace) {
  final trace = stackTrace.toString().split('\n')[1];
  final indexOfWhiteSpace = trace.indexOf(' ');
  final subStr = trace.substring(indexOfWhiteSpace);
  final indexOfFunction = subStr.indexOf(RegExp('[A-Za-z0-9]'));

  return subStr
      .substring(indexOfFunction)
      .substring(0, subStr.substring(indexOfFunction).indexOf(' '));
}

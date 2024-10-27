import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String msg;
  const ErrorView(this.msg, {super.key});

  @override
  Widget build(BuildContext context) {
    print(msg);
    return Center( child: Text('Error : $msg'), );
  }
}

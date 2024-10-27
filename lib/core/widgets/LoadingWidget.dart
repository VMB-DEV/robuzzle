import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String msg;
  const LoadingWidget(this.msg, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(child: Text(msg)),
        const CircularProgressIndicator()
      ],
    );
  }
}
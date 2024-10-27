import 'package:flutter/cupertino.dart';

class UnknownStateWidget extends StatelessWidget {
  final String stateName;
  final String msg;
  const UnknownStateWidget({required this.stateName, this.msg = '', super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Unknown State $stateName'));
  }
}

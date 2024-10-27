import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc_settings.dart';
import '../bloc/event_settings.dart';

class SpeedSlider extends StatefulWidget {
  final double value;
  const SpeedSlider({required this.value, super.key});

  @override
  State<SpeedSlider> createState() => _SpeedSliderState(value);
}

class _SpeedSliderState extends State<SpeedSlider> {
  double _currentSliderValue;
  _SpeedSliderState(this._currentSliderValue);

  @override
  Widget build(BuildContext context) {
    return Slider(
      activeColor: Colors.teal.shade600,
      thumbColor: Colors.tealAccent.shade400,
      value: _currentSliderValue,
      min: 0,
      max: 1,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
      onChangeEnd: (double value) {
        context.read<SettingsBloc>().add(SettingsEventSetSpeed(value: value));
      },
    );
  }
}

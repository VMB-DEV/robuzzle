import 'package:equatable/equatable.dart';

import '../../domain/entities/entity_settings.dart';
import '../../domain/entities/entity_theme_type.dart';

abstract class SettingsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SettingsEventGet extends SettingsEvent {}
class SettingsEventSet extends SettingsEvent {
  final SettingsEntity settings;
  SettingsEventSet(this.settings);

  @override
  List<Object> get props => [settings];
}

class SettingsEventSetSpeed extends SettingsEvent {
  final double value;
  SettingsEventSetSpeed({required this.value});
  @override
  List<Object> get props => [value];
}

class SettingsEventSetTheme extends SettingsEvent {
  final ThemeTypeEntity theme ;
  SettingsEventSetTheme({required this.theme});
  @override
  List<Object> get props => [theme];
}

class SettingsEventSetLeftHand extends SettingsEvent {
  final bool leftHand ;
  SettingsEventSetLeftHand({required this.leftHand});
  @override
  List<Object> get props => [leftHand];
}
class SettingsEventSetAnimations extends SettingsEvent {
  final bool animations ;
  SettingsEventSetAnimations({required this.animations});
  @override
  List<Object> get props => [animations];
}

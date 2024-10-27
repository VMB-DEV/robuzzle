import 'package:equatable/equatable.dart';

import '../../domain/entities/entity_settings.dart';

sealed class SettingsState extends Equatable {
  @override
  List<Object> get props => [];
}

class SettingsStateLoading extends SettingsState {}

class SettingsStateError extends SettingsState {
  final String message;

  SettingsStateError({required this.message});

  @override
  List<Object> get props => [message];
}

class SettingsStateLoaded extends SettingsState {
  final SettingsEntity settings;

  SettingsStateLoaded({required this.settings});

  @override
  List<Object> get props => [settings];
}

class SettingsStateTrollAnimation extends SettingsStateLoaded {
  final int counter;
  SettingsStateTrollAnimation({required this.counter, required super.settings});

  @override
  List<Object> get props => [counter, settings];
}

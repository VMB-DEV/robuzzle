import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robuzzle/features/settings/presentation/bloc/state_settings.dart';
import '../../../../core/log/consolColors.dart';
import '../../domain/entities/entity_settings.dart';
import '../../domain/usecases/usecase_settings.dart';
import '../widget/troll_settings.dart';
import 'event_settings.dart';

//TODO: STRING hard coded
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsUseCase useCase;
  int trollCount = 0;

  SettingsBloc({
    required this.useCase,
  }) : super(
      SettingsStateLoading()
  ) {
    on<SettingsEventGet>(_onGetSettings);
    on<SettingsEventSet>(_onSetSettings);
    on<SettingsEventSetSpeed>(_onSetSpeed);
    on<SettingsEventSetTheme>(_onSetTheme);
    on<SettingsEventSetLeftHand>(_onSetLeftHand);
    on<SettingsEventSetAnimations>(_onSetAnimation);
  }

  void _onSetAnimation(SettingsEventSetAnimations event, Emitter<SettingsState> emit) {
    try {
      final currentState = state as SettingsStateLoaded;
      final newSettings = currentState.settings.copyWith(animations: event.animations);
      useCase.setSettingsEntity(entity: newSettings);
      emit(SettingsStateLoaded(settings: newSettings));
    } catch (e) { _triggerError(emit, state, event, e); }
  }

  void _onSetLeftHand(SettingsEventSetLeftHand event, Emitter<SettingsState> emit) {
    try {
      final currentState = state as SettingsStateLoaded;
      final newSettings = currentState.settings.copyWith(leftHand: event.leftHand);
      useCase.setSettingsEntity(entity: newSettings);
      emit(SettingsStateLoaded(settings: newSettings));
    } catch (e) { _triggerError(emit, state, event, e); }
  }

  void _onSetTheme(SettingsEventSetTheme event, Emitter<SettingsState> emit) {
    try {
      final currentState = state as SettingsStateLoaded;
      if (state is! SettingsStateTrollAnimation) {
        emit(SettingsStateTrollAnimation(settings: currentState.settings.copy, counter: trollCount));
        Future.delayed(Duration(milliseconds: trollCount < SettingsTroll.maxCount ? 700 : 2000)).then((value) {
          trollCount = trollCount < SettingsTroll.maxCount ? trollCount + 1 : 0;
          final currentState = state as SettingsStateLoaded;
          add(SettingsEventSet(currentState.settings.copy));
        });
      }
    } catch (e) { _triggerError(emit, state, event, e); }
  }

  void _onSetSpeed(SettingsEventSetSpeed event, Emitter<SettingsState> emit) {
    try {
      final currentState = state as SettingsStateLoaded;
      final int newSpeed = SettingsEntity.getSpeedFromScale(event.value);
      final newSettings = currentState.settings.copyWith(speed: newSpeed);
      useCase.setSettingsEntity(entity: newSettings);
      emit(SettingsStateLoaded(settings: newSettings));
    } catch (e) { _triggerError(emit, state, event, e); }
  }

  Future<void> _onGetSettings(SettingsEventGet event, Emitter<SettingsState> emit) async {
    try {
      print('SettingsBloc._onGetSettings - ');
      final SettingsEntity settings = await useCase.getSettingsEntity();
      emit(SettingsStateLoaded(settings: settings));
    } catch (e) { _triggerError(emit, state, event, e); }
  }

  Future<void> _onSetSettings(SettingsEventSet event, Emitter<SettingsState> emit) async {
    print('SettingsBloc._onSetSettings - ');
    try {
      useCase.setSettingsEntity(entity: event.settings);
      emit(SettingsStateLoaded(settings: event.settings));
    } catch (e) { _triggerError(emit, state, event, e); }
  }

  void _triggerError(Emitter<SettingsState> emit, SettingsState state, SettingsEvent event, Object error)
  => emit(SettingsStateError(message: 'At state -> ${state.runtimeType.toString()}\n'
      'Calling event -> ${event.runtimeType}\n'
      '${error.toString()}'
  ));
}

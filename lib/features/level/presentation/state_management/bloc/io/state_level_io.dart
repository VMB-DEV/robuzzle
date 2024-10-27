import 'package:equatable/equatable.dart';

import '../../../../domain/entities/level/entity_level.dart';

sealed class LevelIOState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LevelIOStateLoading extends LevelIOState {}

class LevelIOStateError extends LevelIOState {
  final String message;
  LevelIOStateError(this.message);
  factory LevelIOStateError.missType(String methodName, LevelIOState state)
  => LevelIOStateError( '$methodName - state missType - state is ${state.runtimeType}' );

  @override
  List<Object> get props => [message];
}

class LevelIOStateLoaded extends LevelIOState {
  final LevelEntity level;
  LevelIOStateLoaded(this.level);

  @override
  List<Object?> get props => [];
}

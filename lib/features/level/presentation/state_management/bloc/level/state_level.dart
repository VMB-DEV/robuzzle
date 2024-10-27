import 'package:equatable/equatable.dart';
import 'package:robuzzle/features/level/domain/entities/level/entity_level.dart';

sealed class LevelState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LevelStateLoading extends LevelState {}

class LevelStateError extends LevelState {
  final String message;
  LevelStateError({required this.message});

  factory LevelStateError.missType(String methodName, LevelState state)
  => LevelStateError( message: '$methodName - state missType - state is ${state.runtimeType}' );

  @override
  List<Object> get props => [message];
}

class LevelStateLoaded extends LevelState {
  final LevelEntity level;
  final int difficulty;
  LevelStateLoaded(this.level, this.difficulty);

  @override
  List<Object?> get props => [level, difficulty];
}

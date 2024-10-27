import 'package:equatable/equatable.dart';

abstract class LevelEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// called to get a level from the local data
class LevelEventLoadLevelByID extends LevelEvent {
  final int id;
  final int difficulty;
  LevelEventLoadLevelByID(this.id, this.difficulty);

  @override
  List<Object> get props => [id];
}

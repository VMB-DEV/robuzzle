import 'package:equatable/equatable.dart';

abstract class LevelIOEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// called to get a level from the local data
class LevelIOEventGetById extends LevelIOEvent {
  final int id;
  LevelIOEventGetById(this.id);

  @override
  List<Object> get props => [id];
}

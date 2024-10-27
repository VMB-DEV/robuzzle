import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/io/state_level_io.dart';

import '../../../../../../core/log/method_name.dart';
import '../../../../domain/entities/level/entity_level.dart';
import '../../../../domain/entities/progress/action/entity_action.dart';
import '../../../../domain/entities/progress/action/entity_case_color.dart';
import '../../../../domain/entities/progress/action/entity_player_instruction.dart';
import '../../../../domain/usecases/usecase_get_level.dart';
import 'event_level_io.dart';

class LevelIOBloc extends Bloc<LevelIOEvent, LevelIOState> {
  final GetLevelUseCase getLevelUseCase;


  LevelIOBloc({
    required this.getLevelUseCase
  }): super(LevelIOStateLoading()) {
    on<LevelIOEventGetById>(_getLevelById);
  }

  Future<void> _getLevelById(LevelIOEventGetById event, Emitter<LevelIOState> emit) async {
    emit(LevelIOStateLoading());
    try {
      final LevelEntity level = await getLevelUseCase.call(event.id);
      level.functions.values[0][0] = ActionEntity(instruction: PlayerInstructionEntity.goForward, color: CaseColorEntity.red);
      emit(LevelIOStateLoaded(level));
    } catch(e) {
      emit(LevelIOStateError(methodNameFrom(StackTrace.current) + e.toString()));
    }
  }
}


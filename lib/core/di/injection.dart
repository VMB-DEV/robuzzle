import 'package:robuzzle/core/data/puzzle/repositories/repository_puzzle_impl.dart';
import 'package:robuzzle/core/data/puzzle/repositories/repository_puzzle_list_impl.dart';
import 'package:robuzzle/features/level/domain/repository/repository_puzzle.dart';
import 'package:robuzzle/features/level/domain/usecases/usecase_get_level.dart';
import 'package:robuzzle/features/level/domain/usecases/usecase_set_progress.dart';
import 'package:robuzzle/features/level/domain/usecases/usecase_set_win.dart';
import 'package:robuzzle/features/puzzles_list/domain/repository/repository_puzzle_list.dart';
import 'package:robuzzle/features/puzzles_list/domain/usecases/usecase_get_puzzle_id_list_fav_by_diff.dart';
import 'package:robuzzle/features/puzzles_list/domain/usecases/usecase_set_puzzle_id_list_fav_by_diff.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import '../../features/level/data/data_source/local_datasource_progress.dart';
import '../../features/level/data/data_source/local_datasource_progress_impl.dart';
import '../../features/level/data/repository/repository_progress_impl.dart';
import '../../features/level/domain/repository/repository_progress.dart';
import '../../features/puzzles_list/data/data_source/local_data_source_puzzle_id_list.dart';
import '../../features/puzzles_list/data/data_source/local_data_source_puzzle_id_list_impl.dart';
import '../../features/puzzles_list/data/repository/repository_puzzle_list_id_impl.dart';
import '../../features/puzzles_list/domain/repository/repository_puzzle_list_id.dart';
import '../../features/puzzles_list/domain/usecases/usecase_get_puzzle_id_finished_by_diff.dart';
import '../../features/puzzles_list/domain/usecases/usecase_get_puzzle_id_list_by_diff.dart';
import '../../features/puzzles_list/domain/usecases/usecase_get_puzzle_list.dart';
import '../../features/settings/data/data_source/local_data_source_settings.dart';
import '../../features/settings/data/data_source/local_data_source_settings_impl.dart';
import '../../features/settings/data/repositories/repository_settings_impl.dart';
import '../../features/settings/domain/repositories/repository_settings.dart';
import '../../features/settings/domain/usecases/usecase_settings.dart';
import '../../features/settings/presentation/bloc/bloc_settings.dart';
import '../data/puzzle/data_source/local_datasource_puzzle.dart';
import '../data/puzzle/data_source/local_datasource_puzzle_impl.dart';

final GetIt getIt = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  /// setup for the Settings options
  getIt.registerLazySingleton<SettingsLocalDataSource>(() => SettingsLocalDataSourceImpl(getIt())); // LocalDataSource
  getIt.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(localDataSource: getIt())); // Repository
  getIt.registerLazySingleton(() => SettingsUseCase(repository: getIt())); // UseCase
  getIt.registerFactory(() => SettingsBloc(useCase: getIt())); // Bloc

  /// setup for Level
  getIt.registerLazySingleton<PuzzleLocalDataSource>(() => PuzzleLocalDataSourceImpl());
  getIt.registerLazySingleton<PuzzleRepository>(() => PuzzleRepositoryImpl(puzzleDataSource: getIt()));
  getIt.registerLazySingleton<ProgressLocalDataSource>(() => ProgressLocalDataSourceImpl(sharedPreferences: getIt()));
  getIt.registerLazySingleton<ProgressRepository>(() => ProgressRepositoryImpl(progressDataSource: getIt()));
  getIt.registerLazySingleton<GetLevelUseCase>(() => GetLevelUseCase(puzzleRepo: getIt(), progressRepo: getIt()));
  getIt.registerLazySingleton<SetProgressUseCase>(() => SetProgressUseCase(progressRepo: getIt()));
  getIt.registerLazySingleton<SetWinUseCase>(() => SetWinUseCase(progressRepo: getIt()));
  // getIt.registerFactory( () => DgDpBloc(getLevelUseCase: getIt()) ); // Bloc

  /// setup for Puzzle list
  getIt.registerLazySingleton<PuzzleListLocalDataSource>(() => PuzzleListLocalDataSourceImpl(sharedPreferences: getIt())); // LocalDataSource
  getIt.registerLazySingleton<PuzzleListIdRepository>(() => PuzzleListIdRepositoryImpl(localDataSource: getIt()));
  getIt.registerLazySingleton<PuzzleListRepository>(() => PuzzleListRepositoryImpl(puzzleDataSource: getIt()));
  getIt.registerLazySingleton<GetPuzzleIdListFinishedByDiffUseCase>(() => GetPuzzleIdListFinishedByDiffUseCase(levelListRepo: getIt()));
  getIt.registerLazySingleton<GetPuzzleIdListByDiffUseCase>(() => GetPuzzleIdListByDiffUseCase(levelListRepo: getIt()));
  getIt.registerLazySingleton<GetPuzzleIdListFavByDiffUseCase>(() => GetPuzzleIdListFavByDiffUseCase(levelListRepo: getIt()));
  getIt.registerLazySingleton<SetPuzzleIdListFavByDiffUseCase>(() => SetPuzzleIdListFavByDiffUseCase(levelListRepo: getIt()));
  getIt.registerLazySingleton<GetPuzzleEntityListById>(() => GetPuzzleEntityListById(puzzleRepo: getIt()));

}

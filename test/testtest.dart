import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:robuzzle/core/data/hive/hive_box_name.dart';
import 'package:robuzzle/core/data/hive/hiver.dart';
import 'package:robuzzle/core/data/puzzle/data_source/local_datasource_puzzle_impl.dart';
import 'package:robuzzle/core/data/puzzle/model/model_puzzle.dart';
import 'package:robuzzle/features/level/data/data_source/local_datasource_progress_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Mock path provider
    const MethodChannel pathChannel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        pathChannel,
            (MethodCall methodCall) async => '.'
    );
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({}); // Add any initial values you need for testing
    // Now you can get SharedPreferences instance
    final sharedPreferences = await SharedPreferences.getInstance();
    final test = ProgressLocalDataSourceImpl(sharedPreferences: sharedPreferences);

    // Initialize Hive
    await Hive.initFlutter();
    final hiver = Hiver();
    hiver.initAdapters();
    Hiver.buildPuzzleDataBase();
  });

  tearDownAll(() async {
    await Hive.close();
  });

  group("Test group", () {

    test("test test", () async {
      await Hive.openBox<PuzzleModel>(HiveBoxName.puzzleBoxName);
      final dataSource = PuzzleLocalDataSourceImpl();
      final puzzle = dataSource.getPuzzleModelById(8728);
      final id = puzzle.id;
      expect(id, 8728);
    });
  });
}
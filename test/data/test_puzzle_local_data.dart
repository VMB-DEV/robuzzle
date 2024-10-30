import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:robuzzle/core/data/hive/hive_box_name.dart';
import 'package:robuzzle/core/data/hive/hiver.dart';
import 'package:robuzzle/core/data/puzzle/data_source/local_datasource_puzzle_impl.dart';
import 'package:robuzzle/core/data/puzzle/model/model_puzzle.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    const MethodChannel pathChannel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        pathChannel,
            (MethodCall methodCall) async => '.'
    );

    // Initialize Hive
    await Hive.initFlutter();
    final hiver = Hiver();
    hiver.initAdapters();
    Hiver.buildPuzzleDataBase();
  });

  tearDownAll(() async {
    await Hive.close();
  });

  List<(int, String)> testCases = [
    ( 2133,
    "2133\n"
        "Fibonacci notation II (v2)\n"
        "\n"
        "smylic\n"
        "RBBBBBBBBBBBBBBRB              BB rBBBBBBR     BB B      B     BB B      B     BB RBBBBBBBBBB  BB        B  b  BB rR     B     BB BB     B     BB RBBBBBBR     BB  B           BRBBR rBBBGBBGBGR\n"
        "11, 9\n"
        "0\n"
        "3,8,5,5,0\n"
        "6\n"
    ),
    ( 8728,
    "8728\n"
        "Up We Go\n"
        "\n"
        "416646\n"
        "                                            rr             rr             rr             rr             rr             rr             rr             rr             rr             Rr           \n"
        "11, 3\n"
        "0\n"
        "5,0,0,0,0\n"
        "0\n"
    ),
    ( 469,
    "469\n"
        "Fat Snake\n"
        "\n"
        "recursive\n"
        "Bb  bbbr  bbbbbbbb  bgbb  bgbbgbbb  bb    bb  bbbb  bb    bb  bbbb  bb    bb  bbbb  bb    bb  bbbb  bgbbbbgb  bbbb  bbbbbbbb  bbbb            bbbb            bbbgbbbbbbbbbbbbgbbbbbbbbbbbbbbbbb\n"
        "0, 0\n"
        "1\n"
        "10,5,5,0,0\n"
        "0\n"
    ),
    (14841,
    "14841\n"
        "Trunnion\n"
        "\n"
        "axorion\n"
        " RBBBBBBBBBB RBB B         G B B B BBBBGBR B B B G B     B B B B B B BBb B B B B B B R   B B B B B B BBBBR B G B B B       B B B B RBBBGBBBB B B B             G BBBBBBBBBBBBBBR                \n"
        "8, 13\n"
        "3\n"
        "3,4,6,2,0\n"
        "0\n"
    ),
    (14826,
    "14826\n"
        "Fat Green Baby\n"
        "\'Robobble\' was his first word... just adorable. Hints in Comments\n"
        "jnpollack\n"
        "                    bbbbbbbb        bbbbbbbb        bbbbbbbb        bbbbbbbb         bbBbbb      bbbbbbbbbbbbbb  bbbbbbbbbbbbbb   bbbbbbbbbbbbg   bbbbbbbbbbbb   bbbbbbbbbbbbbb  bbbb      bbbb \n"
        "5, 7\n"
        "0\n"
        "5,5,0,0,0\n"
        "2\n"
    ),
    (12492,
    "12492\n"
        "Crawl &amp; Double (4 sides)\n"
        "Anti-hacking edition\n"
        "scorpio\n"
        "bbbbbbbbbbbb    bRRRRRRRRRRbbb  bR        RRRb  bR   bbbb   Rb  bR b  RRb RRRb  bRRb   RbRRbbb  bbbb bbbGbbb         bRRbR   bbb   bbbR bR    Rb   bRRR bR    Rb   b    bRRRRRRb        bbbbbbbb\n"
        "6, 8\n"
        "1\n"
        "5,5,5,5,0\n"
        "0\n"
    )
  ];

  Future<void> testGetPuzzleModelById((int, String) data) async {
    await Hive.openBox<PuzzleModel>(HiveBoxName.puzzleBoxName);
    final dataSource = PuzzleLocalDataSourceImpl();

    final puzzle = await dataSource.getPuzzleModelById(data.$1);
    final expectedPuzzle = PuzzleModel.parse(data.$2);

    expect(data.$1, puzzle.id);
    expect(expectedPuzzle.title, puzzle.title);
    expect(expectedPuzzle.author, puzzle.author);
    expect(expectedPuzzle.map, puzzle.map);
  }

  for (final testCase in testCases) {
    test(".getPuzzleModelById(${testCase.$1})", () async {
      await testGetPuzzleModelById(testCase);
    });
  }
}

class SharedPreferencesKeys {
  static const String leftHand = "left_hand";
  static const String speed = "speed";
  static const String themeType = "theme";
  static const String animations = "animation";
  static const String settings = "settings";
  // static const String allFinishedLevel = "all_finished_levels";
  static String puzzleFinished(int difficulty) => "level_finished_$difficulty";
  static String puzzleByDiff(int difficulty) => "level_difficulty_$difficulty";
  static String puzzleFavorite(int difficulty) => "level_favorite_$difficulty";
}
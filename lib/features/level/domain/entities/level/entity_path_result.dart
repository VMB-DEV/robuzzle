enum PathResultEntity {
  onGoing, loose, win;

  bool get isWin => this == win;
  bool get isLoose => this == loose;
  bool get isGoingOn => this == onGoing;
}
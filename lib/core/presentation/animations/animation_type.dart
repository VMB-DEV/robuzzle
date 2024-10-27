enum AnimationType {
  fadeScale,
  slideLeft,
  slideRight,
  slideBottom,
  slideTop;

  bool get isSlidingType => this == slideTop ||this == slideLeft ||this == slideRight ||this == slideBottom;
}
enum Pages {
  mainScreen('/'),
  level('/level'),
  list('/levels_list'),
  settings('/settings'),
  error('/error'),
  ;

  final String path;
  const Pages(this.path);
}
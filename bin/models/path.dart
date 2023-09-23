class YamlPath {
  final List<String> _path;

  const YamlPath([this._path = const []]);

  Iterable<String> get stem => _path.take(_path.length - 1);

  String className(String locale) =>
      "_${_path.map((e) => e.capitalize()).join()}${locale.localeCap()}";

  String superClassName() => "_${_path.map((e) => e.capitalize()).join()}Inu";

  String get key => _path.last;

  String join() => _path.join(".");

  bool get isEmpty => _path.isEmpty;

  YamlPath add(String key) => YamlPath([..._path, key]);
}

extension InuStrExtensions on String {
  String capitalize() =>
      (length > 1) ? this[0].toUpperCase() + substring(1) : toUpperCase();

  String localeCap() => capitalize().replaceAll('-', '');
}

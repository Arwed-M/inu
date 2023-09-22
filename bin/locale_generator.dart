import 'string_generator.dart';

typedef Yaml = Map<String, dynamic>;

class LocaleGenerator {
  final Set<String> classes =
      {}; // addittionally created classes for nested keys
  final Set<String> keys = {}; // every keyPath except ones w/ null value
  final Set<String> nullKeys = {}; // keyPaths for keys w/ null values
  final Yaml yaml; // parsed YAML asset
  final String localeCode;

  String generatedClass = "";

  final StringGenerator _gen;

  LocaleGenerator(this.yaml,
      {bool superClass = false, required this.localeCode})
      : _gen = superClass
            ? SuperStringGenerator(localeCode)
            : StringGenerator(localeCode) {
    generatedClass = _genLocale();
  }

  /// generate a Locale class from a YAML file
  String _genLocale() => [_genHeader(), classes.join()].join();

  String _genHeader() => [
        _gen.header,
        yaml.keys.map((topic) => _genAttribute(topic, yaml)).join(),
        _gen.blockEnd
      ].join();

  /// generate a new class from a [Map<String, dynamic>]
  void _genClass(KeyPath path, Yaml map) =>
      classes.add(_gen.classStructure(
          path,
          map.keys
              .map((key) => _genAttribute(key, map, path: path.toList()))
              .join()));

  /// generate the attributes of a class based on the type of the YAML key
  String _genAttribute(String key, Yaml map, {List<String>? path}) {
    path ??= [];

    dynamic value = map[key];

    path.add(key);

    switch (_NodeType.fromObj(value)) {
      case _NodeType.string:
        value = value.trim();
        if (value.isEmpty) {
          return _gen.emptyKey(path, key);
        } else {
          keys.add(path.join('.'));
          return _gen.stringEntry(key, value);
        }
      case _NodeType.map:
        _genClass(List.from(path), value);
        return _gen.classEntry(path);

      case _NodeType.empty:
        nullKeys.add(path.join('.'));
        return _gen.emptyKey(path, key);
      default:
        return "";
    }
  }
}

enum _NodeType {
  string,
  map,
  empty;

  static _NodeType? fromObj(Object? obj) =>
      fromString(obj.runtimeType.toString());

  static _NodeType? fromString(String str) =>
      _NodeType.values.firstWhere((e) => e.match == str);

  String get match => switch (this) {
        _NodeType.string => "String",
        _NodeType.map => "_Map<String, dynamic>",
        _NodeType.empty => "Null",
      };
}

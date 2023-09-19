typedef Yaml = Map<String,dynamic>;

class LocaleGenerator {
  final bool superClass;
  Set<String> classes = {}; // addittionally created classes for nested keys
  Set<String> keys = {}; // every keyPath except ones w/ null value
  Set<String> nullKeys = {}; // keyPaths for keys w/ null values
  final Yaml yaml; // parsed YAML asset
  final String localeCode;
  late final String localeCodeCap; // language and country code
  String generatedClass = "";

  LocaleGenerator(this.yaml,
      {this.superClass = false, required this.localeCode}) {
    localeCodeCap = _capitalize(localeCode).replaceAll('-', '');
    _genLocale(yaml);
  }

  String _capitalize(String val) => (val.length > 1)
      ? val[0].toUpperCase() + val.substring(1)
      : val.toUpperCase();

  /// generate a new class from a [Map<String, dynamic>]
  void genClass(List<String> path, Yaml map) {
    final String superClassName = "${_capitalize(path.last)}Inu";
    final String className =
        "${!superClass ? '_' : ''}${_capitalize(path.last)}${!superClass ? localeCodeCap : 'Inu'}";
    String newClass =
        "class $className ${!superClass ? 'extends $superClassName ' : ''}{\n  const $className();\n";

    map.keys
        .map(
            (key) => newClass += _genAttribute(key, map, path: List.from(path)))
        .toList();
    newClass += "}\n\n";
    classes.add(newClass);
  }

  /// generate the attributes of a class based on the type of the YAML key
  String _genAttribute(String key, Yaml map,
      {List<String>? path}) {
    path ??= [];
    dynamic value = map[key];
    dynamic type = value.runtimeType.toString();

    String genNullLine() => path!.isEmpty
        ? "  String get $key => ${_capitalize(localeCodeCap)}().$key;\n"
        : "  String get $key => const ${_capitalize(path[path.length - 2])}Inu().$key;\n";

    switch (type) {
      case 'String':
        value = value.trim();
        path.add(key);
        if (value.isEmpty) return genNullLine();

        keys.add(path.join('.'));
        return "  String get $key => \"$value\";\n";
      case '_Map<String, dynamic>':
        path.add(key);
        genClass(List.from(path), value);
        final String className =
            "${!superClass ? '_' : ''}${_capitalize(key)}${!superClass ? localeCodeCap : 'Inu'}";
        return "  $className get $key => const $className();\n";

      case 'Null':
        path.add(key);
        nullKeys.add(path.join('.'));
        return genNullLine();
      default:
        return "";
    }
  }

  /// generate a Locale class from a YAML file
  void _genLocale(Yaml yaml) {
    final String inuHeader =
        "/// $localeCode\n/// *****************************************************\n/// GENERATED CODE - DO NOT MODIFY BY HAND\n/// run 'just inu' or 'dart run inu:gen_classes' in the root directory of your project\n/// *****************************************************\n\nabstract class Inu {\n";
    final String localeHeader =
        "// ignore_for_file: annotate_overrides\nimport 'inu.g.dart';\n\n/// *****************************************************\n/// GENERATED CODE - DO NOT MODIFY BY HAND\n/// run 'just inu' or 'dart run inu:gen_classes' in the root directory of your project\n/// *****************************************************\n\nclass $localeCodeCap implements Inu {\n";

    generatedClass += superClass ? inuHeader : localeHeader;

    yaml.keys.map((topic) {
      return generatedClass += _genAttribute(topic, yaml);
    }).toList();

    generatedClass += "}\n\n";

    classes.map((val) => generatedClass += val).toList();
  }
}

import 'extensions.dart';
import 'fs_utils.dart';

typedef KeyPath = Iterable<String>;

class StringGenerator {
  final String _localeCode;
  String get _localeCodeCap => _localeCode.capitalize().replaceAll('-', '');

  StringGenerator(this._localeCode);

  String get header => """// ignore_for_file: annotate_overrides

/// *****************************************************
/// GENERATED CODE - DO NOT MODIFY BY HAND
/// run 'just inu' or 'dart run inu:gen_classes' in the root directory of your project
/// *****************************************************

// ignore_for_file: non_constant_identifier_names, constant_identifier_names

part of 'inu.g.dart';

class $_localeCodeCap implements Inu {
""";

  String blockEnd = "}\n\n";

  String stringEntry(String key, String value) =>
      """  String get $key => "$value";\n""";

  String classEntry(KeyPath path) {
    final cn = path.className(_localeCodeCap);
    return "  $cn get ${path.last} => const $cn();\n";
  }

  String emptyKey(KeyPath path, String key) {
    return path.isEmpty
        ? "  String get $key => $_localeCodeCap().$key;\n"
        : "  String get $key => const ${(path.take(path.length - 1)).superClassName()}().$key;\n";
  }

  String _classStructureHeading(KeyPath path) {
    final String superClassName = path.superClassName();
    final String className = path.className(_localeCodeCap);
    return "class $className extends $superClassName {\n  const $className();\n";
  }

  String classStructure(KeyPath path, String content) {
    return [_classStructureHeading(path), content, blockEnd].join();
  }
}

class SuperStringGenerator extends StringGenerator {
  SuperStringGenerator(super._localeCodeCap);

  Iterable<String> get _l =>
      FS.localesAvailable.map((e) => e.replaceAll("-", "_"));

  @override
  String get header => """/// $_localeCode
/// *****************************************************
/// GENERATED CODE - DO NOT MODIFY BY HAND
/// run 'just inu' or 'dart run inu:gen_classes' in the root directory of your project
/// *****************************************************

// ignore_for_file: non_constant_identifier_names, constant_identifier_names

${FS.localesAvailable.map((e) => "part '$e.g.dart';").join("\n")}

enum InuLocale {
  ${_l.join(",\n  ")};

  /// accepts a lang code in the format "en_US"
  static Inu? select(String langCode) =>
        InuLocale.values
          .where((e) => e.name == langCode)
          .firstOrNull?.inu;

  Inu get inu => switch (this) {
      ${_l.map((e) => "InuLocale.$e => ${e.replaceAll("_", "").capitalize()}()").join(",\n      ")},
    };
}

abstract class Inu {
""";

  @override
  String classEntry(KeyPath path) {
    final className = path.superClassName();
    return "  $className get ${path.last} => const $className();\n";
  }

  @override
  String _classStructureHeading(KeyPath path) {
    final String className = path.superClassName();
    return "class $className {\n  const $className();\n";
  }

  @override
  String emptyKey(KeyPath path, String key) {
    return path.isEmpty
        ? "  String get $key => $_localeCodeCap().$key;\n"
        : """  String get $key => "";\n""";
  }
}

extension _ToPathName on KeyPath {
  String className(String locale) =>
      "_${map((e) => e.capitalize()).join()}$locale";

  String superClassName() => "_${map((e) => e.capitalize()).join()}Inu";
}

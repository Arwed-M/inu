import 'extensions.dart';

class StringGenerator {
  final String _localeCode;
  String get _localeCodeCap => _localeCode.capitalize().replaceAll('-', '');

  StringGenerator(this._localeCode);

  String get header =>
      """// ignore_for_file: annotate_overrides
import 'inu.g.dart';

/// *****************************************************
/// GENERATED CODE - DO NOT MODIFY BY HAND
/// run 'just inu' or 'dart run inu:gen_classes' in the root directory of your project
/// *****************************************************

// ignore_for_file: non_constant_identifier_names

class $_localeCodeCap implements Inu {
""";

  String blockEnd = "}\n\n";

  String stringEntry(String key, String value) =>
      """  String get $key => "$value";\n""";

  String classEntry(Iterable<String> path) {
    final cn = path.className(_localeCodeCap);
    return "  $cn get ${path.last} => const $cn;\n";
  }

  String emptyKey(Iterable<String> path, String key) {
    return path.isEmpty
        ? "  String get $key => $_localeCodeCap().$key;\n"
        : "  String get $key => const ${((path.take(path.length - 1)).className(_localeCodeCap))}Inu().$key;\n";
  }

  String _classStructureHeading(List<String> path) {
    final String superClassName = path.superClassName();
    final String className = path.className(_localeCodeCap);
    return "class $className extends $superClassName {\n  const $className();\n";
  }

  String classStructure(List<String> path, String content) {
    return [_classStructureHeading(path), content, blockEnd].join();
  }
}

class SuperStringGenerator extends StringGenerator {
  SuperStringGenerator(super._localeCodeCap);

  @override
  String get header => """/// $_localeCode
/// *****************************************************
/// GENERATED CODE - DO NOT MODIFY BY HAND
/// run 'just inu' or 'dart run inu:gen_classes' in the root directory of your project
/// *****************************************************

// ignore_for_file: non_constant_identifier_names

abstract class Inu {
""";

  @override
  String classEntry(Iterable<String> path) {
    final className = path.superClassName();
    return "  $className get ${path.last} => const $className();\n";
  }

  @override
  String _classStructureHeading(List<String> path) {
    final String className = path.superClassName();
    return "class $className {\n  const $className();\n";
  }

  @override
  String emptyKey(Iterable<String> path, String key) {
    return path.isEmpty
        ? "  String get $key => $_localeCodeCap().$key;\n"
        : """  String get $key => "";\n""";
  }
}

extension _ToPathName on Iterable<String> {
  String className(String locale) =>
      "_${map((e) => e.capitalize()).join()}$locale";

  String superClassName() => "_${map((e) => e.capitalize()).join()}Inu";
}

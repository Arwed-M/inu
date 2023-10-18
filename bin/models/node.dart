import '../fs_utils.dart';
import 'node_type.dart';
import 'path.dart';

typedef Yaml = Map<String, dynamic>;

abstract class LocaleNode {
  final YamlPath path;
  final String locale;

  LocaleNode({required this.path, this.locale = "inu"});

  String render();

  static LocaleNode? scuffedConstructor(
          YamlPath path, Object? obj, String locale) =>
      switch (NodeType.fromObj(obj)) {
        NodeType.string =>
          StringNode(path: path, content: obj as String, locale: locale),
        NodeType.map =>
          LocaleClass(path: path, yaml: obj as Yaml, locale: locale),
        NodeType.empty => EmptyNode(path: path, locale: locale),
        _ => null,
      };

  @override
  String toString() => render();
}

class LocaleClass extends LocaleNode {
  final Iterable<LocaleNode> children;

  LocaleClass(
      {super.path = const YamlPath(),
      required Yaml yaml,
      required super.locale})
      : children = yaml.entries
            .map((entry) => LocaleNode.scuffedConstructor(
                path.add(entry.key), entry.value, locale))
            .whereType<LocaleNode>();

  Set<String> get keys {
    final s = <String>{};
    for (var child in children) {
      if (child is LocaleClass) {
        s.addAll(child.keys);
      } else {
        s.add(child.path.join());
      }
    }
    return s;
  }

  @override
  String render() {
    final cn = path.className(locale);
    return "  $cn get ${path.key} => const $cn();";
  }

  String get className => path.className(locale);

  String get inherit =>
      locale != "inu" ? "extends ${path.superClassName()}" : "";

  String renderDartFile() => """// ignore_for_file: annotate_overrides
/// *****************************************************
/// GENERATED CODE - DO NOT MODIFY BY HAND
/// run 'just inu' or 'dart run inu:gen_classes' in the root directory of your project
/// *****************************************************

// ignore_for_file: non_constant_identifier_names, constant_identifier_names

part of 'inu.g.dart';

class $className implements Inu {
${renderBody().split("\n").skip(1).join("\n")}
""";

  String renderBody() {
    return """class $className $inherit {
  const $className();
${children.map((e) {
      return e.render();
    }).join("\n ")}
}

${children.whereType<LocaleClass>().map((e) => e.renderBody()).join("\n")}
""";
  }
}

class SuperClass extends LocaleClass {
  SuperClass({required super.yaml, required this.locale})
      : super(path: const YamlPath(), locale: "inu");

  @override
  String locale;

  @override
  String get className => "Inu";

  @override
  String inherit = "";

  Iterable<String> get _l =>
      FS.localesAvailable.map((e) => e.replaceAll("-", "_"));

  @override
  String renderDartFile() {
    return """/// $locale
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
      ${_l.map((e) => "InuLocale.$e => const _${e.replaceAll("_", "").capitalize()}()").join(",\n      ")},
    };
}

abstract ${renderBody()}
""";
  }
}

class StringNode extends LocaleNode {
  final String content;

  StringNode(
      {required super.path, required this.content, required super.locale});

  @override
  String render() => """  String get ${path.key} => "$content";""";
}

class EmptyNode extends LocaleNode {
  EmptyNode({required super.path, required super.locale});

  @override
  String render() {
    return path.isEmpty
        ? "  String get ${path.key} => ${locale.localeCap()}().${path.key};"
        : """  String get ${path.key} => "";""";
  }
}

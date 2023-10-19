import 'dart:io';
import 'package:yaml_mapper/yaml_mapper.dart';
import 'package:path/path.dart' as pathlib;
import 'models/node.dart';

class _Locations {
  static const String yamlFileSuffix = ".yaml";
  static const String translationDirPath = "assets/translations";

  static Directory get classesDir => Directory("lib/inu_classes");
  static Directory get translationDir => Directory(translationDirPath);
  static String get superClassFilePath => _classFilePath("inu");
  static File get superClassFile => File(superClassFilePath);

  static File classFile(String className) => File(_classFilePath(className));
  static File localeYamlFile(String localeCode) =>
      File('$translationDirPath/$localeCode$yamlFileSuffix');

  static String _classFilePath(String locale) =>
      "lib/inu_classes/$locale.g.dart";
}

class FS {
  static Iterable<FileSystemEntity> get getYamlFiles =>
      _Locations.translationDir
          .listSync(followLinks: false)
          .where((e) => e.isYaml);

  static List<String> get localeFileNames =>
      getYamlFiles.map((e) => e.basename).toList();

  static Iterable<String> get localesAvailable =>
      localeFileNames.map((e) => e.replaceAll(_Locations.yamlFileSuffix, ""));

  static void writeLocaleFile(String locale, String content) =>
      _Locations.classFile(locale).writeAsStringSync(content);

  static Yaml readLocaleFile(String locale) {
    final lines = _Locations.localeYamlFile(locale).readAsLinesSync();
    return parseMap(lines, determineWhitespace(lines));
  }

  static bool get inuIsConfigured => !(!_Locations.classesDir.existsSync() ||
      !File(_Locations.superClassFilePath).existsSync());

  static bool get translationDirExists =>
      _Locations.translationDir.existsSync();

  static void genClassesDir() {
    _Locations.classesDir.create();
  }

  static void genTranslationDir() {
    _Locations.translationDir.create(recursive: true);
  }

  static String get superClassLocaleCode => _Locations.superClassFile
      .readAsLinesSync()
      .first
      .replaceFirst('/// ', '');

  static void updateYamlFile(String localeCode, Yaml yaml) =>
      writeYAML(yaml, _Locations.localeYamlFile(localeCode).path);

  static void addJustfileEntry() => Directory('.')
          .list(followLinks: false)
          .where((file) => file.basename == 'justfile')
          .map((e) => File(e.path))
          .forEach((file) {
        List<String> lines = file.readAsLinesSync();
        String content = '';

        for (var line in lines) {
          if (line.contains('inu:')) return;
          content += '$line\n';
        }

        content += '\ninu:\n  dart run inu:gen_classes';
        file.writeAsStringSync(content);
      });
}

extension FileSystemExtensions on FileSystemEntity {
  bool get isYaml => basename.endsWith(_Locations.yamlFileSuffix);
  String get basename => pathlib.basename(path);

  String get basenameNoSuffix =>
      basename.replaceAll(_Locations.yamlFileSuffix, '');
}

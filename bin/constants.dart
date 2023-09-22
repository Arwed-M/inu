import 'dart:io';

class Locations {
  static String _classFileTemplate(String locale) =>
      "lib/inu_classes/$locale.g.dart";

  static String get generatedFilePath => _classFileTemplate("inu");
  static File classFile(String className) =>
      File(_classFileTemplate(className));

  static File get generatedFile => File(generatedFilePath);

  static File localeYamlFile(String localeCode) =>
      File('$translationDirPath/$localeCode$yamlFileSuffix');

  static Directory get classesDir => Directory("lib/inu_classes");

  static const String translationDirPath = "assets/translations";

  static Directory get translationDir => Directory(translationDirPath);

  static const yamlFileSuffix = ".yaml";
}

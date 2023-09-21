// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import 'constants.dart';
import 'extensions.dart';
import 'gen_classes.dart';
import 'gen_locale.dart';
import 'locale_generator.dart';

void addJustFileEntry(File file) {
  List<String> lines = file.readAsLinesSync();
  String content = '';

  for (var line in lines) {
    if (line.contains('inu:')) return;
    content += '$line\n';
  }

  content += '\ninu:\n  dart run inu:gen_classes';
  file.writeAsStringSync(content);
}

void _editJustFile() => Directory('.').list(followLinks: false).map((file) {
      if (basename(file.path) == 'justfile') addJustFileEntry(File(file.path));
    }).toList();

void _genClasses() {
  if (!Locations.translationDir.existsSync()) {
    Locations.translationDir.create(recursive: true);

    print(
        "No locale files found yet. Please provide your Locale files in the directory 'assets/translations/'");
    return;
  }

  List<String> fileNames = _getLocalFileNames();

  if (fileNames.isEmpty) {
    print("\nNo Locale files found in 'assets/translations/'.\n");
    return;
  }

  int defaultLocaleNum = 0;

  if (fileNames.length > 1) {
    print("\nFound the following Locale files:\n");

    final Map<int, String> filesMap = fileNames.asMap();
    filesMap.forEach((index, file) => print("($index) $file"));

    print("\nSelect a default Locale containing all Strings:");

    String? answerStr = stdin.readLineSync(encoding: utf8);

    if (answerStr == null) return;

    defaultLocaleNum = int.parse(answerStr);

    if (!filesMap.containsKey(defaultLocaleNum)) {
      print("Input not in range.");
      return;
    }
  }

  print("selected locale: ${fileNames[defaultLocaleNum]}");

  Locations.classesDir.create();

  // generate Inu superclass
  final LocaleGenerator inu = genLocale(
      superClass: true,
      localeCode: fileNames[defaultLocaleNum]
          .replaceFirst(Locations.yamlFileSuffix, ''));

  // build locale class for every localization file that extends Inu
  regenClasses(superClass: inu);
}

List<String> _getLocalFileNames() => Locations.translationDir
    .listSync(followLinks: false)
    .where((e) => e.isYaml)
    .map((e) => e.basename)
    .toList();

void initInu() {
  _genClasses();
  _editJustFile();
}

void main() {
  initInu();
}

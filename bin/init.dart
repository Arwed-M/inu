// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io' show stdin;
import 'fs_utils.dart';
import 'gen_classes.dart';
import 'models/node.dart';

void _genClasses() {
  if (!FS.translationDirExists) {
    FS.genTranslationDir();

    print(
        "No locale files found yet. Please provide your Locale files in the directory 'assets/translations/'");
    return;
  }

  List<String> fileNames = FS.localesAvailable.toList();

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

  FS.genClassesDir();

  // generate Inu superclass
  final locale = fileNames[defaultLocaleNum];
  final inu = SuperClass(
      yaml: FS.readLocaleFile(locale), locale: fileNames[defaultLocaleNum]);

  // build locale class for every localization file that extends Inu
  regenClasses(superClass: inu);
}

void initInu() {
  _genClasses();
  FS.addJustfileEntry();
}

void main() {
  initInu();
}

import 'dart:convert';
import 'dart:io';

import 'package:neko/src/gen_locale.dart';
import 'package:neko/src/locale_generator.dart';
import 'package:path/path.dart';

import 'gen_classes.dart';

void addJustFileEntry(File file) {
  List<String> lines = file.readAsLinesSync();
  String content = '';

  for (var line in lines) {
    if (line.contains('neko:')) return;
    content += '$line\n';
  }

  content += '\nneko:\n  dart run neko:gen_classes';
  file.writeAsStringSync(content);
}

void _editJustFile() => Directory('.').list(followLinks: false).map((file) {
      if (basename(file.path) == 'justfile') addJustFileEntry(File(file.path));
    }).toList();

void _genClasses() {
  if (!Directory('assets/translations').existsSync()) {
    Directory('assets/translations').create();
    print(
        "Please provide your Locale files in the directory 'assets/translations/'");
    return;
  }

  List<String> fileNames = _getLocalFileNames();

  if (fileNames.isEmpty) {
    print("\nNo Locale files found in 'assets/translations/'.\n");
    return;
  }

  print("\nFound the following Locale files:\n");

  final Map<int, String> filesMap = fileNames.asMap();
  filesMap.forEach((index, file) => print("($index) $file"));

  print("\nSelect a default Locale containing all Strings:");

  String? answerStr = stdin.readLineSync(encoding: utf8);

  if (answerStr == null) return;

  int answer = int.parse(answerStr);

  if (!filesMap.containsKey(answer)) {
    print("Input not in range.");
    return;
  }

  Directory('lib/neko_classes').create();

  // generate Neko superclass
  final LocaleGenerator neko = genLocale(
      superClass: true,
      localeCode: fileNames[answer].replaceFirst('.yaml', ''));

  // build locale class for every localization file that extends Neko
  regenClasses(superClass: neko);
}

List<String> _getLocalFileNames() {
  List<String> files = [];
  for (var file in Directory('assets/translations')
      .listSync(followLinks: false)
      .toList()) {
    if (basename(file.path).contains('.yaml')) {
      files.add(basename(file.path));
    }
  }
  return files;
}

void initNeko() {
  _genClasses();
  _editJustFile();
}

void main() {
  initNeko();
}
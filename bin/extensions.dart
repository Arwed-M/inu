import 'dart:io';

import 'package:path/path.dart' as pathlib;

import 'constants.dart';

extension FileSystemExtensions on FileSystemEntity {
  bool get isYaml => basename.endsWith(Locations.yamlFileSuffix);
  String get basename => pathlib.basename(path);
}

extension InuStrExtensions on String {
  String capitalize() =>
      (length > 1) ? this[0].toUpperCase() + substring(1) : toUpperCase();
}

import 'package:flutter/widgets.dart';

extension StringInputExtension on String {
  /// Replaces all '{}' with the [List<String> args] from first to last
  String tr(
      {List<String> args = const [],
      Map<String, String> namedArgs = const {}}) {
    String text = this;

    for (var arg in args) {
      text = text.replaceFirst('{}', arg);
    }

    for (var arg in namedArgs.keys) {
      text = text.replaceFirst('{$arg}', namedArgs[arg]!);
    }

    return text;
  }
}

extension TextInputExtension on Text {
  /// Replaces all '{}' with the [List<String> args] from first to last
  Text tr(
          {List<String> args = const [],
          Map<String, String> namedArgs = const {}}) =>
      Text(data?.tr(args: args, namedArgs: namedArgs) ?? '',
          key: key,
          style: style,
          strutStyle: strutStyle,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          textScaleFactor: textScaleFactor,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
          textWidthBasis: textWidthBasis);
}

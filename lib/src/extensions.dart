import 'package:flutter/widgets.dart';

/// provide named/unnamed arguments to a [String] or a [Text]

extension StringInputExtension on String {
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

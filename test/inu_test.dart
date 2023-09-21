import 'package:flutter_test/flutter_test.dart';
import 'package:inu/src/extensions.dart';

import 'package:yaml_mapper/yaml_mapper.dart';

import '../bin/completeness_check.dart';
import '../bin/locale_generator.dart';

void main() {
  const String yamlStrEN = """
title: app
section1:
  undersection1:
    key1 : Value
    key2: "great value"
  anotherKey : another value

section2:
  supriseKey: ""Boo!""

end: this is the end
""";

  const String yamlStrDE = """
title: App
section1:
  undersection1:
    key1 : Wert
    key2: "toller Wert"

section2:
  supriseKey: ""Buuh!""

end: das ist das Ende
""";

  group("inu tests", () {
    final List<String> yamlLinesEN = yamlStrEN.split('\n');
    final Map<String, dynamic> mapEN =
        parseMap(yamlLinesEN, determineWhitespace(yamlLinesEN));

    test('Parsing test', () {
      expect(mapEN['title'], 'app');
      expect(mapEN['section1']['undersection1']['key1'], 'Value');
      expect(mapEN['section1']['undersection1']['key2'], 'great value');
      expect(mapEN['section1']['anotherKey'], 'another value');
      expect(mapEN['section2']['supriseKey'], '"Boo!"');
    });

    group('Class generation', () {
      final inu = LocaleGenerator(mapEN, localeCode: 'en-US', superClass: true);

      final Map<String, dynamic> mapDE = parseMap(yamlStrDE.split('\n'), '  ');
      final localeDE = LocaleGenerator(mapDE, localeCode: 'de-DE');

      test('Superclass', () {
        expect(inu.keys, [
          'title',
          'section1.undersection1.key1',
          'section1.undersection1.key2',
          'section1.anotherKey',
          'section2.supriseKey',
          'end'
        ]);
      });

      test('Uncomplete locale class', () {
        expect(
            findMissingKeys(inu, localeDE).toList(), ['section1.anotherKey']);
      });
    });

    test('String insertion tests', () {
      const String str1 = "I like {}, because it's so {}.";
      const String str2 =
          "My favourite color is {color}, beacause I am {views}.";

      expect(str1.tr(args: ['Dart', 'simple']),
          "I like Dart, because it's so simple.");
      expect(str2.tr(namedArgs: {'color': 'blue', 'views': 'based'}),
          "My favourite color is blue, beacause I am based.");
    });
  });
}

<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Inu 🐕

## Features

**Inu** is a simple localization tool for Flutter applications. It's based on a class generation from structured YAML files containing all Strings for the application. 

A locale class is generated from every locale file.  
Once generated, you can access the Strings from a **Inu** class instance.

## Getting started

All localization files should have the same [YAML-Map structure](#structure-of-locale-files). The value of each key should contain the translated String for each language.

- place all your localization files in a directory ```assets/translations/```
- add **Inu** to your dependencies in your Flutter app with ```flutter pub add inu```
- run ```dart run inu:init``` to generate the locale classes for the first time

## Usage

**Inu** creates an abstract class called **Inu**, which every other locale class implements. This class is generated from the main language used during development (most likely English). 

If you dont provide any translations, the Strings from the **Inu** class are used as a "fallback locale".

If you have added more Strings to your locale files you can run 
```sh
dart run inu:gen_classes
``` 
or 
```sh
just inu
``` 
if you use [just](https://github.com/casey/just).  

**Inu** checks the locale files for completeness during the generation process. Once it discovers Strings that aren't translated, you can translate them right away in the terminal prompt or skip the process.

Once the classes have been generated, you can move on by using an instance of **Inu** as a Container for all your Strings.  

You can write a method like this and store the returned value as a global variable or within a state management system like [get_it](https://pub.dev/packages/get_it):

```dart
Inu chooseLocale() {
  final String langCode =
      Locale(Platform.localeName).languageCode.replaceAll('_', '-');

  switch (langCode) {
    case 'de-DE':
      return DeDE();
    default:
      return EnUS();
  }
}
```

You can also use arguments in form of a ```List<String>``` or named arguments with a ```Map<String, String>``` with the ```String``` and ```Text()``` extention ```tr()```.  
Simply add curly braces to your String value in your locale files like this:

```yaml
arguments: this String contains {} and {}
namedArguments: Hello, my name is {firstname} {surname}
```

Then use the ```tr()``` extention like this:

```dart
Text(inu.arguments).tr(['letters', 'numbers']);
String greeting = inu.namedArguments.tr(namedArgs: { 
    'firstname' : 'Ryan',
    'surname' : 'Stecken'});
```

Checkout the [Example](https://pub.dev/packages/inu/example) for a translated version of the Flutter demo app!

## Structure of locale files

You should structure your files in form of a simple map (no lists or plain text). The map structure has to be the same for all files.

### Example

#### English locale file

```yaml
title: app
section1:
  undersection1:
    key1 : Value
    key2: "great value"
  anotherKey : another value

section2:
  supriseKey: ""Boo!""
  arguments: this String contains {} and {}
  namedArguments: Hello, my name is {firstname} {surname}

end: this is the end
```

#### German locale file

```yaml
title: App
section1:
  undersection1:
    key1 : Wert
    key2: "toller Wert"
  anotherKey : weiterer Wert

section2:
  supriseKey: ""Buuh!""
  arguments: dieser String beinhaltet {} und {}
  namedArguments: Hallo, mein Name ist {firstname} {surname}

end: das ist das Ende
```
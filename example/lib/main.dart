import 'dart:io';

import 'package:flutter/material.dart';

import 'inu_classes/de-DE.g.dart';
import 'inu_classes/en-US.g.dart';
import 'inu_classes/inu.g.dart';

late final Inu inu;

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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    inu = chooseLocale();
    return MaterialApp(
      title: inu.general.appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: inu.general.appBar),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              inu.mainPage.buttonCounterMsg,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: inu.mainPage.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}

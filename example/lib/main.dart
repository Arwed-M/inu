import 'dart:io';

import 'package:flutter/material.dart';

import 'neko_classes/de-DE.g.dart';
import 'neko_classes/en-US.g.dart';
import 'neko_classes/neko.g.dart';

late final Neko neko;

Neko chooseLocale() {
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
    neko = chooseLocale();
    return MaterialApp(
      title: neko.general.appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: neko.general.appBar),
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
              neko.mainPage.buttonCounterMsg,
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
        tooltip: neko.mainPage.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}

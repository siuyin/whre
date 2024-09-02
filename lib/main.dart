import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

final d2 = NumberFormat('00');

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wher',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Where did I park?'),
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
  String location = "";
  DateTime startTime = DateTime.now();
  String duration() {
    final dur = DateTime.now().difference(startTime);
    final hh = d2.format(dur.inHours);
    final mm = d2.format(dur.inMinutes.remainder(60));
    final ss = d2.format(dur.inSeconds.remainder(60));
    return '$hh:$mm:$ss';
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) => setState(() {}));
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
            SizedBox(
              width: 256,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Location',
                ),
                style: Theme.of(context).textTheme.displaySmall,
                onSubmitted: (value) {
                  setState(() {
                    location = value;
                    startTime = DateTime.now();
                  });
                },
              ),
            ),
            Text(
              'Entered: ${DateFormat.jms().format(startTime)}\n${duration()} ago.',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

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
  DateTime startTime = DateTime.now();
  String duration() {
    final dur = DateTime.now().difference(startTime);
    final hh = d2.format(dur.inHours);
    final mm = d2.format(dur.inMinutes.remainder(60));
    final ss = d2.format(dur.inSeconds.remainder(60));
    return '$hh:$mm:$ss';
  }

  Location geoLoc = Location();
  final TextEditingController _locController = TextEditingController();

  getLoc() async {
    final loc = await geoLoc.getLocation();
    _locController.text = '${loc.latitude},${loc.longitude}';
    startTime = DateTime.now();
  }

  checkLocationService() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await geoLoc.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await geoLoc.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await geoLoc.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await geoLoc.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    await geoLoc.getLocation();
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) => setState(() {}));
    checkLocationService();
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
            parkedLoc(context),
            timingInfo(context),
          ],
        ),
      ),
    );
  }

  Text timingInfo(BuildContext context) {
    return Text(
      'Entered: ${DateFormat.jms().format(startTime)}\n${duration()} ago.',
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  SizedBox parkedLoc(BuildContext context) {
    return SizedBox(
      width: 360,
      child: Row(
        children: [
          locationTextField(context),
          getLocationIconButton(),
        ],
      ),
    );
  }

  Flexible getLocationIconButton() {
    return Flexible(
      flex: 1,
      child: IconButton(
        onPressed: () {
          getLoc();
        },
        icon: const Icon(Icons.location_on),
        tooltip: 'capture latitude & longitude to paste into Google Maps',
      ),
    );
  }

  Flexible locationTextField(BuildContext context) {
    return Flexible(
      flex: 9,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: const InputDecoration(
            labelText: 'Location',
          ),
          style: Theme.of(context).textTheme.headlineSmall,
          onSubmitted: (_) {
            setState(() {
              startTime = DateTime.now();
            });
          },
          controller: _locController,
        ),
      ),
    );
  }
}

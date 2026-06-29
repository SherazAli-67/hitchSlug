import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hitch: Find Players & Court',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Color(0xff90B953)),
      ),
      home: Scaffold(
        body: SafeArea(child: Center(child: Text("Pickleball, Padel & Tennis Partners Near You"))),
      )
    );
  }
}
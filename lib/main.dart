import 'package:flutter/material.dart';
import 'package:bedava_audio_recorder/screens/tabbed_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: SafeArea(
        child: TabbedScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:zoom/ui/main.dart';
import 'package:zoom/utils/scroll_behavior.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: NoGlowBehavior(),
          child: child,
        );
      },
      title: 'Zoom Delivery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}
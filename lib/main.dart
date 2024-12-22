import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/example1/simple_widget.dart';
import 'package:flutter_application_1/widgets/example3/example3.dart';
import 'package:flutter_application_1/widgets/example5_animations/sample_animation.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ComplexAnimationScreen());
  }
}

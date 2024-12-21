import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/simple_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: MyWidget(
          title: "This is Samin ",
          message: "And this is the description",
        ),
      ),
    );
  }
}

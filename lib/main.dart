import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/example1/simple_widget.dart';
import 'package:flutter_application_1/widgets/example3/example3.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            const MyWidget(
              title: "This is Samin ",
              message: "And this is the description",
            ),
            AdvancedSearchBar(
              onSearch: (_) async => [],
              onItemSelected: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}

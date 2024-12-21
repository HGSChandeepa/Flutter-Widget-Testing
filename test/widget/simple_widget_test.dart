import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/simple_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      //Here we also need to warap  Material/Widget app wrapper that provides the necessary Directionality context for the Text widget to work.
      const MaterialApp(
        home: MyWidget(title: 'Hello', message: 'World'),
      ),
    );

    // Create Finders
    final titleFinder = find.text('Hello');
    final messageFinder = find.text('World');

    // Verify that our widget displays the correct title and message
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
  });
}

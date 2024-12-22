import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/example5_animations/sample_animation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ComplexAnimationScreen test', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ComplexAnimationScreen(),
      ),
    );

    // INITIAL STATE
    final containerFinder = find.byType(Container);
    expect(containerFinder, findsOneWidget);

    var container = tester.widget<Container>(containerFinder);

    // Verify initial state
    expect(container.constraints!.minWidth, 50);
    expect(container.constraints!.minHeight, 50);
    expect((container.decoration as BoxDecoration).color, Colors.blue);
    expect(
      (container.decoration as BoxDecoration).borderRadius,
      BorderRadius.zero,
    );

    // MIDWAY ANIMATION (1.5 seconds)
    await tester.pump(const Duration(milliseconds: 1500));

    container = tester.widget<Container>(containerFinder);
    final animatedColor = (container.decoration as BoxDecoration).color;

    // Verify midway values
    expect(container.constraints!.minWidth, closeTo(125, 10));
    expect(container.constraints!.minHeight, closeTo(125, 10));
    expect(animatedColor, isNot(Colors.blue));
    expect(animatedColor, isNot(Colors.green));
    expect(
      (container.decoration as BoxDecoration).borderRadius,
      BorderRadius.circular(25),
    );

    // FINAL STATE (3 seconds)
    await tester.pumpAndSettle();

    container = tester.widget<Container>(containerFinder);

    // Verify final state
    expect(container.constraints!.minWidth, 200);
    expect(container.constraints!.minHeight, 200);
    expect((container.decoration as BoxDecoration).color, Colors.green);
    expect(
      (container.decoration as BoxDecoration).borderRadius,
      BorderRadius.circular(50),
    );
  });
}

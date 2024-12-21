// search_bar_test.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/example3/example3.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdvancedSearchBar Widget Tests', () {
    // Helper function to build widget in test environment
    Widget createWidget({
      Future<List<String>> Function(String)? onSearch,
      void Function(String)? onItemSelected,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: AdvancedSearchBar(
            onSearch: onSearch ?? (_) async => [],
            onItemSelected: onItemSelected ?? (_) {},
          ),
        ),
      );
    }

    testWidgets('renders initial state correctly', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('shows loading indicator while searching', (tester) async {
      // Create a Completer to control when the search completes
      final completer = Completer<List<String>>();

      await tester.pumpWidget(
        createWidget(
          onSearch: (_) => completer.future,
        ),
      );

      // Enter text to trigger search
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      // Wait for debounce
      await tester.pump(const Duration(milliseconds: 300));

      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete the search
      completer.complete(['Result 1', 'Result 2']);
      await tester.pumpAndSettle();

      // Verify loading indicator is gone
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows and animates suggestions', (tester) async {
      const results = ['Apple', 'Banana', 'Cherry'];

      await tester.pumpWidget(
        createWidget(
          onSearch: (_) async => results,
        ),
      );

      // Enter text to trigger search
      await tester.enterText(find.byType(TextField), 'fruit');
      await tester.pump();

      // Wait for debounce and async operation
      await tester.pump(const Duration(milliseconds: 300));

      // Verify animation started
      await tester.pump();
      final ScaleTransition scale = tester.widget(find.byType(ScaleTransition));
      expect(scale.scale.value, 0.0);

      // Verify animation completed
      await tester.pumpAndSettle();
      final ScaleTransition scaleAfter =
          tester.widget(find.byType(ScaleTransition));
      expect(scaleAfter.scale.value, 1.0);

      // Verify suggestions are shown
      for (final result in results) {
        expect(find.text(result), findsOneWidget);
      }
    });

    testWidgets('handles item selection correctly', (tester) async {
      String? selectedItem;

      await tester.pumpWidget(
        createWidget(
          onSearch: (_) async => ['Apple', 'Banana'],
          onItemSelected: (item) => selectedItem = item,
        ),
      );

      // Trigger search
      await tester.enterText(find.byType(TextField), 'a');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Tap on first suggestion
      await tester.tap(find.text('Apple'));
      await tester.pumpAndSettle();

      // Verify selection
      expect(selectedItem, 'Apple');
      expect(find.byType(ListView), findsNothing);
      expect(find.byType(TextField), findsOneWidget);

      // Verify text field is cleared
      final TextField textField = tester.widget(find.byType(TextField));
      expect(textField.controller?.text, '');
    });

    testWidgets('shows error state correctly', (tester) async {
      await tester.pumpWidget(
        createWidget(
          onSearch: (_) async => throw Exception('Search failed'),
        ),
      );

      // Trigger search
      await tester.enterText(find.byType(TextField), 'error');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Verify error state
      expect(find.text('Error fetching results'), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('clear button works correctly', (tester) async {
      await tester.pumpWidget(
        createWidget(
          onSearch: (_) async => ['Result'],
        ),
      );

      // Enter text
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      // Verify clear button appears
      expect(find.byIcon(Icons.clear), findsOneWidget);

      // Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // Verify text is cleared and suggestions are hidden
      final TextField textField = tester.widget(find.byType(TextField));
      expect(textField.controller?.text, '');
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('debounces search correctly', (tester) async {
      int searchCount = 0;

      await tester.pumpWidget(
        createWidget(
          onSearch: (query) async {
            searchCount++;
            return ['Result'];
          },
        ),
      );

      // Rapidly enter text
      await tester.enterText(find.byType(TextField), 'a');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(find.byType(TextField), 'ab');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(find.byType(TextField), 'abc');

      // Wait for debounce
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Verify only one search was performed
      expect(searchCount, 1);
    });
  });
}

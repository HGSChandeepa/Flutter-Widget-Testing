import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/example4_apis/home_screen.dart';
import 'package:flutter_application_1/widgets/example4_apis/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeScreen Widget Test -', () {
    final users = [
      User(id: 1, name: 'Samin', email: 'saminchandeepa@gmail.com'),
      User(id: 2, name: 'Adomic Arts', email: 'adomicarts@gmail.com'),
      User(id: 3, name: 'Adomic Labs', email: 'adomiclabs@gmail.com'),
    ];

    Future<List<User>> mockFetchUsers() {
      return Future.delayed(const Duration(seconds: 1), () => users);
    }

    Future<List<User>> mockEmptyUsers() {
      return Future.delayed(const Duration(seconds: 1), () => []);
    }

    Future<List<User>> mockErrorFetch() {
      return Future.delayed(
        const Duration(seconds: 1),
        () => throw Exception('Failed to load users'),
      );
    }

    testWidgets('displays loading indicator initially', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
            home: HomeScreen(
          futureUsers: mockFetchUsers(),
        )),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Advance the timer to ensure no pending timers remain
      await tester.pumpAndSettle();
    });

    testWidgets('displays list of users when data loads', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
            home: HomeScreen(
          futureUsers: mockFetchUsers(),
        )),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(users.length));

      for (final user in users) {
        expect(find.text(user.name), findsOneWidget);
        expect(find.text(user.email), findsOneWidget);
      }
    });

    testWidgets('displays empty list message when no users', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
            home: HomeScreen(
          futureUsers: mockEmptyUsers(),
        )),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('displays error message when fetch fails', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
            home: HomeScreen(
          futureUsers: mockErrorFetch(),
        )),
      );

      await tester.pumpAndSettle();

      expect(find.text('Exception: Failed to load users'), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });
  });
}

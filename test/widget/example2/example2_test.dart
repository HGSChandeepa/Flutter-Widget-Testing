import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/example2/example2.dart';
import 'package:flutter_test/flutter_test.dart';
// Import your widget file
// import 'package:your_app/widgets/user_profile_card.dart';

void main() {
  group('UserProfileCard Widget Tests', () {
    testWidgets('renders all user information correctly', (tester) async {
      bool? favoriteStatus;
      bool editPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserProfileCard(
              name: 'John Doe',
              email: 'john@example.com',
              avatarUrl: 'https://example.com/avatar.jpg',
              onFavorite: (status) => favoriteStatus = status,
              onEdit: () => editPressed = true,
            ),
          ),
        ),
      );

      // Verify basic information is displayed
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);

      // Verify stats are displayed
      expect(find.text('Posts'), findsOneWidget);
      expect(find.text('125'), findsOneWidget);
      expect(find.text('Followers'), findsOneWidget);
      expect(find.text('1.2K'), findsOneWidget);
      expect(find.text('Following'), findsOneWidget);
      expect(find.text('723'), findsOneWidget);

      // Test favorite button interaction
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pump();

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
      expect(favoriteStatus, true);

      // Test edit button interaction
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pump();

      expect(editPressed, true);
    });

    testWidgets('handles null callbacks gracefully', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserProfileCard(
              name: 'John Doe',
              email: 'john@example.com',
              avatarUrl: 'https://example.com/avatar.jpg',
            ),
          ),
        ),
      );

      // Verify buttons still exist
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);

      // Verify tapping doesn't crash when callbacks are null
      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pump();
    });

    testWidgets('applies correct styling', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserProfileCard(
              name: 'John Doe',
              email: 'john@example.com',
              avatarUrl: 'https://example.com/avatar.jpg',
            ),
          ),
        ),
      );

      // Verify Card widget exists
      expect(find.byType(Card), findsOneWidget);

      // Verify CircleAvatar exists
      expect(find.byType(CircleAvatar), findsOneWidget);

      // Verify text styling
      final nameFinder = find.text('John Doe');
      final nameWidget = tester.widget<Text>(nameFinder);
      expect(nameWidget.style?.fontSize,
          Theme.of(tester.element(nameFinder)).textTheme.titleLarge?.fontSize);

      // Verify layout structure
      expect(find.byType(Row), findsNWidgets(2)); // Main row and stats row
      expect(
          find.byType(Column),
          findsNWidgets(
              5)); // Main column, user info column, and 3 stat columns
    });
  });
}

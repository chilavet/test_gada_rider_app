import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_gada_rider_app/core/theme/app_theme.dart';
import 'package:test_gada_rider_app/screens/home/rider_home_screen.dart';
import 'package:test_gada_rider_app/screens/profile/user_profile_screen.dart';
import 'package:test_gada_rider_app/state/rider_scope.dart';
import 'package:test_gada_rider_app/state/rider_state.dart';

import 'package:test_gada_rider_app/screens/profile/settings_screen.dart';

void main() {
  test('RiderState toggles night/day mode', () {
    final state = RiderState();

    expect(state.themeMode, equals(ThemeMode.light));
    expect(state.isNightMode, isFalse);

    // Toggle to night mode
    state.toggleNightMode();
    expect(state.themeMode, equals(ThemeMode.dark));
    expect(state.isNightMode, isTrue);

    // Toggle back to day mode
    state.toggleNightMode();
    expect(state.themeMode, equals(ThemeMode.light));
    expect(state.isNightMode, isFalse);

    // Set to system mode
    state.setThemeMode(ThemeMode.system);
    expect(state.themeMode, equals(ThemeMode.system));
  });

  testWidgets('SettingsScreen displays Night & Day Mode section and switches themes', (tester) async {
    final state = RiderState();

    await tester.pumpWidget(
      RiderScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.themeMode,
          home: const SettingsScreen(),
        ),
      ),
    );

    expect(find.text('Display & Appearance'), findsOneWidget);
    expect(find.text('Night & Day Mode'), findsOneWidget);
    expect(find.text('Day'), findsOneWidget);
    expect(find.text('Night'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);

    // Tap Night segment
    await tester.tap(find.text('Night'));
    await tester.pump();
    expect(state.themeMode, equals(ThemeMode.dark));
    expect(state.isNightMode, isTrue);

    // Tap Day segment
    await tester.tap(find.text('Day'));
    await tester.pump();
    expect(state.themeMode, equals(ThemeMode.light));
    expect(state.isNightMode, isFalse);
  });

  testWidgets('UserProfileScreen navigates to SettingsScreen when Settings is tapped', (tester) async {
    final state = RiderState();

    await tester.pumpWidget(
      RiderScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.themeMode,
          home: const UserProfileScreen(),
        ),
      ),
    );

    expect(find.text('Settings'), findsOneWidget);

    // Scroll until Settings is in view inside SingleChildScrollView
    await tester.scrollUntilVisible(
      find.text('Settings'),
      50,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();

    expect(find.text('Day Mode'), findsOneWidget);

    // Tap Settings tile to open SettingsScreen
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Display & Appearance'), findsOneWidget);
    expect(find.text('Night & Day Mode'), findsOneWidget);
  });

  testWidgets('RiderHomeScreen top bar quick toggle switches Night/Day mode', (tester) async {
    final state = RiderState();

    await tester.pumpWidget(
      RiderScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.themeMode,
          home: const RiderHomeScreen(),
        ),
      ),
    );

    expect(find.byIcon(Icons.nightlight_round), findsOneWidget);

    // Tap top bar quick toggle button
    await tester.tap(find.byIcon(Icons.nightlight_round));
    await tester.pump();

    expect(state.isNightMode, isTrue);
    expect(find.byIcon(Icons.wb_sunny_rounded), findsOneWidget);
  });
}

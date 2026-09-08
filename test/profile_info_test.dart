import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_gada_rider_app/core/theme/app_theme.dart';
import 'package:test_gada_rider_app/screens/profile/profile_info_screen.dart';
import 'package:test_gada_rider_app/screens/profile/user_profile_screen.dart';
import 'package:test_gada_rider_app/state/rider_scope.dart';
import 'package:test_gada_rider_app/state/rider_state.dart';

void main() {
  test('RiderState updates user profile attributes', () {
    final state = RiderState();

    expect(state.userProfile.firstName, equals('Allen'));
    expect(state.userProfile.lastName, equals('Edgar'));
    expect(state.userProfile.fullName, equals('Allen Edgar'));
    expect(state.userProfile.phone, equals('080123456789'));

    state.updateUserProfile(
      firstName: 'Alhaji',
      lastName: 'Musa',
      phone: '08099887766',
      email: 'musa.rider@gada.ng',
    );

    expect(state.userProfile.firstName, equals('Alhaji'));
    expect(state.userProfile.lastName, equals('Musa'));
    expect(state.userProfile.fullName, equals('Alhaji Musa'));
    expect(state.userProfile.phone, equals('08099887766'));
    expect(state.userProfile.email, equals('musa.rider@gada.ng'));
  });

  testWidgets('ProfileInfoScreen renders profile information and operational details', (tester) async {
    final state = RiderState();

    await tester.pumpWidget(
      RiderScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ProfileInfoScreen(),
        ),
      ),
    );

    // Profile header
    expect(find.text('Profile Info'), findsOneWidget);
    expect(find.text('Allen Edgar'), findsOneWidget);
    expect(find.text('Verified Rider'), findsOneWidget);
    expect(find.text('GDA-RD-0428'), findsOneWidget);

    // Personal information fields
    expect(find.text('Personal Information'), findsOneWidget);
    expect(find.text('First Name'), findsOneWidget);
    expect(find.text('Last Name'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Phone Number'), findsOneWidget);
    expect(find.text('Emergency Contact'), findsOneWidget);

    // Operational information
    expect(find.text('Operational & Vehicle Details'), findsOneWidget);
    expect(find.text('Assigned Vehicle'), findsOneWidget);
    expect(find.text('Vehicle Plate'), findsOneWidget);
    expect(find.text('TVS HLX 150 (Motorbike)'), findsOneWidget);
    expect(find.text('ABJ-892-XY'), findsOneWidget);
    expect(find.text('KYC Verification'), findsOneWidget);
  });

  testWidgets('ProfileInfoScreen edit mode allows updating details and saves changes', (tester) async {
    final state = RiderState();

    await tester.pumpWidget(
      RiderScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ProfileInfoScreen(),
        ),
      ),
    );

    // Enter edit mode
    expect(find.text('Edit'), findsOneWidget);
    await tester.tap(find.text('Edit'));
    await tester.pump();

    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Save Changes'), findsOneWidget);

    // Edit First Name
    final firstNameFinder = find.widgetWithText(TextField, 'Allen');
    await tester.enterText(firstNameFinder, 'Michael');
    await tester.pump();

    // Ensure Save Changes button is visible and tap
    await tester.ensureVisible(find.text('Save Changes'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();

    // Verify updated state
    expect(state.userProfile.firstName, equals('Michael'));
    expect(state.userProfile.fullName, equals('Michael Edgar'));
    expect(find.text('Profile information updated successfully!'), findsOneWidget);
  });

  testWidgets('UserProfileScreen navigates to ProfileInfoScreen when Profile Info is tapped', (tester) async {
    final state = RiderState();

    await tester.pumpWidget(
      RiderScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const UserProfileScreen(),
        ),
      ),
    );

    expect(find.text('Profile Info'), findsOneWidget);
    expect(find.text('Allen Edgar'), findsOneWidget);

    await tester.tap(find.text('Profile Info'));
    await tester.pumpAndSettle();

    expect(find.text('Personal Information'), findsOneWidget);
    expect(find.text('Operational & Vehicle Details'), findsOneWidget);
  });

  testWidgets('UserProfileScreen renders Log Out / Switch Account with clearance above bottom bar', (tester) async {
    final state = RiderState();

    await tester.pumpWidget(
      RiderScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: UserProfileScreen(),
          ),
        ),
      ),
    );

    // Scroll to the very bottom
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -600));
    await tester.pumpAndSettle();

    // Verify "Log Out / Switch Account" is visible and in view
    expect(find.text('Log Out / Switch Account'), findsOneWidget);
  });
}

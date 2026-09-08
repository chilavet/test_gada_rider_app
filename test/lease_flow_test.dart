import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_gada_rider_app/core/theme/app_theme.dart';
import 'package:test_gada_rider_app/models/lease_bike.dart';
import 'package:test_gada_rider_app/screens/lease/lease_application_screen.dart';
import 'package:test_gada_rider_app/screens/lease/lease_details_screen.dart';
import 'package:test_gada_rider_app/screens/lease/lease_home_screen.dart';
import 'package:test_gada_rider_app/screens/lease/lease_success_screen.dart';
import 'package:test_gada_rider_app/state/rider_scope.dart';
import 'package:test_gada_rider_app/state/rider_state.dart';

void main() {
  testWidgets('LeaseHomeScreen lists bikes and filters properly', (tester) async {
    final state = RiderState();

    await tester.pumpWidget(
      RiderScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const LeaseHomeScreen(),
        ),
      ),
    );

    // Initial items visible in list
    expect(find.text('TVS HLX 150'), findsOneWidget);
    expect(find.text('Yamaha YZF-R15'), findsOneWidget);

    // Test search filter for Honda
    await tester.enterText(find.byType(TextField), 'Honda');
    await tester.pump();

    expect(find.text('Honda CB Shine'), findsOneWidget);
    expect(find.text('TVS HLX 150'), findsNothing);

    // Clear search and find Yamaha
    await tester.enterText(find.byType(TextField), 'Yamaha');
    await tester.pump();
    expect(find.text('Yamaha YZF-R15'), findsOneWidget);
    expect(find.text('Honda CB Shine'), findsNothing);
  });

  testWidgets('LeaseDetailsScreen shows metrics and navigates to application', (tester) async {
    final state = RiderState();
    final bike = LeaseBike.sampleBikes.first;

    await tester.pumpWidget(
      RiderScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: LeaseDetailsScreen(bike: bike),
        ),
      ),
    );

    expect(find.text('Lease details'), findsOneWidget);
    expect(find.text('TVS HLX 150'), findsOneWidget);
    expect(find.text('Requirements'), findsOneWidget);
    expect(find.text('Valid NIN'), findsOneWidget);
    expect(find.text('How payment works'), findsOneWidget);
    expect(find.text('Apply for this lease'), findsOneWidget);

    // Scroll to Apply button and tap
    await tester.ensureVisible(find.text('Apply for this lease'));
    await tester.tap(find.text('Apply for this lease'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(LeaseApplicationScreen), findsOneWidget);
    expect(find.text('Applicant details'), findsOneWidget);
  });

  testWidgets('LeaseApplicationScreen submits and updates state', (tester) async {
    final state = RiderState();
    final bike = LeaseBike.sampleBikes.first;

    await tester.pumpWidget(
      RiderScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: LeaseApplicationScreen(bike: bike),
        ),
      ),
    );

    expect(find.text('Submit application'), findsOneWidget);
    expect(state.appliedBikes.contains(bike.id), isFalse);

    // Scroll to submit button and tap
    await tester.ensureVisible(find.text('Submit application'));
    await tester.tap(find.text('Submit application'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(state.appliedBikes.contains(bike.id), isTrue);
    expect(find.byType(LeaseSuccessScreen), findsOneWidget);
    expect(find.text('Visit our office to complete your application'), findsOneWidget);
    expect(find.text('Location: 123 Plot 123, Wuse 2, Abuja'), findsOneWidget);
  });
}

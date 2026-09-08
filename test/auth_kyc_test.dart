import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_gada_rider_app/core/theme/app_theme.dart';
import 'package:test_gada_rider_app/screens/auth/get_started_screen.dart';
import 'package:test_gada_rider_app/screens/auth/kyc_documents_screen.dart';
import 'package:test_gada_rider_app/screens/auth/otp_verification_screen.dart';
import 'package:test_gada_rider_app/screens/auth/user_type_selection_screen.dart';
import 'package:test_gada_rider_app/state/rider_scope.dart';
import 'package:test_gada_rider_app/state/rider_state.dart';

void main() {
  testWidgets('GetStartedScreen renders phone input and continues to OTP', (tester) async {
    final state = RiderState();

    await tester.pumpWidget(
      RiderScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const GetStartedScreen(),
        ),
      ),
    );

    expect(find.text('+234'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);

    // Tap Continue
    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(OtpVerificationScreen), findsOneWidget);
    expect(find.text('Verify your phone number'), findsOneWidget);
  });

  testWidgets('UserTypeSelectionScreen displays 3 role options and selects Rider', (tester) async {
    final state = RiderState();

    await tester.pumpWidget(
      RiderScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const UserTypeSelectionScreen(),
        ),
      ),
    );

    expect(find.text("Choose how you'll work"), findsOneWidget);
    expect(find.text('I am a Rider'), findsOneWidget);
    expect(find.text('I am a Market Agent'), findsOneWidget);
    expect(find.text('I Want to Lease a Vehicle'), findsOneWidget);

    // Tap Rider
    await tester.tap(find.text('I am a Rider'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(KycDocumentsScreen), findsOneWidget);
    expect(find.text('Complete your Rider KYC'), findsOneWidget);
  });

  testWidgets('KycDocumentsScreen tracks stage completion in RiderState', (tester) async {
    final state = RiderState();

    await tester.pumpWidget(
      RiderScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const KycDocumentsScreen(roleName: 'Rider'),
        ),
      ),
    );

    expect(find.text('Personal information'), findsOneWidget);
    expect(find.text('Identity verification'), findsOneWidget);

    // Tap Identity verification
    await tester.ensureVisible(find.text('Identity verification'));
    await tester.tap(find.text('Identity verification'));
    await tester.pump();
    expect(state.kycIdentityDone, isTrue);

    // Tap Vehicle information
    await tester.ensureVisible(find.text('Vehicle information'));
    await tester.tap(find.text('Vehicle information'));
    await tester.pump();
    expect(state.kycVehicleDone, isTrue);

    // Tap Bank details
    await tester.ensureVisible(find.text('Bank details'));
    await tester.tap(find.text('Bank details'));
    await tester.pump();
    expect(state.kycBankDone, isTrue);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_gada_rider_app/main.dart';
import 'package:test_gada_rider_app/widgets/gada_logo.dart';

void main() {
  testWidgets('Rider app launches and displays Home elements', (WidgetTester tester) async {
    // Set a standard mobile screen size
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(() => tester.view.resetPhysicalSize());

    // Build our app and trigger a frame.
    await tester.pumpWidget(const TestGadaRiderApp());
    await tester.pump(const Duration(milliseconds: 200));

    // Verify logo and brand presence
    expect(find.byType(GadaLogo), findsOneWidget);
    expect(find.text('TEST'), findsOneWidget);

    // Verify online status
    expect(find.text('You are Online'), findsOneWidget);

    // Verify metric cards
    expect(find.text('EARNINGS'), findsOneWidget);
    expect(find.text('COMPLETED TRIPS'), findsOneWidget);
    expect(find.text('DISTANCE COVERED'), findsOneWidget);

    // Verify bottom navigation tabs
    expect(find.byIcon(Icons.home_filled), findsOneWidget);
    expect(find.byIcon(Icons.assignment_outlined), findsOneWidget);
    expect(find.byIcon(Icons.account_balance_wallet_outlined), findsOneWidget);
    expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);

    // Tap on Orders Tab
    await tester.tap(find.byIcon(Icons.assignment_outlined));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Orders & Tasks'), findsOneWidget);

    // Tap on Earnings Tab
    await tester.tap(find.byIcon(Icons.account_balance_wallet_outlined));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Earnings & Wallet'), findsOneWidget);
    expect(find.text('Recent Payout History'), findsOneWidget);

    // Tap on Profile Tab
    await tester.tap(find.byIcon(Icons.person_outline_rounded));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Rider Profile'), findsOneWidget);
    expect(find.text('Tunde Bakare'), findsOneWidget);
  });
}

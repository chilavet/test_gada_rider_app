import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_gada_rider_app/main.dart';
import 'package:test_gada_rider_app/widgets/gada_logo.dart';

void main() {
  testWidgets('Rider app launches and displays Home elements matching Figma', (WidgetTester tester) async {
    // Set a standard mobile screen size
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(() => tester.view.resetPhysicalSize());

    // Build our app and trigger a frame.
    await tester.pumpWidget(const TestGadaRiderApp());
    await tester.pump(const Duration(milliseconds: 200));

    // Verify logo and brand presence
    expect(find.byType(GadaLogo), findsOneWidget);
    expect(find.byType(SvgPicture), findsWidgets);

    // Verify greeting and status
    expect(find.text('Good morning, Daniel'), findsOneWidget);
    expect(find.text('Online'), findsOneWidget);
    expect(find.text('Waiting for jobs'), findsOneWidget);

    // Verify activities section
    expect(find.text("Today's activities"), findsOneWidget);
    expect(find.text("Today's earnings"), findsOneWidget);
    expect(find.text('Trips completed'), findsOneWidget);
    expect(find.text('Distance covered'), findsOneWidget);
    expect(find.text('Active hours'), findsOneWidget);

    // Verify bottom navigation tabs
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Jobs'), findsOneWidget);
    expect(find.text('Earnings'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Tap on Jobs Tab
    await tester.tap(find.text('Jobs'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Orders & Tasks'), findsOneWidget);

    // Tap on Earnings Tab
    await tester.tap(find.text('Earnings'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Track your earnings and payouts'), findsOneWidget);
    expect(find.text('Payout history'), findsOneWidget);

    // Tap on Profile Tab
    await tester.tap(find.text('Profile'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Hello, Allen'), findsOneWidget);
    expect(find.text('Wallet Balance'), findsOneWidget);
  });
}

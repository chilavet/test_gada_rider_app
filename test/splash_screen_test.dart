import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_gada_rider_app/core/theme/app_theme.dart';
import 'package:test_gada_rider_app/screens/auth/get_started_screen.dart';
import 'package:test_gada_rider_app/screens/main_rider_shell.dart';
import 'package:test_gada_rider_app/screens/splash/splash_brand_screen.dart';
import 'package:test_gada_rider_app/screens/splash/splash_welcome_screen.dart';
import 'package:test_gada_rider_app/state/rider_scope.dart';
import 'package:test_gada_rider_app/state/rider_state.dart';
import 'package:test_gada_rider_app/widgets/delivery_scene_graphic.dart';
import 'package:test_gada_rider_app/widgets/gada_logo.dart';

void main() {
  testWidgets('SplashBrandScreen displays GadaLogo on brand blue and navigates on tap', (tester) async {
    final state = RiderState();

    await tester.pumpWidget(
      RiderScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const SplashBrandScreen(displayDuration: Duration(seconds: 10)),
        ),
      ),
    );

    expect(find.byType(GadaLogo), findsOneWidget);
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, equals(const Color(0xFF0037A4)));

    // Tap on screen to skip timer and navigate
    await tester.tap(find.byType(SplashBrandScreen));
    await tester.pumpAndSettle();

    // Since state.isAuthenticated is true by default, it navigates to MainRiderShell
    expect(find.byType(MainRiderShell), findsOneWidget);
  });

  testWidgets('SplashBrandScreen navigates to SplashWelcomeScreen when user is logged out', (tester) async {
    final state = RiderState();
    state.logout(); // user is logged out

    await tester.pumpWidget(
      RiderScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const SplashBrandScreen(displayDuration: Duration(seconds: 10)),
        ),
      ),
    );

    await tester.tap(find.byType(SplashBrandScreen));
    await tester.pumpAndSettle();

    expect(find.byType(SplashWelcomeScreen), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });

  testWidgets('SplashWelcomeScreen renders delivery graphic and Get Started CTA', (tester) async {
    final state = RiderState();

    await tester.pumpWidget(
      RiderScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const SplashWelcomeScreen(),
        ),
      ),
    );

    expect(find.byType(GadaLogo), findsOneWidget);
    expect(find.byType(DeliverySceneGraphic), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Already active? Enter Dashboard'), findsOneWidget);

    // Tap "Get Started" to navigate to GetStartedScreen
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.byType(GetStartedScreen), findsOneWidget);
  });
}

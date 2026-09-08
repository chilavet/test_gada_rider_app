import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_brand_screen.dart';
import 'state/rider_scope.dart';
import 'state/rider_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TestGadaRiderApp());
}

class TestGadaRiderApp extends StatefulWidget {
  const TestGadaRiderApp({super.key});

  @override
  State<TestGadaRiderApp> createState() => _TestGadaRiderAppState();
}

class _TestGadaRiderAppState extends State<TestGadaRiderApp> {
  final RiderState _riderState = RiderState();

  @override
  void dispose() {
    _riderState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RiderScope(
      state: _riderState,
      child: ListenableBuilder(
        listenable: _riderState,
        builder: (context, _) {
          return MaterialApp(
            title: 'test_gada Rider App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _riderState.themeMode,
            home: const SplashBrandScreen(),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/main_rider_shell.dart';
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
      child: MaterialApp(
        title: 'test_gada Rider App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainRiderShell(),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import '../../state/rider_scope.dart';
import '../../widgets/gada_logo.dart';
import '../main_rider_shell.dart';
import 'splash_welcome_screen.dart';

/// Primary Brand Launch Splash Screen (Figma node 717:12845).
/// Features the signature Gada royal blue background (#0037A4)
/// with the centered white/orange Gadaride vector logo.
class SplashBrandScreen extends StatefulWidget {
  final Duration displayDuration;

  const SplashBrandScreen({
    super.key,
    this.displayDuration = const Duration(milliseconds: 1800),
  });

  @override
  State<SplashBrandScreen> createState() => _SplashBrandScreenState();
}

class _SplashBrandScreenState extends State<SplashBrandScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );

    _animController.forward();

    _navigationTimer = Timer(widget.displayDuration, () {
      if (mounted) {
        _proceedToNextScreen();
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _proceedToNextScreen() {
    final state = RiderScope.of(context);
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, _, _) => state.isAuthenticated
            ? const MainRiderShell()
            : const SplashWelcomeScreen(),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _proceedToNextScreen,
      child: Scaffold(
        backgroundColor: const Color(0xFF0037A4), // Brand Primary Blue (Figma 717:12845)
        body: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: const GadaLogo(
                size: 48,
                isDark: true, // Crisp white typography on brand blue
              ),
            ),
          ),
        ),
      ),
    );
  }
}

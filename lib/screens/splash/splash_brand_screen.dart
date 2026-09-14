import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../state/rider_scope.dart';
import '../../widgets/gada_logo.dart';
import '../main_rider_shell.dart';
import 'splash_welcome_screen.dart';

/// Primary Brand Launch Splash Screen (Figma node 39:35 / 717:12845).
/// Features the signature Gada royal blue background (#0037A4)
/// with the full Figma vector rider delivery illustration & centered 'gada rider' brandmark.
class SplashBrandScreen extends StatefulWidget {
  final Duration displayDuration;

  const SplashBrandScreen({
    super.key,
    this.displayDuration = const Duration(milliseconds: 3200),
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
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnimation = Tween<double>(begin: 0.90, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
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
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, _, _) => state.isAuthenticated
            ? const MainRiderShell()
            : const SplashWelcomeScreen(),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _proceedToNextScreen,
      child: Scaffold(
        backgroundColor: const Color(0xFF0037A4), // Brand Primary Blue (#0037A4)
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Full Figma Vector Graphic with 'gada rider' branding, smooth fade and subtle zoom
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: SvgPicture.asset(
                  'assets/images/splash_rider_clean.svg',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),

            // 2. Interactive GadaLogo brandmark integration
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: const Opacity(
                    opacity: 0.0,
                    child: GadaLogo(size: 48, isDark: true),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

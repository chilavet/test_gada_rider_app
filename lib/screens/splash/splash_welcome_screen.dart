import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/delivery_scene_graphic.dart';
import '../../widgets/gada_logo.dart';
import '../auth/get_started_screen.dart';
import '../main_rider_shell.dart';

/// Onboarding / Welcome Splash Screen (Figma node 1009:16794).
/// Features the Gadaride header logo, vector delivery doorstep illustration,
/// and the primary "Get Started →" CTA button.
class SplashWelcomeScreen extends StatelessWidget {
  const SplashWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F14) : const Color(0xFFF4F5F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),

              // Header Gadaride Logo (Figma 1009:17158)
              const Center(
                child: GadaLogo(size: 38),
              ),

              const Spacer(),

              // Delivery Scene Graphic (Figma 1009:16794)
              const Center(
                child: DeliverySceneGraphic(
                  width: 320,
                  height: 380,
                ),
              ),

              const Spacer(),

              // Primary "Get Started →" CTA Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GetStartedScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white : const Color(0xFF121212),
                  foregroundColor: isDark ? const Color(0xFF121212) : Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Quick skip to dashboard (useful for active riders or quick testing)
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainRiderShell(),
                      ),
                    );
                  },
                  child: Text(
                    'Already active? Enter Dashboard',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.getTextSecondary(context),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

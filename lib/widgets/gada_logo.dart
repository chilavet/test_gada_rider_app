import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class GadaLogo extends StatelessWidget {
  final double size;
  final bool showBadge;

  const GadaLogo({
    super.key,
    this.size = 24,
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Gada orange circular brandmark
          Container(
            width: size + 6,
            height: size + 6,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: (size + 6) * 0.52,
                height: (size + 6) * 0.52,
                decoration: const BoxDecoration(
                  color: Color(0xFF101010),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'g',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size * 0.50,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Logo Text "gadaride"
          Text(
            'gadaride',
            style: TextStyle(
              fontSize: size,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          if (showBadge) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'TEST',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

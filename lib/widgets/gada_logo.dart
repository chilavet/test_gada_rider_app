import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class GadaLogo extends StatelessWidget {
  final double size;
  final bool showBadge;

  const GadaLogo({
    super.key,
    this.size = 28,
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
        // Brand Mark Icon
        Container(
          width: size + 6,
          height: size + 6,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.electric_moped_rounded,
              color: Colors.white,
              size: size * 0.72,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Logo Text
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'gada',
                style: TextStyle(
                  fontSize: size,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              TextSpan(
                text: 'ride',
                style: TextStyle(
                  fontSize: size,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        if (showBadge) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: const Text(
              'TEST',
              style: TextStyle(
                color: AppColors.primaryLight,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ],
      ),
    );
  }
}

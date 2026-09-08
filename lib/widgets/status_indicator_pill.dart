import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class StatusIndicatorPill extends StatefulWidget {
  final bool isOnline;
  final VoidCallback onTap;

  const StatusIndicatorPill({
    super.key,
    required this.isOnline,
    required this.onTap,
  });

  @override
  State<StatusIndicatorPill> createState() => _StatusIndicatorPillState();
}

class _StatusIndicatorPillState extends State<StatusIndicatorPill>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.25).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusColor =
        widget.isOnline ? AppColors.onlineGreen : AppColors.offlineGray;
    final text = widget.isOnline ? 'You are Online' : 'You are Offline';

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: widget.isOnline
              ? AppColors.onlineGreen.withValues(alpha: 0.12)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: widget.isOnline
                ? AppColors.onlineGreen.withValues(alpha: 0.4)
                : AppColors.cardBorder,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isOnline)
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    width: 10 * _pulseAnimation.value,
                    height: 10 * _pulseAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.onlineGreen,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.onlineGreen.withValues(alpha: 0.6),
                          blurRadius: 6 * _pulseAnimation.value,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  );
                },
              )
            else
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.offlineGray,
                ),
              ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: statusColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../state/rider_scope.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = RiderScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rider Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            // User Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryContainer,
                          border: Border.all(color: AppColors.primary, width: 2.5),
                        ),
                        child: const Center(
                          child: Icon(Icons.person_rounded, size: 44, color: AppColors.primaryLight),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.onlineGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text('Tunde Bakare', style: AppTypography.headlineLarge),
                  const SizedBox(height: 2),
                  const Text('+234 802 881 9920 • Abuja, NG', style: AppTypography.bodyMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _badge('⭐ 4.9 Rating', AppColors.warningBg, AppColors.warning),
                      _badge('Tier 2 Verified', AppColors.successBg, AppColors.onlineGreen),
                      _badge(state.activeRole, AppColors.surfaceLight, AppColors.primaryLight),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Vehicle / Lease Info
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.electric_moped_rounded, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Spiro Commuter EV Motorbike', style: AppTypography.titleMedium),
                        SizedBox(height: 2),
                        Text('Plate: ABJ-492-KW • Active Lease Program', style: AppTypography.bodyMedium),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Menu Items
            _menuTile(Icons.assignment_turned_in_rounded, 'KYC Documents & Verification', 'Driver license & National ID approved'),
            _menuTile(Icons.account_balance_rounded, 'Bank & Payout Settings', 'GTBank ••• 4092'),
            _menuTile(Icons.electric_bolt_rounded, 'Lease Repayment Tracker', 'Weekly target: ₦18,000 (85% paid)'),
            _menuTile(Icons.notifications_none_rounded, 'Notifications & Audio Alerts', 'Loud chime enabled for orders'),
            _menuTile(Icons.headset_mic_rounded, 'Rider Support & Emergency SOS', '24/7 dedicated helpline'),

            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out of session.')),
                );
              },
              icon: const Icon(Icons.logout_rounded, color: AppColors.error, size: 18),
              label: const Text('Log Out', style: TextStyle(color: AppColors.error)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _menuTile(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleMedium),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTypography.bodyMedium),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

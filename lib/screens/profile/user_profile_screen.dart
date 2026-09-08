import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../state/rider_scope.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = RiderScope.of(context);
    final currency = NumberFormat.currency(locale: 'en_NG', symbol: '₦ ', decimalDigits: 2);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Hello, Allen',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Earnings Section
            _sectionHeader('Earnings'),
            _menuTile(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Wallet Balance',
              trailingText: currency.format(state.stats.walletBalance),
              onTap: () {},
            ),
            const SizedBox(height: 16),

            // Profile Section
            _sectionHeader('Profile'),
            _menuTile(
              icon: Icons.person_outline_rounded,
              title: 'Profile Info',
              onTap: () {},
            ),
            _menuTile(
              icon: Icons.description_outlined,
              title: 'Documents & KYC',
              onTap: () {},
            ),
            const SizedBox(height: 16),

            // Other Section
            _sectionHeader('Other'),
            _menuTile(
              icon: Icons.headset_mic_outlined,
              title: 'Contact support',
              onTap: () {},
            ),
            _menuTile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {},
            ),
            _menuTile(
              icon: Icons.help_outline_rounded,
              title: 'Privacy',
              onTap: () {},
            ),
            _menuTile(
              icon: Icons.article_outlined,
              title: 'Terms of use',
              onTap: () {},
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Icon(icon, color: AppColors.textPrimary, size: 22),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailingText != null)
                Text(
                  trailingText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

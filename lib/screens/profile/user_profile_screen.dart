import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../state/rider_scope.dart';

import '../auth/get_started_screen.dart';
import '../auth/kyc_documents_screen.dart';
import '../lease/lease_home_screen.dart';
import 'settings_screen.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = RiderScope.of(context);
    final currency = NumberFormat.currency(locale: 'en_NG', symbol: '₦ ', decimalDigits: 2);

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: AppColors.getBackground(context),
        title: Text(
          'Hello, Allen',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.getTextPrimary(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Earnings Section
            _sectionHeader(context, 'Earnings'),
            _menuTile(
              context: context,
              icon: Icons.account_balance_wallet_outlined,
              title: 'Wallet Balance',
              trailingText: currency.format(state.stats.walletBalance),
              onTap: () {},
            ),
            const SizedBox(height: 16),

            // Profile Section
            _sectionHeader(context, 'Profile'),
            _menuTile(
              context: context,
              icon: Icons.person_outline_rounded,
              title: 'Profile Info',
              onTap: () {},
            ),
            _menuTile(
              context: context,
              icon: Icons.description_outlined,
              title: 'Documents & KYC',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => KycDocumentsScreen(roleName: state.activeRole),
                  ),
                );
              },
            ),
            _menuTile(
              context: context,
              icon: Icons.two_wheeler_rounded,
              title: 'Browse Vehicle Leases',
              trailingText: '${state.appliedBikes.length} Applied',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LeaseHomeScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Other Section
            _sectionHeader(context, 'Other'),
            _menuTile(
              context: context,
              icon: Icons.headset_mic_outlined,
              title: 'Contact support',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Support Hotline: +234 800 4232 7433')),
                );
              },
            ),
            _menuTile(
              context: context,
              icon: Icons.settings_outlined,
              title: 'Settings',
              trailingText: state.isNightMode ? 'Night Mode' : 'Day Mode',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
            ),
            _menuTile(
              context: context,
              icon: Icons.help_outline_rounded,
              title: 'Privacy',
              onTap: () {},
            ),
            _menuTile(
              context: context,
              icon: Icons.article_outlined,
              title: 'Terms of use',
              onTap: () {},
            ),
            _menuTile(
              context: context,
              icon: Icons.logout_rounded,
              title: 'Log Out / Switch Account',
              onTap: () {
                state.logout();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GetStartedScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.getTextSecondary(context),
        ),
      ),
    );
  }

  Widget _menuTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.getCardBorder(context)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Icon(icon, color: AppColors.getTextPrimary(context), size: 22),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailingText != null)
                Text(
                  trailingText,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
              const SizedBox(width: 6),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.getTextTertiary(context),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

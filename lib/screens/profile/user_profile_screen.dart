import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../state/rider_scope.dart';
import '../../state/rider_state.dart';

import '../auth/get_started_screen.dart';
import '../auth/kyc_documents_screen.dart';
import '../lease/lease_home_screen.dart';

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

            // Display & Theme Mode Section (Night / Day Mode)
            _sectionHeader(context, 'Display & Theme Mode'),
            _nightDayModeCard(context, state),
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
              onTap: () {},
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

  Widget _nightDayModeCard(BuildContext context, RiderState state) {
    final isNight = state.isNightMode;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.getCardBorder(context), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isNight ? 0.25 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isNight
                      ? const Color(0xFF312E81).withValues(alpha: 0.5)
                      : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    isNight ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                    color: isNight ? const Color(0xFFA5B4FC) : const Color(0xFFD97706),
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Night & Day Mode',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Adjust contrast and screen glare for daytime or night riding',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.getTextSecondary(context),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 3-Way Mode Segmented Selector (Day / Night / System)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.getSurfaceElevated(context),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                _modeSegmentOption(
                  context: context,
                  label: 'Day',
                  icon: Icons.wb_sunny_rounded,
                  isSelected: state.themeMode == ThemeMode.light,
                  onTap: () => state.setThemeMode(ThemeMode.light),
                ),
                _modeSegmentOption(
                  context: context,
                  label: 'Night',
                  icon: Icons.nightlight_round,
                  isSelected: state.themeMode == ThemeMode.dark,
                  onTap: () => state.setThemeMode(ThemeMode.dark),
                ),
                _modeSegmentOption(
                  context: context,
                  label: 'System',
                  icon: Icons.brightness_auto_rounded,
                  isSelected: state.themeMode == ThemeMode.system,
                  onTap: () => state.setThemeMode(ThemeMode.system),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Direct Toggle Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Night Ride Contrast',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isNight ? 'Active (Low screen eye-strain)' : 'Inactive (High brightness)',
                      style: TextStyle(
                        fontSize: 12,
                        color: isNight ? AppColors.onlineGreen : AppColors.getTextSecondary(context),
                        fontWeight: isNight ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Switch.adaptive(
                value: isNight,
                activeThumbColor: AppColors.primary,
                activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
                onChanged: (_) => state.toggleNightMode(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _modeSegmentOption({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final activeBg = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2E2E38)
        : Colors.white;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? activeBg : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected ? AppColors.primary : AppColors.getTextSecondary(context),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? AppColors.getTextPrimary(context)
                      : AppColors.getTextSecondary(context),
                ),
              ),
            ],
          ),
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

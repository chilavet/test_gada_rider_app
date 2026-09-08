import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'earnings/rider_earnings_screen.dart';
import 'home/rider_home_screen.dart';
import 'orders/rider_jobs_screen.dart';
import 'profile/user_profile_screen.dart';

class MainRiderShell extends StatefulWidget {
  const MainRiderShell({super.key});

  @override
  State<MainRiderShell> createState() => _MainRiderShellState();
}

class _MainRiderShellState extends State<MainRiderShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    RiderHomeScreen(),
    RiderJobsScreen(),
    RiderEarningsScreen(),
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Container(
            height: 68,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.getSurface(context),
              borderRadius: BorderRadius.circular(36),
              border: Border.all(color: AppColors.getCardBorder(context)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: _navItem(0, Icons.home_outlined, Icons.home_rounded, 'Home')),
                Expanded(child: _navItem(1, Icons.alt_route_outlined, Icons.alt_route_rounded, 'Jobs')),
                Expanded(child: _navItem(2, Icons.account_balance_wallet_outlined, Icons.account_balance_wallet_rounded, 'Earnings')),
                Expanded(child: _avatarNavItem(3)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData outlineIcon, IconData solidIcon, String label) {
    final isSelected = _currentIndex == index;
    final activeBg = AppColors.getSurfaceElevated(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? solidIcon : outlineIcon,
              size: 20,
              color: isSelected ? AppColors.primary : AppColors.getTextPrimary(context),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.getTextPrimary(context),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarNavItem(int index) {
    final isSelected = _currentIndex == index;
    final activeBg = AppColors.getSurfaceElevated(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8DCC4),
                border: isSelected
                    ? Border.all(color: AppColors.primary, width: 1.5)
                    : null,
              ),
              child: const Center(
                child: Text('🧔‍♂️', style: TextStyle(fontSize: 14)),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Profile',
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.getTextPrimary(context),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

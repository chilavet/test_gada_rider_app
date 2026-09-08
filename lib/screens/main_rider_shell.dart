import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'home/rider_home_screen.dart';
import 'orders/rider_jobs_screen.dart';
import 'earnings/rider_earnings_screen.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        color: AppColors.background,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3F4F6) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? solidIcon : outlineIcon,
              size: 20,
              color: AppColors.textPrimary,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimary,
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3F4F6) : Colors.transparent,
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
                    ? Border.all(color: AppColors.darkCta, width: 1.5)
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
                color: AppColors.textPrimary,
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

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
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.cardBorder, width: 1.2),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: _navItem(0, Icons.home_filled, 'Home')),
                Expanded(child: _navItem(1, Icons.assignment_outlined, 'Orders')),
                Expanded(child: _navItem(2, Icons.account_balance_wallet_outlined, 'Earnings')),
                Expanded(child: _navItem(3, Icons.person_outline_rounded, 'Profile')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
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

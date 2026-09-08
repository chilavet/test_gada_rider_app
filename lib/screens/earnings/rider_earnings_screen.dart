import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../state/rider_scope.dart';

class RiderEarningsScreen extends StatefulWidget {
  const RiderEarningsScreen({super.key});

  @override
  State<RiderEarningsScreen> createState() => _RiderEarningsScreenState();
}

class _RiderEarningsScreenState extends State<RiderEarningsScreen> {
  String _selectedPeriod = 'Today';

  @override
  Widget build(BuildContext context) {
    final state = RiderScope.of(context);
    final stats = state.stats;
    final payouts = state.payouts;
    final currency = NumberFormat.currency(locale: 'en_NG', symbol: '₦ ', decimalDigits: 0);

    final displayEarnings = _selectedPeriod == 'Today' ? stats.todayEarnings : stats.weeklyEarnings;
    final displayTrips = _selectedPeriod == 'Today' ? stats.todayTrips : stats.weeklyTrips;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Earnings & Wallet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Period Selector Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Today', 'This Week', 'This Month'].map((period) {
                  final isSelected = _selectedPeriod == period;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(period),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.cardBorder,
                        ),
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedPeriod = period);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 18),

            // Summary Card
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF221508), AppColors.surface],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_selectedPeriod Gross Earnings',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    currency.format(displayEarnings),
                    style: AppTypography.displayLarge.copyWith(
                      color: Colors.white,
                      fontSize: 34,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.onlineGreen.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.onlineGreen),
                            const SizedBox(width: 4),
                            Text(
                              '$displayTrips Trips Completed',
                              style: const TextStyle(
                                color: AppColors.onlineGreen,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Wallet: ${currency.format(stats.walletBalance)}',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Withdrawal request initiated to registered bank account.')),
                      );
                    },
                    icon: const Icon(Icons.account_balance_rounded, size: 18),
                    label: const Text('Withdraw Funds to Bank'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payout Transaction History
            const Text('Recent Payout History', style: AppTypography.headlineMedium),
            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: payouts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final p = payouts[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: p.isCredit
                              ? AppColors.onlineGreen.withValues(alpha: 0.12)
                              : AppColors.surfaceLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          p.isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                          size: 16,
                          color: p.isCredit ? AppColors.onlineGreen : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.description, style: AppTypography.titleMedium),
                            const SizedBox(height: 2),
                            Text(
                              '${p.orderId} • ${DateFormat('dd MMM, HH:mm').format(p.timestamp)}',
                              style: AppTypography.labelSmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${p.isCredit ? '+' : ''}${currency.format(p.amount)}',
                        style: TextStyle(
                          color: p.isCredit ? AppColors.onlineGreen : AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

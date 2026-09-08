import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/order_item.dart';
import '../../state/rider_scope.dart';
import '../../widgets/order_item_detail_sheet.dart';

class AgentOrderTrackingScreen extends StatelessWidget {
  const AgentOrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = RiderScope.of(context);
    final basket = state.shoppingBasket;
    final currency = NumberFormat.currency(locale: 'en_NG', symbol: '₦ ', decimalDigits: 0);

    final purchasedCount = basket.where((i) => i.status == ItemStatus.purchased || i.status == ItemStatus.increaseApproved).length;
    final totalItems = basket.length;
    final totalBudget = basket.fold<double>(0, (sum, i) => sum + (i.marketPrice ?? i.budgetPrice));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Shopping Order'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Connected to Customer Live Chat')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Market and Progress Header
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Wuse Market, Abuja', style: AppTypography.headlineMedium),
                        const SizedBox(height: 2),
                        Text(
                          '$totalItems Items • ${currency.format(totalBudget)}',
                          style: AppTypography.bodyMedium,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        '$purchasedCount of $totalItems Done',
                        style: const TextStyle(
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Shopping Stepper
                _buildStepper(),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.cardBorder),

          // Items List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: basket.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = basket[index];
                return _buildItemCard(context, item, state, currency);
              },
            ),
          ),

          // Bottom Handoff Bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.cardBorder)),
            ),
            child: SafeArea(
              top: false,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.onlineGreen,
                      content: Text('✓ Shopping Complete! Handed over to Gadaride delivery rider.'),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Complete Handoff to Rider ✓'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      children: [
        _stepNode('Assigned', isDone: true),
        _stepLine(isDone: true),
        _stepNode('Shopping', isCurrent: true),
        _stepLine(isDone: false),
        _stepNode('Handoff', isDone: false),
      ],
    );
  }

  Widget _stepNode(String label, {bool isDone = false, bool isCurrent = false}) {
    Color color = AppColors.surfaceLight;
    if (isDone) color = AppColors.onlineGreen;
    if (isCurrent) color = AppColors.primary;

    return Column(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isCurrent || isDone ? AppColors.textPrimary : AppColors.textTertiary,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _stepLine({required bool isDone}) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 16, left: 4, right: 4),
        color: isDone ? AppColors.onlineGreen : AppColors.cardBorder,
      ),
    );
  }

  Widget _buildItemCard(
    BuildContext context,
    OrderItem item,
    dynamic state,
    NumberFormat currency,
  ) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => OrderItemDetailSheet(
            item: item,
            onMarkPurchased: (id) => state.markItemPurchased(id),
            onRequestPriceIncrease: (id, price) => state.requestPriceIncrease(id, price),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: item.status == ItemStatus.purchased || item.status == ItemStatus.increaseApproved
                ? AppColors.onlineGreen.withValues(alpha: 0.3)
                : AppColors.cardBorder,
          ),
        ),
        child: Row(
          children: [
            // Checkbox indicator
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: item.status == ItemStatus.purchased || item.status == ItemStatus.increaseApproved
                    ? AppColors.onlineGreen
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: item.status == ItemStatus.purchased || item.status == ItemStatus.increaseApproved
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: AppTypography.titleMedium),
                  const SizedBox(height: 2),
                  Text(item.quantityDescription, style: AppTypography.bodyMedium),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        currency.format(item.marketPrice ?? item.budgetPrice),
                        style: TextStyle(
                          color: item.priceDifference > 0 ? AppColors.warning : AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      if (item.priceDifference > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.warningBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '+${currency.format(item.priceDifference)}',
                            style: const TextStyle(
                              color: AppColors.warning,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
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

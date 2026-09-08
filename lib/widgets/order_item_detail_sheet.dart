import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/order_item.dart';

class OrderItemDetailSheet extends StatefulWidget {
  final OrderItem item;
  final Function(String itemId) onMarkPurchased;
  final Function(String itemId, double newPrice) onRequestPriceIncrease;

  const OrderItemDetailSheet({
    super.key,
    required this.item,
    required this.onMarkPurchased,
    required this.onRequestPriceIncrease,
  });

  @override
  State<OrderItemDetailSheet> createState() => _OrderItemDetailSheetState();
}

class _OrderItemDetailSheetState extends State<OrderItemDetailSheet> {
  late TextEditingController _priceController;
  bool _isRequestingIncrease = false;

  @override
  void initState() {
    super.initState();
    final initialPrice = widget.item.marketPrice ?? widget.item.budgetPrice;
    _priceController =
        TextEditingController(text: initialPrice.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currency =
        NumberFormat.currency(locale: 'en_NG', symbol: '₦ ', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: AppColors.cardBorder, width: 1.5)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title and Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.item.title, style: AppTypography.headlineMedium),
                        const SizedBox(height: 4),
                        Text(
                          widget.item.quantityDescription,
                          style: AppTypography.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(widget.item.status),
                ],
              ),
              const SizedBox(height: 18),

              // Budget vs Market Comparison
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('CUSTOMER BUDGET',
                              style: AppTypography.labelSmall),
                          const SizedBox(height: 4),
                          Text(
                            currency.format(widget.item.budgetPrice),
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppColors.cardBorder,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('MARKET PRICE',
                              style: AppTypography.labelSmall),
                          const SizedBox(height: 4),
                          Text(
                            currency.format(widget.item.marketPrice ??
                                widget.item.budgetPrice),
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 18,
                              color: widget.item.priceDifference > 0
                                  ? AppColors.warning
                                  : AppColors.onlineGreen,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (widget.item.customerNote != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          size: 18, color: AppColors.primaryLight),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.item.customerNote!,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              if (widget.item.substitutionTags.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Accepted Substitutions',
                    style: AppTypography.labelSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.item.substitutionTags.map((sub) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.chipBackground,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.chipBorder),
                      ),
                      child: Text(
                        '✓ $sub',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 20),

              if (_isRequestingIncrease) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enter Current Market Price (₦)',
                        style: AppTypography.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'e.g. 4500',
                          prefixText: '₦ ',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  setState(() => _isRequestingIncrease = false),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                final entered =
                                    double.tryParse(_priceController.text);
                                if (entered != null && entered > 0) {
                                  widget.onRequestPriceIncrease(
                                      widget.item.id, entered);
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Send Request'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            setState(() => _isRequestingIncrease = true),
                        child: const Text('Price Increase'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onMarkPurchased(widget.item.id);
                          Navigator.pop(context);
                        },
                        child: const Text('Mark Purchased ✓'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ItemStatus status) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case ItemStatus.purchased:
        bg = AppColors.successBg;
        fg = AppColors.onlineGreen;
        label = 'Purchased';
        break;
      case ItemStatus.increaseApproved:
        bg = AppColors.successBg;
        fg = AppColors.onlineGreen;
        label = 'Approved';
        break;
      case ItemStatus.awaitingApproval:
        bg = AppColors.infoBg;
        fg = AppColors.info;
        label = 'Awaiting Approval';
        break;
      case ItemStatus.searching:
        bg = AppColors.warningBg;
        fg = AppColors.warning;
        label = 'Searching';
        break;
      case ItemStatus.pending:
        bg = AppColors.surfaceLight;
        fg = AppColors.textSecondary;
        label = 'Pending';
        break;
      case ItemStatus.cancelled:
        bg = AppColors.errorBg;
        fg = AppColors.error;
        label = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

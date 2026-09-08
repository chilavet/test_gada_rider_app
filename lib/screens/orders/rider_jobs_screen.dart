import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/delivery_job.dart';
import '../../state/rider_scope.dart';
import 'agent_order_tracking_screen.dart';
import 'delivery_map_screen.dart';

class RiderJobsScreen extends StatelessWidget {
  const RiderJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = RiderScope.of(context);
    final activeJob = state.activeJob;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders & Tasks'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Active Delivery Job Card
            if (activeJob != null && activeJob.status != JobStatus.delivered) ...[
              const Text('Active Delivery Job', style: AppTypography.headlineMedium),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(activeJob.orderNumber, style: AppTypography.headlineMedium),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            activeJob.status.name.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.primaryLight,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('Pickup: ${activeJob.pickupName}', style: AppTypography.bodyLarge),
                    Text('Dropoff: ${activeJob.dropoffName}', style: AppTypography.bodyMedium),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const DeliveryMapScreen()),
                        );
                      },
                      icon: const Icon(Icons.navigation_rounded, size: 18),
                      label: const Text('Open Active Route Map'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Market Shopping Tasks Card
            const Text('Market Agent Tasks', style: AppTypography.headlineMedium),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Wuse Market Shopping Basket',
                          style: AppTypography.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.onlineGreen.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${state.shoppingBasket.length} Items',
                          style: const TextStyle(
                            color: AppColors.onlineGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Review shopping checklist, price substitutions, and handoff items to riders.',
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surfaceLight,
                      foregroundColor: AppColors.textPrimary,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AgentOrderTrackingScreen()),
                      );
                    },
                    icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                    label: const Text('View Shopping Basket & Checklist'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Dispatch Simulator Action
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bolt_rounded, color: AppColors.primary),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Simulator Engine', style: AppTypography.titleMedium),
                        Text('Test order dispatch notifications', style: AppTypography.bodyMedium),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: state.simulateIncomingJob,
                    child: const Text('Trigger Alert'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 120 + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/delivery_job.dart';
import '../../state/rider_scope.dart';
import '../../widgets/interactive_map_canvas.dart';

class DeliveryMapScreen extends StatelessWidget {
  const DeliveryMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = RiderScope.of(context);
    final job = state.activeJob;

    if (job == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Delivery Route')),
        body: const Center(
          child: Text('No active delivery in progress', style: AppTypography.bodyLarge),
        ),
      );
    }

    double progress = 0.2;
    String actionLabel = 'Arrived at Pickup Store';
    String stageDescription = 'Heading to Wuse Market to collect package';

    switch (job.status) {
      case JobStatus.accepted:
      case JobStatus.enRouteToPickup:
        progress = 0.25;
        actionLabel = 'Arrived at Pickup Store';
        stageDescription = 'Heading to Wuse Market to collect package';
        break;
      case JobStatus.arrivedAtPickup:
        progress = 0.40;
        actionLabel = 'Confirm Items Picked Up';
        stageDescription = 'At Wuse Market • Collecting packed order';
        break;
      case JobStatus.orderPickedUp:
      case JobStatus.enRouteToDropoff:
        progress = 0.70;
        actionLabel = 'Confirm Delivery ✓';
        stageDescription = 'On the way to 12 Aminu Kano Crescent';
        break;
      case JobStatus.delivered:
        progress = 1.0;
        actionLabel = 'Delivery Complete';
        stageDescription = 'Order successfully delivered to customer!';
        break;
      default:
        break;
    }

    return Scaffold(
      body: Stack(
        children: [
          // 1. Live Map Canvas (Full Screen)
          Positioned.fill(
            child: InteractiveMapCanvas(
              progress: progress,
              pickupLabel: job.pickupName,
              dropoffLabel: job.dropoffName,
            ),
          ),

          // 2. Top Navigation Bar Overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            job.orderNumber,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.phone_rounded, color: AppColors.onlineGreen, size: 20),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Calling ${job.customerName} (${job.customerPhone})...')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Floating Bottom Delivery Card
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.cardBorder, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Stage Pill
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'STAGE: ${job.status.name.toUpperCase()}',
                            style: const TextStyle(
                              color: AppColors.primaryLight,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Text(
                          '${job.estimatedTimeMinutes} mins remaining',
                          style: AppTypography.labelSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Customer and Dropoff details
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: AppColors.surfaceLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person_rounded, color: AppColors.textPrimary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(job.customerName, style: AppTypography.titleMedium),
                              Text(
                                job.dropoffAddress,
                                style: AppTypography.bodyMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Text(
                      stageDescription,
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 16),

                    if (job.status == JobStatus.delivered) ...[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.onlineGreen,
                        ),
                        onPressed: () {
                          state.dismissCompletedJob();
                          Navigator.pop(context);
                        },
                        child: const Text('Back to Home Dashboard'),
                      ),
                    ] else ...[
                      ElevatedButton(
                        onPressed: () {
                          state.advanceJobStatus();
                          if (state.activeJob?.status == JobStatus.delivered) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppColors.onlineGreen,
                                content: Text('🎉 Delivery Confirmed! ₦${job.deliveryFee.toInt()} added to your wallet.'),
                              ),
                            );
                          }
                        },
                        child: Text(actionLabel),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

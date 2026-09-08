import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/navigation_launcher.dart';
import '../../models/delivery_job.dart';
import '../../state/rider_scope.dart';
import '../../widgets/gmp_live_map.dart';
import 'navigate_to_location_screen.dart';

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

    double progress = 0.25;
    String actionLabel = 'Arrived at Pickup Store';
    String stageDescription = 'Heading to ${job.pickupName} to collect package';

    switch (job.status) {
      case JobStatus.accepted:
      case JobStatus.enRouteToPickup:
        progress = 0.25;
        actionLabel = 'Arrived at Pickup Store';
        stageDescription = 'Heading to ${job.pickupName} to collect package';
        break;
      case JobStatus.arrivedAtPickup:
        progress = 0.45;
        actionLabel = 'Confirm Items Picked Up';
        stageDescription = 'At ${job.pickupName} • Collecting packed order';
        break;
      case JobStatus.orderPickedUp:
      case JobStatus.enRouteToDropoff:
        progress = 0.75;
        actionLabel = 'Confirm Delivery ✓';
        stageDescription = 'On the way to ${job.dropoffAddress}';
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
          // 1. Live Google Maps View (Full Screen with GPS Coordinates)
          Positioned.fill(
            child: GMPLiveMap(
              pickupLocation: LatLng(job.pickupLatitude, job.pickupLongitude),
              dropoffLocation: LatLng(job.dropoffLatitude, job.dropoffLongitude),
              pickupLabel: job.pickupName,
              dropoffLabel: job.dropoffName,
              progress: progress,
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
                        color: AppColors.getSurface(context).withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.getCardBorder(context)),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.getSurface(context).withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.getCardBorder(context)),
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
                            style: TextStyle(
                              color: AppColors.getTextPrimary(context),
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.getSurface(context).withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.getCardBorder(context)),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.phone_rounded, color: AppColors.onlineGreen, size: 20),
                        onPressed: () => NavigationLauncher.launchCall(job.customerPhone),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Floating Quick Actions (Figma 973:12383 Link & External GPS)
          Positioned(
            top: 76,
            right: 16,
            child: SafeArea(
              child: Column(
                children: [
                  FloatingActionButton.small(
                    heroTag: 'fab_stepper',
                    backgroundColor: AppColors.getSurface(context),
                    foregroundColor: AppColors.getTextPrimary(context),
                    tooltip: 'View Order Journey & Stepper',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NavigateToLocationScreen(job: job),
                        ),
                      );
                    },
                    child: const Icon(Icons.alt_route_rounded, size: 20),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.small(
                    heroTag: 'fab_external_gps',
                    backgroundColor: AppColors.darkCta,
                    foregroundColor: Colors.white,
                    tooltip: 'Open in External Google / Apple Maps',
                    onPressed: () {
                      NavigationLauncher.launchNavigation(
                        latitude: job.dropoffLatitude,
                        longitude: job.dropoffLongitude,
                        label: job.dropoffAddress,
                      );
                    },
                    child: const Icon(Icons.directions_rounded, size: 20),
                  ),
                ],
              ),
            ),
          ),

          // 4. Floating Bottom Delivery Card
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.getSurface(context),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.getCardBorder(context), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Stage Pill & ETA
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
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Text(
                          '${job.estimatedTimeMinutes} mins remaining',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.getTextSecondary(context),
                          ),
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
                          decoration: BoxDecoration(
                            color: AppColors.getSurfaceElevated(context),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person_rounded, color: AppColors.getTextPrimary(context)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job.customerName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                job.dropoffAddress,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.getTextSecondary(context),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Text(
                      stageDescription,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (job.status == JobStatus.delivered) ...[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.onlineGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          state.dismissCompletedJob();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Back to Home Dashboard',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ] else ...[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkCta,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
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
                        child: Text(
                          actionLabel,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                        ),
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

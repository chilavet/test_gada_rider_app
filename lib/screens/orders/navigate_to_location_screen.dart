import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/navigation_launcher.dart';
import '../../models/delivery_job.dart';
import '../../state/rider_scope.dart';
import '../../widgets/gmp_live_map.dart';

/// Screen implementing Figma Node 973:12383 ("Navigate to Location")
class NavigateToLocationScreen extends StatefulWidget {
  final DeliveryJob? job;

  const NavigateToLocationScreen({super.key, this.job});

  @override
  State<NavigateToLocationScreen> createState() => _NavigateToLocationScreenState();
}

class _NavigateToLocationScreenState extends State<NavigateToLocationScreen> {
  int _currentStep = 2; // 0: Placed, 1: Prepared, 2: En Route, 3: Delivered

  @override
  Widget build(BuildContext context) {
    final state = RiderScope.of(context);
    final activeJob = widget.job ?? state.activeJob;

    final merchantName = activeJob?.merchantName ?? 'Mama Nkechi’s Kitchen';
    final pickupAddress = activeJob?.pickupAddress ?? 'Plot 14, Garki 2 Market Complex, Abuja';
    final merchantPhone = activeJob?.merchantPhone ?? '0809 123 4567';
    final dropoffAddress = activeJob?.dropoffAddress ?? '12 Aminu Kano Crescent, Wuse 2, Abuja';
    final distanceKm = activeJob?.distanceKm ?? 4.2;
    final etaMins = activeJob?.estimatedTimeMinutes ?? 14;

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        title: const Text('Navigate to Location'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: 'Call Store',
            icon: const Icon(Icons.phone_outlined, color: AppColors.onlineGreen),
            onPressed: () => NavigationLauncher.launchCall(merchantPhone),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Merchant Details Card (Figma 973:12527)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.getSurface(context),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.getCardBorder(context)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(
                            child: Text('🍲', style: TextStyle(fontSize: 26)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                merchantName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 14, color: AppColors.primary),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      pickupAddress,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.getTextSecondary(context),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.phone_rounded, size: 15, color: AppColors.onlineGreen),
                            const SizedBox(width: 6),
                            Text(
                              merchantPhone,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => NavigationLauncher.launchCall(merchantPhone),
                          icon: const Icon(Icons.call, size: 14, color: AppColors.onlineGreen),
                          label: const Text('Call Store', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 2. 4-Step Route Journey Stepper (Figma 995:15219)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.getSurface(context),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.getCardBorder(context)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _stepperItem(0, 'Placed', '10:15 AM', Icons.receipt_long_rounded),
                    _stepperLine(0),
                    _stepperItem(1, 'Prepared', '10:22 AM', Icons.soup_kitchen_rounded),
                    _stepperLine(1),
                    _stepperItem(2, 'On Way', 'Now', Icons.two_wheeler_rounded),
                    _stepperLine(2),
                    _stepperItem(3, 'Delivered', 'ETA 14m', Icons.check_circle_outline_rounded),
                  ],
                ),
              ),
            ),

            // 3. Google Maps Live Preview Box (Figma 973:12590)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Container(
                height: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.getCardBorder(context)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    GMPLiveMap(
                      pickupLocation: LatLng(
                        activeJob?.pickupLatitude ?? AppConstants.wuseMarketLat,
                        activeJob?.pickupLongitude ?? AppConstants.wuseMarketLng,
                      ),
                      dropoffLocation: LatLng(
                        activeJob?.dropoffLatitude ?? AppConstants.aminuKanoLat,
                        activeJob?.dropoffLongitude ?? AppConstants.aminuKanoLng,
                      ),
                      pickupLabel: merchantName,
                      dropoffLabel: dropoffAddress,
                      progress: 0.55,
                    ),

                    // Travel Info Overlay Pill (Figma 973:12594)
                    Positioned(
                      left: 14,
                      bottom: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.darkCta.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.two_wheeler_rounded, size: 20, color: AppColors.primary),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$etaMins mins',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  '$distanceKm km away',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 4. "On the Way" Destination Indicator (Figma 973:12623)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.getSurface(context),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.getCardBorder(context)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.navigation_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Heading to Dropoff',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            dropoffAddress,
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
              ),
            ),

            // 5. Native GPS Navigation Launch Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        NavigationLauncher.launchNavigation(
                          latitude: activeJob?.dropoffLatitude ?? AppConstants.aminuKanoLat,
                          longitude: activeJob?.dropoffLongitude ?? AppConstants.aminuKanoLng,
                          label: dropoffAddress,
                        );
                      },
                      icon: const Icon(Icons.map_rounded, size: 18),
                      label: const Text('Open External GPS'),
                    ),
                  ),
                ],
              ),
            ),

            // 6. Action Button (Figma 973:12634)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkCta,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    if (_currentStep < 3) {
                      _currentStep++;
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_currentStep == 3
                          ? 'Order delivered successfully!'
                          : 'Order progress advanced to step $_currentStep'),
                    ),
                  );
                },
                child: Text(
                  _currentStep == 2 ? 'Confirm Arrival at Dropoff' : 'Complete Delivery ✓',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepperItem(int index, String title, String subtitle, IconData icon) {
    final isDone = index < _currentStep;
    final isActive = index == _currentStep;

    Color bg;
    Color iconColor;
    if (isDone) {
      bg = AppColors.onlineGreen;
      iconColor = Colors.white;
    } else if (isActive) {
      bg = AppColors.primary;
      iconColor = Colors.white;
    } else {
      bg = AppColors.surfaceLight;
      iconColor = AppColors.textSecondary;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isDone ? Icons.check_rounded : icon,
            size: 18,
            color: iconColor,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
            color: isActive ? AppColors.primary : AppColors.getTextPrimary(context),
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 9,
            color: AppColors.getTextSecondary(context),
          ),
        ),
      ],
    );
  }

  Widget _stepperLine(int beforeIndex) {
    final isDone = beforeIndex < _currentStep;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 24),
        color: isDone ? AppColors.onlineGreen : AppColors.getCardBorder(context),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/delivery_job.dart';
import '../../state/rider_scope.dart';
import '../../widgets/gada_logo.dart';
import '../../widgets/status_indicator_pill.dart';
import '../../widgets/metric_card.dart';
import '../../widgets/job_alert_sheet.dart';
import '../orders/delivery_map_screen.dart';

class RiderHomeScreen extends StatelessWidget {
  const RiderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = RiderScope.of(context);
    final stats = state.stats;
    final currency = NumberFormat.currency(locale: 'en_NG', symbol: '₦ ', decimalDigits: 0);

    // If there is an incoming alert, show sheet automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.hasIncomingAlert && state.activeJob != null) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) => JobAlertSheet(
            job: state.activeJob!,
            onAccept: () {
              Navigator.pop(ctx);
              state.acceptJob();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DeliveryMapScreen()),
              );
            },
            onDecline: () {
              Navigator.pop(ctx);
              state.declineJob();
            },
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(child: GadaLogo()),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.textPrimary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryContainer,
                          border: Border.all(color: AppColors.primary, width: 1.5),
                        ),
                        child: const Center(
                          child: Text(
                            'TG',
                            style: TextStyle(
                              color: AppColors.primaryLight,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Dual-Role Segmented Selector [ Rider | Agent ]
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => state.switchRole('Rider'),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: state.activeRole == 'Rider'
                                ? AppColors.surfaceLight
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delivery_dining_rounded,
                                size: 18,
                                color: state.activeRole == 'Rider'
                                    ? AppColors.primary
                                    : AppColors.textTertiary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Rider Mode',
                                style: TextStyle(
                                  color: state.activeRole == 'Rider'
                                      ? AppColors.textPrimary
                                      : AppColors.textTertiary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => state.switchRole('Agent'),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: state.activeRole == 'Agent'
                                ? AppColors.surfaceLight
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_basket_rounded,
                                size: 18,
                                color: state.activeRole == 'Agent'
                                    ? AppColors.primary
                                    : AppColors.textTertiary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Market Agent',
                                style: TextStyle(
                                  color: state.activeRole == 'Agent'
                                      ? AppColors.textPrimary
                                      : AppColors.textTertiary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Availability & Dispatch Control Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      state.isOnline
                          ? const Color(0xFF1B2A22)
                          : AppColors.surface,
                      AppColors.surface,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: state.isOnline
                        ? AppColors.onlineGreen.withValues(alpha: 0.35)
                        : AppColors.cardBorder,
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatusIndicatorPill(
                          isOnline: state.isOnline,
                          onTap: state.toggleOnline,
                        ),
                        Switch.adaptive(
                          value: state.isOnline,
                          activeThumbColor: AppColors.onlineGreen,
                          onChanged: (_) => state.toggleOnline(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (state.activeJob != null &&
                        state.activeJob!.status != JobStatus.incomingAlert &&
                        state.activeJob!.status != JobStatus.delivered) ...[
                      // Active order banner
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'ACTIVE DELIVERY IN PROGRESS',
                                  style: TextStyle(
                                    color: AppColors.primaryLight,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  state.activeJob!.orderNumber,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Dropoff: ${state.activeJob!.dropoffName}',
                              style: AppTypography.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const DeliveryMapScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.navigation_rounded, size: 18),
                              label: const Text('Open Active Route Map'),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Text(
                        state.isOnline
                            ? 'Looking for nearby delivery orders...'
                            : 'Go online to start receiving delivery requests',
                        style: AppTypography.bodyLarge,
                      ),
                      const SizedBox(height: 14),
                      // Simulate Incoming Job Button
                      OutlinedButton.icon(
                        onPressed: state.simulateIncomingJob,
                        icon: const Icon(Icons.bolt_rounded, color: AppColors.primary),
                        label: const Text('Simulate Incoming Job Alert'),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Today's Performance Metrics Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      "Today's Activity",
                      style: AppTypography.headlineMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('EEE, d MMM').format(DateTime.now()),
                    style: AppTypography.labelSmall,
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 2x2 Metrics Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  MetricCard(
                    title: 'EARNINGS',
                    value: currency.format(stats.todayEarnings),
                    subtitle: '+₦1,850 vs yesterday',
                    icon: Icons.account_balance_wallet_rounded,
                    accentColor: AppColors.primary,
                  ),
                  MetricCard(
                    title: 'COMPLETED TRIPS',
                    value: '${stats.todayTrips}',
                    subtitle: '100% acceptance',
                    icon: Icons.check_circle_rounded,
                    accentColor: AppColors.onlineGreen,
                  ),
                  MetricCard(
                    title: 'DISTANCE COVERED',
                    value: '${stats.todayDistanceKm.toStringAsFixed(1)} km',
                    subtitle: 'Avg 1.1 km/trip',
                    icon: Icons.speed_rounded,
                    accentColor: AppColors.info,
                  ),
                  MetricCard(
                    title: 'ONLINE HOURS',
                    value: stats.todayActiveHours,
                    subtitle: 'Active now',
                    icon: Icons.timer_outlined,
                    accentColor: AppColors.warning,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Quick Actions
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.verified_user_rounded,
                        color: AppColors.primaryLight,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('KYC Verification Active', style: AppTypography.titleMedium),
                          Text('All delivery and wallet tiers verified', style: AppTypography.bodyMedium),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

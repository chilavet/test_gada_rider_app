import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../models/delivery_job.dart';
import '../../state/rider_scope.dart';
import '../../widgets/gada_logo.dart';
import '../../widgets/job_alert_sheet.dart';
import '../notifications/notifications_screen.dart';
import '../orders/delivery_map_screen.dart';
import '../orders/navigate_to_location_screen.dart';

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
      backgroundColor: AppColors.getBackground(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar: Gada Logo & Night/Day Toggle + Notification Bell (Figma 805:11391)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(child: GadaLogo(size: 26)),
                  Row(
                    children: [
                      // Quick Night / Day Mode Toggle Button
                      GestureDetector(
                        onTap: () => state.toggleNightMode(),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.getSurface(context),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.getCardBorder(context)),
                          ),
                          child: Icon(
                            state.isNightMode
                                ? Icons.wb_sunny_rounded
                                : Icons.nightlight_round,
                            color: state.isNightMode
                                ? const Color(0xFFF59E0B)
                                : AppColors.getTextPrimary(context),
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Notification Bell Button with Unread Badge
                      GestureDetector(
                        key: const Key('notification_bell_button'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const NotificationsScreen(),
                            ),
                          );
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.getSurface(context),
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.getCardBorder(context)),
                              ),
                              child: Icon(
                                state.unreadNotificationCount > 0
                                    ? Icons.notifications_active_rounded
                                    : Icons.notifications_none_rounded,
                                color: state.unreadNotificationCount > 0
                                    ? AppColors.primary
                                    : AppColors.getTextPrimary(context),
                                size: 22,
                              ),
                            ),
                            if (state.unreadNotificationCount > 0)
                              Positioned(
                                top: -2,
                                right: -2,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                  constraints: const BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.getSurface(context),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.4),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${state.unreadNotificationCount > 9 ? '9+' : state.unreadNotificationCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Greeting & Avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good morning, Daniel',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Are you ready for your next delivery?',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE8DCC4),
                      border: Border.all(color: AppColors.cardBorder, width: 2),
                    ),
                    child: const Center(
                      child: Text('🧔‍♂️', style: TextStyle(fontSize: 28)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Segmented Role Switch [ Rider | Agent ]
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBECEF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => state.switchRole('Rider'),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          decoration: BoxDecoration(
                            color: state.activeRole == 'Rider'
                                ? AppColors.darkCta
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Rider',
                              style: TextStyle(
                                color: state.activeRole == 'Rider'
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => state.switchRole('Agent'),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          decoration: BoxDecoration(
                            color: state.activeRole == 'Agent'
                                ? AppColors.darkCta
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Agent',
                              style: TextStyle(
                                color: state.activeRole == 'Agent'
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Status Card (Black card matching Figma)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.darkCta,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'You are',
                            style: TextStyle(
                              color: Color(0xFFB0B0B0),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: state.isOnline
                                      ? AppColors.onlineGreen
                                      : AppColors.offlineGray,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                state.isOnline ? 'Online' : 'Offline',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'You must be online to receive jobs',
                            style: TextStyle(
                              color: Color(0xFF8E8E93),
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // High-contrast toggle switch
                    Switch.adaptive(
                      value: state.isOnline,
                      activeThumbColor: Colors.black,
                      activeTrackColor: Colors.white,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: const Color(0xFF48484A),
                      onChanged: (_) => state.toggleOnline(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Current Status Card (White border card)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.textTertiary,
                              style: BorderStyle.solid,
                              width: 1.5,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.access_time_rounded,
                              size: 24,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Current status',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                state.activeJob != null &&
                                        state.activeJob!.status != JobStatus.delivered &&
                                        state.activeJob!.status != JobStatus.incomingAlert
                                    ? 'Active Delivery: ${state.activeJob!.dropoffName}'
                                    : 'Waiting for jobs',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                state.activeJob != null &&
                                        state.activeJob!.status != JobStatus.delivered &&
                                        state.activeJob!.status != JobStatus.incomingAlert
                                    ? 'Tap below to navigate the route'
                                    : "We'll notify you when a job is available",
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (state.activeJob != null &&
                        state.activeJob!.status != JobStatus.delivered &&
                        state.activeJob!.status != JobStatus.incomingAlert) ...[
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const DeliveryMapScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.navigation_rounded, size: 18),
                              label: const Text('Live Route Map'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.outlined(
                            tooltip: 'View Order Journey & Stepper (Figma 973:12383)',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const NavigateToLocationScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.alt_route_rounded),
                          ),
                        ],
                      ),
                    ] else ...[
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

              // Section Header: Today's activities
              const Text(
                "Today's activities",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),

              // 2x2 Activity Grid matching Figma
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.15,
                children: [
                  _activityCard(
                    icon: Icons.account_balance_wallet_outlined,
                    title: "Today's earnings",
                    value: currency.format(stats.todayEarnings),
                  ),
                  _activityCard(
                    icon: Icons.route_outlined,
                    title: 'Trips completed',
                    value: '${stats.todayTrips}',
                  ),
                  _activityCard(
                    icon: Icons.alt_route_rounded,
                    title: 'Distance covered',
                    value: '${stats.todayDistanceKm.toInt()}',
                  ),
                  _activityCard(
                    icon: Icons.access_time_outlined,
                    title: 'Active hours',
                    value: stats.todayActiveHours,
                  ),
                ],
              ),
              SizedBox(height: 120 + MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  Widget _activityCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F1F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

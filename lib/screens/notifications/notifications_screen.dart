import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/notification_item.dart';
import '../../state/rider_scope.dart';
import '../earnings/rider_earnings_screen.dart';
import '../orders/rider_jobs_screen.dart';
import '../profile/user_profile_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All'; // 'All', 'Orders', 'Payouts', 'System'

  @override
  Widget build(BuildContext context) {
    final state = RiderScope.of(context);
    final notifications = state.notifications;
    final unreadCount = state.unreadNotificationCount;

    // Filter notifications according to the active tab
    final filteredNotifications = notifications.where((n) {
      if (_selectedFilter == 'Orders') return n.type == NotificationType.order;
      if (_selectedFilter == 'Payouts') return n.type == NotificationType.payout;
      if (_selectedFilter == 'System') {
        return n.type == NotificationType.system || n.type == NotificationType.kyc;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: AppColors.getSurface(context),
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AppColors.getTextPrimary(context),
          ),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.getTextPrimary(context),
                fontWeight: FontWeight.w700,
              ),
            ),
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$unreadCount new',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (notifications.isNotEmpty)
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert_rounded,
                color: AppColors.getTextPrimary(context),
              ),
              color: AppColors.getSurface(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: AppColors.getCardBorder(context)),
              ),
              onSelected: (value) {
                if (value == 'mark_read') {
                  state.markAllNotificationsAsRead();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All notifications marked as read'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else if (value == 'clear_all') {
                  _showClearAllDialog(context, state);
                }
              },
              itemBuilder: (context) => [
                if (unreadCount > 0)
                  const PopupMenuItem(
                    value: 'mark_read',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.done_all_rounded, size: 18, color: AppColors.primary),
                        SizedBox(width: 8),
                        Text('Mark all read', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'clear_all',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete_sweep_outlined, size: 18, color: AppColors.error),
                      SizedBox(width: 8),
                      Text('Clear all', style: TextStyle(fontSize: 14, color: AppColors.error)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips Section
          _buildFilterTabs(context, notifications),

          // Notifications List or Empty State
          Expanded(
            child: filteredNotifications.isEmpty
                ? _buildEmptyState(context)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: filteredNotifications.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = filteredNotifications[index];
                      return _buildNotificationCard(context, item, state);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(BuildContext context, List<NotificationItem> all) {
    final orderCount = all.where((n) => n.type == NotificationType.order).length;
    final payoutCount = all.where((n) => n.type == NotificationType.payout).length;
    final systemCount = all.where((n) => n.type == NotificationType.system || n.type == NotificationType.kyc).length;

    final filters = [
      {'label': 'All', 'count': all.length},
      {'label': 'Orders', 'count': orderCount},
      {'label': 'Payouts', 'count': payoutCount},
      {'label': 'System', 'count': systemCount},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        border: Border(
          bottom: BorderSide(color: AppColors.getCardBorder(context)),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((f) {
            final label = f['label'] as String;
            final count = f['count'] as int;
            final isSelected = _selectedFilter == label;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => setState(() => _selectedFilter = label),
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.getSurfaceElevated(context),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.getCardBorder(context),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : AppColors.getTextPrimary(context),
                        ),
                      ),
                      if (count > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.25)
                                : AppColors.getCardBorder(context),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$count',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.getTextSecondary(context),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationItem item,
    dynamic state,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
      ),
      onDismissed: (_) {
        state.deleteNotification(item.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notification dismissed'),
            action: SnackBarAction(
              label: 'Undo',
              textColor: AppColors.primary,
              onPressed: () => state.addNotification(item),
            ),
          ),
        );
      },
      child: InkWell(
        onTap: () {
          if (!item.isRead) {
            state.markNotificationAsRead(item.id);
          }
          if (item.actionTarget != null) {
            _handleNotificationAction(context, item.actionTarget!);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: item.isRead
                ? AppColors.getSurface(context)
                : (isDark
                    ? const Color(0xFF1E1A18)
                    : const Color(0xFFFFF8F3)),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: item.isRead
                  ? AppColors.getCardBorder(context)
                  : AppColors.primary.withValues(alpha: 0.4),
              width: item.isRead ? 1 : 1.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Category Icon
              _buildTypeIcon(item.type),
              const SizedBox(width: 12),

              // Notification Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Type chip + Timestamp + Unread Dot
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getTypeLabel(item.type),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                            color: _getTypeColor(item.type),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              item.timeAgo,
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.getTextTertiary(context),
                              ),
                            ),
                            if (!item.isRead) ...[
                              const SizedBox(width: 6),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // Notification Title
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w700,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Notification Message
                    Text(
                      item.message,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: AppColors.getTextSecondary(context),
                      ),
                    ),

                    // Action Button (if any)
                    if (item.actionLabel != null) ...[
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          state.markNotificationAsRead(item.id);
                          _handleNotificationAction(context, item.actionTarget!);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item.actionLabel!,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 14,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon(NotificationType type) {
    IconData icon;
    Color color;
    Color bg;

    switch (type) {
      case NotificationType.order:
        icon = Icons.moped_rounded;
        color = AppColors.primary;
        bg = AppColors.primary.withValues(alpha: 0.15);
        break;
      case NotificationType.payout:
        icon = Icons.account_balance_wallet_rounded;
        color = AppColors.success;
        bg = AppColors.success.withValues(alpha: 0.15);
        break;
      case NotificationType.kyc:
        icon = Icons.verified_user_rounded;
        color = const Color(0xFFF59E0B);
        bg = const Color(0xFFF59E0B).withValues(alpha: 0.15);
        break;
      case NotificationType.system:
        icon = Icons.notifications_active_rounded;
        color = const Color(0xFF3B82F6);
        bg = const Color(0xFF3B82F6).withValues(alpha: 0.15);
        break;
    }

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }

  String _getTypeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return 'ORDER DISPATCH';
      case NotificationType.payout:
        return 'WALLET & PAYOUT';
      case NotificationType.kyc:
        return 'ACCOUNT VERIFIED';
      case NotificationType.system:
        return 'SYSTEM & PROMO';
    }
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return AppColors.primary;
      case NotificationType.payout:
        return AppColors.success;
      case NotificationType.kyc:
        return const Color(0xFFF59E0B);
      case NotificationType.system:
        return const Color(0xFF3B82F6);
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.getSurfaceElevated(context),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.getCardBorder(context)),
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                size: 38,
                color: AppColors.getTextTertiary(context),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'No Notifications',
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.getTextPrimary(context),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You are all caught up! Orders, earnings updates, and system announcements will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.getTextSecondary(context),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNotificationAction(BuildContext context, String target) {
    if (target == 'job') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const RiderJobsScreen()),
      );
    } else if (target == 'earnings') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const RiderEarningsScreen()),
      );
    } else if (target == 'profile') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const UserProfileScreen()),
      );
    }
  }

  void _showClearAllDialog(BuildContext context, dynamic state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.getSurface(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Clear all notifications?',
          style: TextStyle(
            color: AppColors.getTextPrimary(context),
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'This will remove all notification records from your history. This action cannot be undone.',
          style: TextStyle(
            color: AppColors.getTextSecondary(context),
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.getTextSecondary(context)),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              state.clearAllNotifications();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications cleared')),
              );
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

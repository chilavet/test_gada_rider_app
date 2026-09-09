import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_gada_rider_app/models/notification_item.dart';
import 'package:test_gada_rider_app/screens/home/rider_home_screen.dart';
import 'package:test_gada_rider_app/screens/notifications/notifications_screen.dart';
import 'package:test_gada_rider_app/state/rider_scope.dart';
import 'package:test_gada_rider_app/state/rider_state.dart';

void main() {
  group('Notifications System Tests', () {
    late RiderState riderState;

    setUp(() {
      riderState = RiderState();
    });

    Widget createTestWidget({Widget? child}) {
      return RiderScope(
        state: riderState,
        child: MaterialApp(
          home: child ?? const RiderHomeScreen(),
        ),
      );
    }

    test('RiderState initializes with default notifications and unread count', () {
      expect(riderState.notifications.isNotEmpty, true);
      expect(riderState.unreadNotificationCount, greaterThan(0));

      final initialUnread = riderState.unreadNotificationCount;
      final firstUnread = riderState.notifications.firstWhere((n) => !n.isRead);

      // Mark single notification as read
      riderState.markNotificationAsRead(firstUnread.id);
      expect(riderState.unreadNotificationCount, equals(initialUnread - 1));

      // Mark all as read
      riderState.markAllNotificationsAsRead();
      expect(riderState.unreadNotificationCount, equals(0));
    });

    test('RiderState simulateIncomingJob adds a dynamic notification', () {
      final initialCount = riderState.notifications.length;
      final initialUnread = riderState.unreadNotificationCount;

      riderState.simulateIncomingJob();

      expect(riderState.notifications.length, equals(initialCount + 1));
      expect(riderState.unreadNotificationCount, equals(initialUnread + 1));
      expect(riderState.notifications.first.type, equals(NotificationType.order));
    });

    testWidgets('RiderHomeScreen renders notification bell with unread badge and opens NotificationsScreen', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify the notification bell button is rendered
      final bellButton = find.byKey(const Key('notification_bell_button'));
      expect(bellButton, findsOneWidget);

      // Verify badge text displays unread count
      final unreadCount = riderState.unreadNotificationCount;
      expect(
        find.descendant(of: bellButton, matching: find.text('$unreadCount')),
        findsOneWidget,
      );

      // Tap on the notification bell button
      await tester.tap(bellButton);
      await tester.pumpAndSettle();

      // Verify NotificationsScreen is displayed
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('$unreadCount new'), findsOneWidget);

      // Verify filter tabs exist
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Orders'), findsOneWidget);
      expect(find.text('Payouts'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);
    });

    testWidgets('NotificationsScreen filters by category and handles mark all as read', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestWidget(child: const NotificationsScreen()));
      await tester.pumpAndSettle();

      // Verify initial notifications title and presence
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('New Order Dispatch Alert'), findsOneWidget);

      // Tap Orders filter
      await tester.tap(find.text('Orders'));
      await tester.pumpAndSettle();
      expect(find.text('New Order Dispatch Alert'), findsOneWidget);

      // Tap Payouts filter
      await tester.tap(find.text('Payouts'));
      await tester.pumpAndSettle();
      expect(find.text('Payout Credited to Wallet'), findsOneWidget);
      expect(find.text('New Order Dispatch Alert'), findsNothing);

      // Open popup menu and select Mark all as read
      await tester.tap(find.byIcon(Icons.more_vert_rounded));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Mark all read'));
      await tester.pumpAndSettle();

      // Verify unread count is 0
      expect(riderState.unreadNotificationCount, equals(0));
    });

    testWidgets('NotificationsScreen clears all notifications and shows empty state', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestWidget(child: const NotificationsScreen()));
      await tester.pumpAndSettle();

      // Open popup menu and choose Clear all
      await tester.tap(find.byIcon(Icons.more_vert_rounded));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Clear all'));
      await tester.pumpAndSettle();

      // Confirm in dialog
      expect(find.text('Clear all notifications?'), findsOneWidget);
      await tester.tap(find.text('Clear All'));
      await tester.pumpAndSettle();

      // Verify empty state is displayed
      expect(find.text('No Notifications'), findsOneWidget);
      expect(riderState.notifications, isEmpty);
    });
  });
}

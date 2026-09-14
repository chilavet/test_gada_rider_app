import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_gada_rider_app/core/constants/app_constants.dart';
import 'package:test_gada_rider_app/core/theme/app_theme.dart';
import 'package:test_gada_rider_app/models/delivery_job.dart';
import 'package:test_gada_rider_app/screens/orders/delivery_map_screen.dart';
import 'package:test_gada_rider_app/screens/orders/navigate_to_location_screen.dart';
import 'package:test_gada_rider_app/state/rider_scope.dart';
import 'package:test_gada_rider_app/state/rider_state.dart';
import 'package:test_gada_rider_app/widgets/gmp_live_map.dart';
import 'package:test_gada_rider_app/widgets/interactive_map_canvas.dart';

void main() {
  test('DeliveryJob model contains GPS coordinates and merchant info', () {
    final job = DeliveryJob(
      id: 'job-1',
      orderNumber: '#ORD-3928',
      pickupName: 'Wuse Market',
      pickupAddress: 'Wuse Market Section B, Abuja',
      dropoffName: '12 Aminu Kano Cres',
      dropoffAddress: '12 Aminu Kano Crescent, Wuse 2, Abuja',
      distanceKm: 3.4,
      estimatedTimeMinutes: 12,
      deliveryFee: 1500,
      itemsTotal: 12000,
      itemCount: 4,
      customerName: 'Fatima Bello',
      customerPhone: '08023456789',
      pickupLatitude: AppConstants.wuseMarketLat,
      pickupLongitude: AppConstants.wuseMarketLng,
      dropoffLatitude: AppConstants.aminuKanoLat,
      dropoffLongitude: AppConstants.aminuKanoLng,
      merchantName: 'Mama Nkechi’s Kitchen',
      merchantPhone: '08091234567',
      createdAt: DateTime.now(),
    );

    expect(job.pickupLatitude, equals(AppConstants.wuseMarketLat));
    expect(job.pickupLongitude, equals(AppConstants.wuseMarketLng));
    expect(job.merchantName, equals('Mama Nkechi’s Kitchen'));
  });

  testWidgets('NavigateToLocationScreen renders merchant card, stepper, and action button', (tester) async {
    final state = RiderState();

    await tester.pumpWidget(
      RiderScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const NavigateToLocationScreen(),
        ),
      ),
    );

    // Header & Merchant details (Figma 973:12383)
    expect(find.text('Navigate to Location'), findsOneWidget);
    expect(find.text('Mama Nkechi’s Kitchen'), findsOneWidget);
    expect(find.text('Call Store'), findsOneWidget);

    // 4-step Stepper
    expect(find.text('Placed'), findsOneWidget);
    expect(find.text('Prepared'), findsOneWidget);
    expect(find.text('On Way'), findsOneWidget);
    expect(find.text('Delivered'), findsOneWidget);

    // External GPS action
    expect(find.text('Open External GPS'), findsOneWidget);

    // Scroll down to action button
    await tester.scrollUntilVisible(
      find.text('Confirm Arrival at Dropoff'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    // Action button
    expect(find.text('Confirm Arrival at Dropoff'), findsOneWidget);

    // Tap to advance stepper
    await tester.tap(find.text('Confirm Arrival at Dropoff'));
    await tester.pumpAndSettle();

    expect(find.text('Complete Delivery ✓'), findsOneWidget);
  });

  testWidgets('DeliveryMapScreen displays order number, customer phone, and stage actions', (tester) async {
    final state = RiderState();
    state.simulateIncomingJob();
    state.acceptJob();

    await tester.pumpWidget(
      RiderScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const DeliveryMapScreen(),
        ),
      ),
    );

    // Top order bar
    expect(find.text('#GDA-8921'), findsOneWidget);

    // Delivery details
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Arrived at Pickup Store'), findsOneWidget);
  });

  testWidgets('GMPLiveMap renders GoogleMap on supported mobile platform', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 600,
            child: GMPLiveMap(
              pickupLabel: 'Wuse Market Section B',
              dropoffLabel: 'Plot 12 Aminu Kano',
              progress: 0.65,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(GMPLiveMap), findsOneWidget);
    expect(find.byType(GoogleMap), findsOneWidget);
    expect(find.text('Abuja Live GPS'), findsOneWidget);
  });

  testWidgets('GMPLiveMap gracefully renders InteractiveMapCanvas when forceCanvas is true', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 600,
            child: GMPLiveMap(
              pickupLabel: 'Wuse Market Section B',
              dropoffLabel: 'Plot 12 Aminu Kano',
              progress: 0.65,
              forceCanvas: true,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(GMPLiveMap), findsOneWidget);
    expect(find.byType(InteractiveMapCanvas), findsOneWidget);
    expect(find.byType(InteractiveViewer), findsOneWidget);
  });

  testWidgets('InteractiveMapCanvas renders properly in both light and dark themes', (tester) async {
    // Test Light Theme
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: SizedBox(
            width: 360,
            height: 500,
            child: InteractiveMapCanvas(
              progress: 0.3,
              pickupLabel: 'Pickup Point',
              dropoffLabel: 'Delivery Point',
            ),
          ),
        ),
      ),
    );

    expect(find.byType(InteractiveMapCanvas), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);

    // Test Dark Theme
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const Scaffold(
          body: SizedBox(
            width: 360,
            height: 500,
            child: InteractiveMapCanvas(
              progress: 0.8,
              pickupLabel: 'Pickup Point',
              dropoffLabel: 'Delivery Point',
            ),
          ),
        ),
      ),
    );

    expect(find.byType(InteractiveMapCanvas), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });
}



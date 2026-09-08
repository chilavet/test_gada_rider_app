import 'package:flutter_test/flutter_test.dart';
import 'package:test_gada_rider_app/models/delivery_job.dart';
import 'package:test_gada_rider_app/models/order_item.dart';
import 'package:test_gada_rider_app/state/rider_state.dart';

void main() {
  group('RiderState Unit Tests', () {
    test('Initial state has default values', () {
      final state = RiderState();
      expect(state.isOnline, true);
      expect(state.activeRole, 'Rider');
      expect(state.hasIncomingAlert, false);
      expect(state.activeJob, null);
      expect(state.shoppingBasket.isNotEmpty, true);
      expect(state.stats.todayEarnings, 16305.0);
    });

    test('Toggling online updates state', () {
      final state = RiderState();
      state.toggleOnline();
      expect(state.isOnline, false);
      state.toggleOnline();
      expect(state.isOnline, true);
    });

    test('Switching role updates activeRole', () {
      final state = RiderState();
      state.switchRole('Agent');
      expect(state.activeRole, 'Agent');
      state.switchRole('Rider');
      expect(state.activeRole, 'Rider');
    });

    test('Simulating incoming job triggers alert and sets activeJob', () {
      final state = RiderState();
      state.simulateIncomingJob();
      expect(state.hasIncomingAlert, true);
      expect(state.activeJob, isNotNull);
      expect(state.activeJob!.status, JobStatus.incomingAlert);
    });

    test('Accepting job changes status to accepted', () {
      final state = RiderState();
      state.simulateIncomingJob();
      state.acceptJob();
      expect(state.hasIncomingAlert, false);
      expect(state.activeJob!.status, JobStatus.accepted);
    });

    test('Advancing job status cycles through delivery stages and updates earnings', () {
      final state = RiderState();
      state.simulateIncomingJob();
      state.acceptJob();

      final initialEarnings = state.stats.todayEarnings;
      final initialTrips = state.stats.todayTrips;

      // accepted -> enRouteToPickup
      state.advanceJobStatus();
      expect(state.activeJob!.status, JobStatus.enRouteToPickup);

      // enRouteToPickup -> arrivedAtPickup
      state.advanceJobStatus();
      expect(state.activeJob!.status, JobStatus.arrivedAtPickup);

      // arrivedAtPickup -> orderPickedUp
      state.advanceJobStatus();
      expect(state.activeJob!.status, JobStatus.orderPickedUp);

      // orderPickedUp -> enRouteToDropoff
      state.advanceJobStatus();
      expect(state.activeJob!.status, JobStatus.enRouteToDropoff);

      // enRouteToDropoff -> delivered
      state.advanceJobStatus();
      expect(state.activeJob!.status, JobStatus.delivered);

      expect(state.stats.todayEarnings, initialEarnings + 1850.0);
      expect(state.stats.todayTrips, initialTrips + 1);
    });

    test('Market item status and price increase updates correctly', () {
      final state = RiderState();
      final item = state.shoppingBasket.first;

      state.updateItemStatus(item.id, ItemStatus.purchased);
      final updated = state.shoppingBasket.firstWhere((i) => i.id == item.id);
      expect(updated.status, ItemStatus.purchased);

      state.requestPriceIncrease(item.id, 7500.0);
      final increased = state.shoppingBasket.firstWhere((i) => i.id == item.id);
      expect(increased.status, ItemStatus.awaitingApproval);
      expect(increased.marketPrice, 7500.0);
    });
  });
}

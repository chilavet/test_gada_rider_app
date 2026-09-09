import 'package:flutter/material.dart';
import '../models/delivery_job.dart';
import '../models/order_item.dart';
import '../models/rider_stats.dart';
import '../models/payout_record.dart';
import '../models/notification_item.dart';
import 'mock_data.dart';

class RiderState extends ChangeNotifier {
  bool _isOnline = true;
  String _activeRole = 'Rider'; // 'Rider', 'Agent', or 'Lease'
  DeliveryJob? _activeJob;
  bool _hasIncomingAlert = false;
  final List<OrderItem> _shoppingBasket = List.from(MockData.defaultMarketBasket);
  RiderStats _stats = MockData.defaultStats;
  final List<PayoutRecord> _payouts = List.from(MockData.payoutLedger);
  final List<NotificationItem> _notifications = List.from(MockData.defaultNotifications);

  // Theme Mode (Day / Night Mode)
  ThemeMode _themeMode = ThemeMode.light;

  // Auth & KYC State
  bool _isAuthenticated = true;
  String _userPhoneNumber = '080123456789';
  bool _kycPersonalInfoDone = true;
  bool _kycIdentityDone = false;
  bool _kycVehicleDone = false;
  bool _kycBankDone = false;

  // Lease State
  final List<String> _appliedBikes = [];

  // User Profile
  UserProfile _userProfile = MockData.defaultUserProfile;

  bool get isOnline => _isOnline;
  String get activeRole => _activeRole;
  DeliveryJob? get activeJob => _activeJob;
  bool get hasIncomingAlert => _hasIncomingAlert;
  List<OrderItem> get shoppingBasket => List.unmodifiable(_shoppingBasket);
  RiderStats get stats => _stats;
  List<PayoutRecord> get payouts => List.unmodifiable(_payouts);

  UserProfile get userProfile => _userProfile;
  List<NotificationItem> get notifications => List.unmodifiable(_notifications);
  int get unreadNotificationCount => _notifications.where((n) => !n.isRead).length;

  void markNotificationAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    bool changed = false;
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
        changed = true;
      }
    }
    if (changed) {
      notifyListeners();
    }
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void clearAllNotifications() {
    if (_notifications.isNotEmpty) {
      _notifications.clear();
      notifyListeners();
    }
  }

  void addNotification(NotificationItem notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isNightMode => _themeMode == ThemeMode.dark;

  bool get isAuthenticated => _isAuthenticated;
  String get userPhoneNumber => _userPhoneNumber;
  bool get kycPersonalInfoDone => _kycPersonalInfoDone;
  bool get kycIdentityDone => _kycIdentityDone;
  bool get kycVehicleDone => _kycVehicleDone;
  bool get kycBankDone => _kycBankDone;
  List<String> get appliedBikes => List.unmodifiable(_appliedBikes);

  void updateUserProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? vehicleType,
    String? vehiclePlate,
    String? emergencyContact,
  }) {
    _userProfile = _userProfile.copyWith(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      vehicleType: vehicleType,
      vehiclePlate: vehiclePlate,
      emergencyContact: emergencyContact,
    );
    if (phone != null) {
      _userPhoneNumber = phone;
    }
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  void toggleNightMode() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void authenticate(String phone) {
    _userPhoneNumber = phone;
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _isOnline = false;
    _activeJob = null;
    _hasIncomingAlert = false;
    notifyListeners();
  }

  void completeKycStep(String step) {
    switch (step) {
      case 'personal':
        _kycPersonalInfoDone = true;
        break;
      case 'identity':
        _kycIdentityDone = true;
        break;
      case 'vehicle':
        _kycVehicleDone = true;
        break;
      case 'bank':
        _kycBankDone = true;
        break;
    }
    notifyListeners();
  }

  void submitLeaseApplication(String bikeId) {
    if (!_appliedBikes.contains(bikeId)) {
      _appliedBikes.add(bikeId);
      notifyListeners();
    }
  }

  void toggleOnline() {
    _isOnline = !_isOnline;
    if (!_isOnline) {
      _hasIncomingAlert = false;
    }
    notifyListeners();
  }

  void switchRole(String newRole) {
    if (_activeRole != newRole) {
      _activeRole = newRole;
      notifyListeners();
    }
  }

  void simulateIncomingJob() {
    if (!_isOnline) {
      _isOnline = true;
    }
    _activeJob = MockData.defaultJob.copyWith(status: JobStatus.incomingAlert);
    _hasIncomingAlert = true;
    _notifications.insert(
      0,
      NotificationItem(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: 'New Order Available',
        message: 'New delivery #${_activeJob!.orderNumber} available in ${_activeJob!.pickupName} (₦${_activeJob!.deliveryFee.toStringAsFixed(0)} fee).',
        timestamp: DateTime.now(),
        type: NotificationType.order,
        isRead: false,
        actionLabel: 'View Order',
        actionTarget: 'job',
      ),
    );
    notifyListeners();
  }

  void acceptJob() {
    if (_activeJob != null) {
      _activeJob = _activeJob!.copyWith(status: JobStatus.accepted);
      _hasIncomingAlert = false;
      notifyListeners();
    }
  }

  void declineJob() {
    _activeJob = null;
    _hasIncomingAlert = false;
    notifyListeners();
  }

  void advanceJobStatus() {
    if (_activeJob == null) return;
    switch (_activeJob!.status) {
      case JobStatus.incomingAlert:
        _activeJob = _activeJob!.copyWith(status: JobStatus.accepted);
        _hasIncomingAlert = false;
        break;
      case JobStatus.accepted:
        _activeJob = _activeJob!.copyWith(status: JobStatus.enRouteToPickup);
        break;
      case JobStatus.enRouteToPickup:
        _activeJob = _activeJob!.copyWith(status: JobStatus.arrivedAtPickup);
        break;
      case JobStatus.arrivedAtPickup:
        _activeJob = _activeJob!.copyWith(status: JobStatus.orderPickedUp);
        break;
      case JobStatus.orderPickedUp:
        _activeJob = _activeJob!.copyWith(status: JobStatus.enRouteToDropoff);
        break;
      case JobStatus.enRouteToDropoff:
        _activeJob = _activeJob!.copyWith(status: JobStatus.delivered);
        _recordCompletedJob();
        break;
      case JobStatus.delivered:
      case JobStatus.declined:
      case JobStatus.idle:
        break;
    }
    notifyListeners();
  }

  void _recordCompletedJob() {
    if (_activeJob == null) return;
    final fee = _activeJob!.deliveryFee;
    _stats = _stats.copyWith(
      todayEarnings: _stats.todayEarnings + fee,
      todayTrips: _stats.todayTrips + 1,
      todayDistanceKm: _stats.todayDistanceKm + _activeJob!.distanceKm,
      walletBalance: _stats.walletBalance + fee,
    );
    _payouts.insert(
      0,
      PayoutRecord(
        id: 'pay-${DateTime.now().millisecondsSinceEpoch}',
        orderId: _activeJob!.orderNumber,
        description: 'Trip Payout - ${_activeJob!.dropoffName}',
        amount: fee,
        timestamp: DateTime.now(),
      ),
    );
    _notifications.insert(
      0,
      NotificationItem(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Trip Completed & Payout Credited',
        message: '₦${fee.toStringAsFixed(0)} delivery fee credited to your wallet for Order ${_activeJob!.orderNumber}.',
        timestamp: DateTime.now(),
        type: NotificationType.payout,
        isRead: false,
        actionLabel: 'View Earnings',
        actionTarget: 'earnings',
      ),
    );
  }

  void dismissCompletedJob() {
    _activeJob = null;
    notifyListeners();
  }

  void updateItemStatus(String itemId, ItemStatus newStatus, {double? marketPrice}) {
    final index = _shoppingBasket.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      final current = _shoppingBasket[index];
      _shoppingBasket[index] = current.copyWith(
        status: newStatus,
        marketPrice: marketPrice ?? current.marketPrice,
      );
      notifyListeners();
    }
  }

  void markItemPurchased(String itemId) {
    updateItemStatus(itemId, ItemStatus.purchased);
  }

  void requestPriceIncrease(String itemId, double proposedPrice) {
    updateItemStatus(itemId, ItemStatus.awaitingApproval, marketPrice: proposedPrice);
  }
}

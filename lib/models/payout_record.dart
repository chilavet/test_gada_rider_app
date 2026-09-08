class PayoutRecord {
  final String id;
  final String orderId;
  final String description;
  final double amount;
  final DateTime timestamp;
  final bool isCredit;
  final String status;

  const PayoutRecord({
    required this.id,
    required this.orderId,
    required this.description,
    required this.amount,
    required this.timestamp,
    this.isCredit = true,
    this.status = 'Completed',
  });
}

class UserProfile {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final String avatarUrl;
  final String vehicleType;
  final String vehiclePlate;
  final bool isKycVerified;
  final String role; // 'Rider' or 'Market Agent'
  final bool isLeaseRider;

  const UserProfile({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.avatarUrl,
    required this.vehicleType,
    required this.vehiclePlate,
    this.isKycVerified = true,
    this.role = 'Rider',
    this.isLeaseRider = false,
  });
}

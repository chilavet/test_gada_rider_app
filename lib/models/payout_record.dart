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
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String avatarUrl;
  final String vehicleType;
  final String vehiclePlate;
  final bool isKycVerified;
  final String role; // 'Rider' or 'Market Agent'
  final bool isLeaseRider;
  final String memberSince;
  final String emergencyContact;

  String get fullName => '$firstName $lastName'.trim();

  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    this.avatarUrl = '',
    this.vehicleType = 'TVS HLX 150 (Motorbike)',
    this.vehiclePlate = 'ABJ-892-XY',
    this.isKycVerified = true,
    this.role = 'Rider',
    this.isLeaseRider = false,
    this.memberSince = 'September 2023',
    this.emergencyContact = '+234 802 345 6789',
  });

  UserProfile copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? avatarUrl,
    String? vehicleType,
    String? vehiclePlate,
    bool? isKycVerified,
    String? role,
    bool? isLeaseRider,
    String? memberSince,
    String? emergencyContact,
  }) {
    return UserProfile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      vehicleType: vehicleType ?? this.vehicleType,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      isKycVerified: isKycVerified ?? this.isKycVerified,
      role: role ?? this.role,
      isLeaseRider: isLeaseRider ?? this.isLeaseRider,
      memberSince: memberSince ?? this.memberSince,
      emergencyContact: emergencyContact ?? this.emergencyContact,
    );
  }
}


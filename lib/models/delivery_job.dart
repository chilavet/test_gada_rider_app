enum JobStatus {
  idle,
  incomingAlert,
  accepted,
  enRouteToPickup,
  arrivedAtPickup,
  orderPickedUp,
  enRouteToDropoff,
  delivered,
  declined,
}

class DeliveryJob {
  final String id;
  final String orderNumber;
  final String pickupName;
  final String pickupAddress;
  final String dropoffName;
  final String dropoffAddress;
  final double distanceKm;
  final int estimatedTimeMinutes;
  final double deliveryFee;
  final double itemsTotal;
  final int itemCount;
  final String customerName;
  final String customerPhone;
  final double pickupLatitude;
  final double pickupLongitude;
  final double dropoffLatitude;
  final double dropoffLongitude;
  final String merchantName;
  final String merchantPhone;
  final JobStatus status;
  final DateTime createdAt;

  const DeliveryJob({
    required this.id,
    required this.orderNumber,
    required this.pickupName,
    required this.pickupAddress,
    required this.dropoffName,
    required this.dropoffAddress,
    required this.distanceKm,
    required this.estimatedTimeMinutes,
    required this.deliveryFee,
    required this.itemsTotal,
    required this.itemCount,
    required this.customerName,
    required this.customerPhone,
    this.pickupLatitude = 9.0667,
    this.pickupLongitude = 7.4500,
    this.dropoffLatitude = 9.0782,
    this.dropoffLongitude = 7.4725,
    this.merchantName = 'Mama Nkechi’s Kitchen',
    this.merchantPhone = '08091234567',
    this.status = JobStatus.incomingAlert,
    required this.createdAt,
  });

  DeliveryJob copyWith({
    String? id,
    String? orderNumber,
    String? pickupName,
    String? pickupAddress,
    String? dropoffName,
    String? dropoffAddress,
    double? distanceKm,
    int? estimatedTimeMinutes,
    double? deliveryFee,
    double? itemsTotal,
    int? itemCount,
    String? customerName,
    String? customerPhone,
    double? pickupLatitude,
    double? pickupLongitude,
    double? dropoffLatitude,
    double? dropoffLongitude,
    String? merchantName,
    String? merchantPhone,
    JobStatus? status,
    DateTime? createdAt,
  }) {
    return DeliveryJob(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      pickupName: pickupName ?? this.pickupName,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      dropoffName: dropoffName ?? this.dropoffName,
      dropoffAddress: dropoffAddress ?? this.dropoffAddress,
      distanceKm: distanceKm ?? this.distanceKm,
      estimatedTimeMinutes: estimatedTimeMinutes ?? this.estimatedTimeMinutes,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      itemsTotal: itemsTotal ?? this.itemsTotal,
      itemCount: itemCount ?? this.itemCount,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      pickupLatitude: pickupLatitude ?? this.pickupLatitude,
      pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      dropoffLatitude: dropoffLatitude ?? this.dropoffLatitude,
      dropoffLongitude: dropoffLongitude ?? this.dropoffLongitude,
      merchantName: merchantName ?? this.merchantName,
      merchantPhone: merchantPhone ?? this.merchantPhone,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}


import '../models/delivery_job.dart';
import '../models/order_item.dart';
import '../models/rider_stats.dart';
import '../models/payout_record.dart';

class MockData {
  static RiderStats defaultStats = const RiderStats(
    todayEarnings: 16305.00,
    todayTrips: 3,
    todayDistanceKm: 3.4,
    todayActiveHours: '4h 25m',
    weeklyEarnings: 42800.00,
    weeklyTrips: 12,
    walletBalance: 42800.00,
    rating: 4.9,
  );

  static DeliveryJob defaultJob = DeliveryJob(
    id: 'job-1087',
    orderNumber: '#GDA-8921',
    pickupName: 'Wuse Market, Abuja',
    pickupAddress: 'Zone 5, Wuse District, Abuja FCT',
    dropoffName: '12 Aminu Kano Crescent',
    dropoffAddress: 'Aminu Kano Crescent, Wuse 2, Abuja FCT',
    distanceKm: 3.4,
    estimatedTimeMinutes: 14,
    deliveryFee: 1850.00,
    itemsTotal: 44000.00,
    itemCount: 5,
    customerName: 'John Doe',
    customerPhone: '+234 803 456 7890',
    status: JobStatus.incomingAlert,
    createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
  );

  static List<OrderItem> defaultMarketBasket = [
    const OrderItem(
      id: 'item-1',
      title: 'Fresh Tomatoes (Big Basket)',
      quantityDescription: '1 Big Round Basket • Firm & Red',
      budgetPrice: 6500.00,
      marketPrice: 6500.00,
      status: ItemStatus.purchased,
      customerNote: 'Please select firm, ripe ones without cuts.',
      substitutionTags: ['Roma Tomatoes', 'Derica Basket'],
    ),
    const OrderItem(
      id: 'item-2',
      title: 'Power Oil Vegetable Oil (3 Litres)',
      quantityDescription: '1 Jug • 3L',
      budgetPrice: 3500.00,
      marketPrice: 4500.00,
      status: ItemStatus.increaseApproved,
      customerNote: 'If Power oil is above budget, Kings Oil 3L is fine.',
      substitutionTags: ['Kings Oil 3L', 'Mamador 3L'],
    ),
    const OrderItem(
      id: 'item-3',
      title: 'Red Bell Peppers (Tatashe)',
      quantityDescription: 'Half Basket • Freshly picked',
      budgetPrice: 2800.00,
      marketPrice: 3200.00,
      status: ItemStatus.awaitingApproval,
      customerNote: 'Needs approval for +₦400 increase.',
      substitutionTags: ['Shombo Pepper', 'Scotch Bonnet'],
    ),
    const OrderItem(
      id: 'item-4',
      title: 'Frozen Titus Fish (Mackerel)',
      quantityDescription: '3 Big Pieces • Clean cut',
      budgetPrice: 8500.00,
      status: ItemStatus.searching,
      customerNote: 'Ask the seller to scale and slice into medium chunks.',
      substitutionTags: ['Croaker Fish', 'Catfish'],
    ),
    const OrderItem(
      id: 'item-5',
      title: 'Golden Penny Spaghetti Carton',
      quantityDescription: '1 Carton • 20 Packs',
      budgetPrice: 13500.00,
      status: ItemStatus.pending,
      customerNote: 'Ensure carton is sealed with official brand tape.',
      substitutionTags: ['Dangote Spaghetti'],
    ),
  ];

  static List<PayoutRecord> payoutLedger = [
    PayoutRecord(
      id: 'pay-1',
      orderId: '#GDA-8919',
      description: 'Trip Payout - Wuse 2 Dropoff',
      amount: 1850.00,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 20)),
    ),
    PayoutRecord(
      id: 'pay-2',
      orderId: '#GDA-8915',
      description: 'Trip Payout - Maitama Delivery',
      amount: 2400.00,
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 45)),
    ),
    PayoutRecord(
      id: 'pay-3',
      orderId: '#GDA-8908',
      description: 'Market Agent Shopping Commission',
      amount: 4500.00,
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    PayoutRecord(
      id: 'pay-4',
      orderId: '#WITHDRAW-441',
      description: 'Bank Withdrawal to GTBank (••• 4092)',
      amount: -15000.00,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isCredit: false,
    ),
    PayoutRecord(
      id: 'pay-5',
      orderId: '#GDA-8882',
      description: 'Trip Payout - Garki 2 Delivery',
      amount: 1950.00,
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    ),
  ];

  static const UserProfile defaultUserProfile = UserProfile(
    id: 'GDA-RD-0428',
    firstName: 'Allen',
    lastName: 'Edgar',
    phone: '080123456789',
    email: 'allenedgar@gmail.com',
    vehicleType: 'TVS HLX 150 (Motorbike)',
    vehiclePlate: 'ABJ-892-XY',
    isKycVerified: true,
    role: 'Rider',
    isLeaseRider: false,
    memberSince: 'September 2023',
    emergencyContact: '+234 802 345 6789 (Brother)',
  );
}


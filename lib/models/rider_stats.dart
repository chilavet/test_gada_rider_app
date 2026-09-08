class RiderStats {
  final double todayEarnings;
  final int todayTrips;
  final double todayDistanceKm;
  final String todayActiveHours;
  final double weeklyEarnings;
  final int weeklyTrips;
  final double walletBalance;
  final double rating;

  const RiderStats({
    required this.todayEarnings,
    required this.todayTrips,
    required this.todayDistanceKm,
    required this.todayActiveHours,
    required this.weeklyEarnings,
    required this.weeklyTrips,
    required this.walletBalance,
    required this.rating,
  });

  RiderStats copyWith({
    double? todayEarnings,
    int? todayTrips,
    double? todayDistanceKm,
    String? todayActiveHours,
    double? weeklyEarnings,
    int? weeklyTrips,
    double? walletBalance,
    double? rating,
  }) {
    return RiderStats(
      todayEarnings: todayEarnings ?? this.todayEarnings,
      todayTrips: todayTrips ?? this.todayTrips,
      todayDistanceKm: todayDistanceKm ?? this.todayDistanceKm,
      todayActiveHours: todayActiveHours ?? this.todayActiveHours,
      weeklyEarnings: weeklyEarnings ?? this.weeklyEarnings,
      weeklyTrips: weeklyTrips ?? this.weeklyTrips,
      walletBalance: walletBalance ?? this.walletBalance,
      rating: rating ?? this.rating,
    );
  }
}

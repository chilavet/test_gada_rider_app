class LeaseBike {
  final String id;
  final String name;
  final String specs;
  final bool isAvailable;
  final double weeklyPayment;
  final int leaseDurationWeeks;
  final double startFee;
  final double totalLeaseCost;
  final String category; // 'Available', 'Popular', 'All'
  final String emojiIcon;

  const LeaseBike({
    required this.id,
    required this.name,
    required this.specs,
    this.isAvailable = true,
    required this.weeklyPayment,
    required this.leaseDurationWeeks,
    required this.startFee,
    required this.totalLeaseCost,
    required this.category,
    required this.emojiIcon,
  });

  static List<LeaseBike> get sampleBikes => const [
        LeaseBike(
          id: 'bike-1',
          name: 'TVS HLX 150',
          specs: '150cc • 5-Speed • Fuel Efficient',
          weeklyPayment: 14500.0,
          leaseDurationWeeks: 52,
          startFee: 40000.0,
          totalLeaseCost: 754000.0,
          category: 'Available',
          emojiIcon: '🏍️',
        ),
        LeaseBike(
          id: 'bike-2',
          name: 'Yamaha YZF-R15',
          specs: '155cc • 6-Speed • Sporty Design',
          weeklyPayment: 16000.0,
          leaseDurationWeeks: 48,
          startFee: 45000.0,
          totalLeaseCost: 768000.0,
          category: 'Popular',
          emojiIcon: '🚲',
        ),
        LeaseBike(
          id: 'bike-3',
          name: 'Honda CB Shine',
          specs: '125cc • 5-Speed • Comfortable Ride',
          weeklyPayment: 12000.0,
          leaseDurationWeeks: 60,
          startFee: 35000.0,
          totalLeaseCost: 720000.0,
          category: 'Available',
          emojiIcon: '🛵',
        ),
        LeaseBike(
          id: 'bike-4',
          name: 'KTM Duke 200',
          specs: '200cc • 6-Speed • Aggressive Styling',
          weeklyPayment: 18500.0,
          leaseDurationWeeks: 36,
          startFee: 50000.0,
          totalLeaseCost: 666000.0,
          category: 'Popular',
          emojiIcon: '⚡',
        ),
      ];
}

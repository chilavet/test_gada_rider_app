enum ItemStatus {
  pending,
  searching,
  purchased,
  awaitingApproval,
  increaseApproved,
  cancelled,
}

class OrderItem {
  final String id;
  final String title;
  final String quantityDescription;
  final double budgetPrice;
  final double? marketPrice;
  final ItemStatus status;
  final String? customerNote;
  final List<String> substitutionTags;
  final String? imageUrl;

  const OrderItem({
    required this.id,
    required this.title,
    required this.quantityDescription,
    required this.budgetPrice,
    this.marketPrice,
    this.status = ItemStatus.pending,
    this.customerNote,
    this.substitutionTags = const [],
    this.imageUrl,
  });

  double get priceDifference => (marketPrice ?? budgetPrice) - budgetPrice;

  OrderItem copyWith({
    String? id,
    String? title,
    String? quantityDescription,
    double? budgetPrice,
    double? marketPrice,
    ItemStatus? status,
    String? customerNote,
    List<String>? substitutionTags,
    String? imageUrl,
  }) {
    return OrderItem(
      id: id ?? this.id,
      title: title ?? this.title,
      quantityDescription: quantityDescription ?? this.quantityDescription,
      budgetPrice: budgetPrice ?? this.budgetPrice,
      marketPrice: marketPrice ?? this.marketPrice,
      status: status ?? this.status,
      customerNote: customerNote ?? this.customerNote,
      substitutionTags: substitutionTags ?? this.substitutionTags,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

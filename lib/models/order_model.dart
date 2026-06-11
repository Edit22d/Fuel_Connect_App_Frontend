class OrderModel {
  final int id;
  final int? customerId;
  final int? stationId;
  final String stationName;
  final String fuelType;
  final double quantity;
  final String quantityUnit;
  final double totalPrice;
  final String currency;
  final String status;
  final String createdAt;

  const OrderModel({
    required this.id,
    this.customerId,
    this.stationId,
    required this.stationName,
    required this.fuelType,
    required this.quantity,
    required this.quantityUnit,
    required this.totalPrice,
    required this.currency,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // station_details comes from the backend serializer
    final stationDetails = json['station_details'] as Map<String, dynamic>?;
    final String sName = stationDetails != null ? stationDetails['name'] : 'Unknown Station';

    return OrderModel(
      id: json['id'] ?? 0,
      customerId: json['customer'],
      stationId: json['station'],
      stationName: sName,
      fuelType: json['fuel_type'] ?? 'Unknown Fuel',
      quantity: double.tryParse(json['quantity']?.toString() ?? '0') ?? 0.0,
      quantityUnit: json['quantity_unit'] ?? 'Liters',
      totalPrice: double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      currency: json['currency'] ?? 'UGX',
      status: json['status']?.toString().toUpperCase() ?? 'PENDING',
      createdAt: json['created_at'] ?? '',
    );
  }
}

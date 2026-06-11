import 'package:latlong2/latlong.dart' hide Path;

class FuelStation {
  final String id;
  final String name;
  final String address;
  final double rating;
  final int reviewCount;
  final String distance;
  final String imageUrl;
  final LatLng position;
  final bool isOpen;
  final String pricePerLitre;
  final List<String> fuelTypes;
  final String phone;
  final String openingHours;

  const FuelStation({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.imageUrl,
    required this.position,
    required this.isOpen,
    required this.pricePerLitre,
    this.fuelTypes = const [],
    this.phone = '',
    this.openingHours = '',
  });

  factory FuelStation.fromJson(Map<String, dynamic> json) {
    // Parse latitude and longitude safely
    double lat = 0.0;
    double lng = 0.0;
    
    if (json['latitude'] != null) {
      lat = double.tryParse(json['latitude'].toString()) ?? 0.0;
    }
    if (json['longitude'] != null) {
      lng = double.tryParse(json['longitude'].toString()) ?? 0.0;
    }

    return FuelStation(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown Station',
      address: json['address'] ?? 'Unknown Address',
      rating: double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
      reviewCount: json['review_count'] ?? json['reviewCount'] ?? 0,
      distance: json['distance']?.toString() ?? '0 km',
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? 'assets/images/placeholder.png', // Fallback to a local asset or empty
      position: LatLng(lat, lng),
      isOpen: json['is_open'] ?? json['isOpen'] ?? false,
      pricePerLitre: json['price_per_litre'] ?? json['pricePerLitre'] ?? 'UGX 0',
      fuelTypes: json['fuel_types'] != null 
          ? List<String>.from(json['fuel_types']) 
          : (json['fuelTypes'] != null ? List<String>.from(json['fuelTypes']) : []),
      phone: json['phone'] ?? '',
      openingHours: json['opening_hours'] ?? json['openingHours'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'rating': rating,
      'review_count': reviewCount,
      'distance': distance,
      'image_url': imageUrl,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'is_open': isOpen,
      'price_per_litre': pricePerLitre,
      'fuel_types': fuelTypes,
      'phone': phone,
      'opening_hours': openingHours,
    };
  }

  bool matchesQuery(String query) {
    final lowerQuery = query.toLowerCase();
    return name.toLowerCase().contains(lowerQuery) ||
        address.toLowerCase().contains(lowerQuery) ||
        fuelTypes.any((f) => f.toLowerCase().contains(lowerQuery));
  }
}

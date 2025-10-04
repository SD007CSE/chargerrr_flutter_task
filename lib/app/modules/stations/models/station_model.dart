class Station {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final int availablePoints;
  final int totalPoints;
  final List<String> amenities;

  Station({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.availablePoints,
    required this.totalPoints,
    required this.amenities,
  });

  // Factory method to create a Station from JSON
  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      availablePoints: json['available_points'] ?? 0,
      totalPoints: json['total_points'] ?? 0,
      amenities: List<String>.from(json['amenities'] ?? []),
    );
  }

  // Convert Station object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'available_points': availablePoints,
      'total_points': totalPoints,
      'amenities': amenities,
    };
  }
}

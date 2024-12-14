class LocationDetails {
  final String name;
  final double latitude;
  final double longitude;

  LocationDetails({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'name' : name,
      'latitude' : latitude,
      'longitude' : longitude,
    };
  }

  factory LocationDetails.fromFirebaseMap(Map<String, dynamic> map) {
    return LocationDetails(
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  factory LocationDetails.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'];
    final location = geometry['location'];

    return LocationDetails(
      name: json['name'],
      latitude: location['lat'],
      longitude: location['lng'],
    );
  }

  factory LocationDetails.fromDetailJson(Map<String, dynamic> json) {
    final geometry = json['geometry'];
    final location = geometry['location'];
    return LocationDetails(
      name: json['formatted_address'] ?? '',
      latitude: location['lat'],
      longitude: location['lng'],

    );
  }
}
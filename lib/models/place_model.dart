class PlaceModel {
  final String fsqId;
  final String locationName;
  final String placeName;
  final double? rating;
  final String? website;
  final String? tel;
  final double lat;
  final double lon;
  final double? distance;
  final bool isOpen;
  final String? closingTime;
  final String? openTime;
  final List<String>? categories;

  PlaceModel({
    required this.fsqId,
    required this.locationName,
    required this.placeName,
    required this.lat,
    required this.lon,
    this.website,
    this.tel,
    this.rating,
    this.distance,
    this.closingTime,
    required this.isOpen,
    this.openTime,
    required this.categories,
  });

  Map<String, dynamic> toJson() {
    return {
      'fsqId': fsqId,
      'locationName': locationName,
      'placeName': placeName,
      'rating': rating,
      'website': website,
      'tel': tel,
      'lat': lat,
      'lon': lon,
      'distance': distance,
      'isOpen': isOpen,
      'closingTime': closingTime,
      'openTime': openTime,
      'categories': categories,
    };
  }

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    List<String>? categoryNames = json['categories'] != null
        ? (json['categories'] as List<dynamic>)
            .map((category) => category['name'] as String? ?? '')
            .toList()
        : [];

    String? close;
    String? open;
    if (json['hours'] != null) {
      if (json['hours']['regular'] != null) {
        List<Map<String, dynamic>> regularHours =
            List<Map<String, dynamic>>.from(json['hours']['regular']);
        int currentDay = DateTime.now().weekday;
        Map<String, dynamic>? currentDayEntry;
        try {
          currentDayEntry = regularHours.firstWhere(
            (entry) => entry['day'] == currentDay,
          );
        } catch (e) {
          currentDayEntry = null;
        }

        if (currentDayEntry != null) {
          int closingTime = int.parse(currentDayEntry['close']);
          int closingHour = closingTime ~/ 100;
          int closingMinute = closingTime % 100;

          String meridian = closingHour >= 12 ? 'PM' : 'AM';
          closingHour = closingHour % 12;
          closingHour = closingHour == 0 ? 12 : closingHour;
          close =
              '${closingHour.toString().padLeft(2, '0')}:${closingMinute.toString().padLeft(2, '0')} $meridian';

          // Get opening time
          int openingTime = int.parse(currentDayEntry['open']);
          int openingHour = openingTime ~/ 100;
          int openingMinute = openingTime % 100;

          String openingMeridian = openingHour >= 12 ? 'PM' : 'AM';
          openingHour = openingHour % 12;
          openingHour = openingHour == 0 ? 12 : openingHour;
          open =
          '${openingHour.toString().padLeft(2, '0')}:${openingMinute.toString().padLeft(2, '0')} $openingMeridian';
        }
      }
    }

    return PlaceModel(
      fsqId: json['fsq_id'] ?? '',
      locationName: json['location']['formatted_address'] ?? '',
      placeName: json['name'] ?? '',
      lat: json['geocodes']['main']['latitude'] ?? 0,
      lon: json['geocodes']['main']['longitude'] ?? 0,
      rating: json['rating']?.toDouble() ?? 0,
      website: json['website'] ?? '',
      tel: json['tel'] ?? '',
      distance: json['distance']?.toDouble(),
      closingTime: close ?? '',
      openTime: open ?? '',
      isOpen: json['hours'] == null ? json['closed_bucket'] == 'VeryLikelyOpen' ? true : false
          : json['hours']['open_now'] ?? true,
      // isOpen: json['closed_bucket'] == 'VeryLikelyOpen' ? true : false,
      categories: categoryNames,
    );
  }

  factory PlaceModel.fromModelJson(Map<String, dynamic> json) {
    return PlaceModel(
      fsqId: json['fsqId'],
      locationName: json['locationName'],
      placeName: json['placeName'],
      rating: json['rating']?.toDouble(),
      website: json['website'],
      tel: json['tel'],
      lat: json['lat'].toDouble(),
      lon: json['lon'].toDouble(),
      distance: json['distance']?.toDouble(),
      isOpen: json['isOpen'],
      categories: List<String>.from(json['categories']),
    );
  }
}

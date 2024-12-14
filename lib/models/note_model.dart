
class NoteModel{
  final String id;
  final String title;
  final List<String> itemList;
  final bool rememberMe;
  final DateTime createdAt;
  final String? placeName;
  final double? lat;
  final double? long;
  final String? locationName;
  final String userId;
  final String? placeId;
  final DateTime updatedAt;

  NoteModel({
    this.placeId,
    required this.id,
    required this.title,
    required this.itemList,
    required this.rememberMe,
    required this.createdAt,
     this.placeName,
     this.lat,
     this.long,
     this.locationName,
    required this.userId,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'itemList': itemList,
      'rememberMe': rememberMe,
      'createdAt': createdAt.toIso8601String(),
      'placeName': placeName,
      'lat': lat,
      'long': long,
      'locationName': locationName,
      'userId': userId,
      'updatedAt': updatedAt.toIso8601String(),
      'placeId':placeId
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      itemList: List<String>.from(map['itemList']),
      rememberMe: map['rememberMe'],
      createdAt: DateTime.parse(map['createdAt']),
      placeName: map['placeName'],
      lat: map['lat'],
      long: map['long'],
      locationName: map['locationName'],
      userId: map['userId'],

      updatedAt: DateTime.parse(map['updatedAt']), placeId: map['placeId'],
    );
  }

  NoteModel copyWith({
    String? id,
    String? title,
    List<String>? itemList,
    bool? rememberMe,
    DateTime? createdAt,
    String? placeName,
    double? lat,
    double? long,
    String? locationName,
    String? userId,
    String? placeId,
    DateTime? updatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      itemList: itemList ?? this.itemList,
      rememberMe: rememberMe ?? this.rememberMe,
      createdAt: createdAt ?? this.createdAt,
      placeName: placeName ?? this.placeName,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      locationName: locationName ?? this.locationName,
      userId: userId ?? this.userId,
      updatedAt: updatedAt ?? this.updatedAt, placeId: placeId??this.placeId,
    );
  }
}

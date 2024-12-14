class FavoriteModel{
  final String id;
  final String fsqId;
  final String userId;
  final String placeName;
  final String locationName;
  final String groupId;
  final DateTime date;


  FavoriteModel({
    required this.id,
    required this.fsqId,
    required this.userId,
    required this.groupId,
    required this.placeName,
    required this.locationName,
    required this.date
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'fsqId': fsqId,
      'userId': userId,
      'groupId' : groupId,
      'placeName': placeName,
      'locationName': locationName,
      'date' : date.toIso8601String(),
    };
  }

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      id: map['id'],
      fsqId: map['fsqId'] as String,
      userId: map['userId'] as String,
      groupId: map['groupId'] as String,
      placeName: map['placeName'] as String,
      locationName: map['locationName'] as String,
      date: DateTime.parse(map['date']),
    );
  }
}
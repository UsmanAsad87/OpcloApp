class PlaceSubscriptionModel{
  String userId;
  DateTime date;

  PlaceSubscriptionModel({
    required this.userId,
    required this.date,
  });

  // Convert PlaceSubscriptionModel to a map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': date.toIso8601String(),
    };
  }

  // Create PlaceSubscriptionModel from a map
  factory PlaceSubscriptionModel.fromMap(Map<String, dynamic> map) {
    return PlaceSubscriptionModel(
      userId: map['userId'],
      date: DateTime.parse(map['date']),
    );
  }

  // Create a copy of PlaceSubscriptionModel with new values
  PlaceSubscriptionModel copyWith({
    String? userId,
    DateTime? date,
  }) {
    return PlaceSubscriptionModel(
      userId: userId ?? this.userId,
      date: date ?? this.date,
    );
  }
}
class AlertCommentModel{
  final String id;
  final String alertId;
  final String userId;
  final String userName;
  final String userProfile;
  final String comment;
  final DateTime date;


  AlertCommentModel({
    required this.id,
    required this.alertId,
    required this.userId,
    required this.userName,
    required this.userProfile,
    required this.comment,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'alertId': alertId,
      'userId': userId,
      'userName': userName,
      'userProfile': userProfile,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }

  factory AlertCommentModel.fromMap(Map<String, dynamic> map) {
    return AlertCommentModel(
      id: map['id'] as String,
      alertId: map['alertId'] as String,
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      userProfile: map['userProfile'] as String,
      comment: map['comment'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }

  AlertCommentModel copyWith({
    String? id,
    String? alertId,
    String? userId,
    String? userName,
    String? userProfile,
    String? comment,
    DateTime? date,
  }) {
    return AlertCommentModel(
      id: id ?? this.id,
      alertId: alertId ?? this.alertId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfile: userProfile ?? this.userProfile,
      comment: comment ?? this.comment,
      date: date ?? this.date,
    );
  }
}
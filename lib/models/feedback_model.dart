class FeedbackModel{
  final String id;
  final String userId;
  final int easy;
  final int fastAndResponsive;
  final int reliable;
  final int recommend;
  final String comment;
  final DateTime date;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.easy,
    required this.fastAndResponsive,
    required this.reliable,
    required this.recommend,
    required this.comment,
    required this.date,
  });

  // Convert the FeedbackModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'easy': easy,
      'fastAndResponsive': fastAndResponsive,
      'reliable': reliable,
      'recommend': recommend,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }

  // Convert a Map to a FeedbackModel instance
  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      id: map['id'],
      userId: map['userId'],
      easy: map['easy'],
      fastAndResponsive: map['fastAndResponsive'],
      reliable: map['reliable'],
      recommend: map['recommend'],
      comment: map['comment'],
      date: DateTime.parse(map['date']),
    );
  }

  FeedbackModel copyWith({
    String? id,
    String? userId,
    int? easy,
    int? fastAndResponsive,
    int? reliable,
    int? recommend,
    String? comment,
    DateTime? date,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      easy: easy ?? this.easy,
      fastAndResponsive: fastAndResponsive ?? this.fastAndResponsive,
      reliable: reliable ?? this.reliable,
      recommend: recommend ?? this.recommend,
      comment: comment ?? this.comment,
      date: date ?? this.date,
    );
  }
}

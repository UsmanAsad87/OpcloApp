class RedemptionCouponModel{
  final String id;
  final String userId;
  final String couponId;
  final DateTime date;
  RedemptionCouponModel({
    required this.id,
    required this.userId,
    required this.couponId,
    required this.date,
  });

  // Convert a RedemptionCouponModel into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'couponId': couponId,
      'date': date.toIso8601String(),
    };
  }

  // Create a RedemptionCouponModel from a Map.
  factory RedemptionCouponModel.fromMap(Map<String, dynamic> map) {
    return RedemptionCouponModel(
      id: map['id'],
      userId: map['userId'],
      couponId: map['couponId'],
      date: DateTime.parse(map['date']),
    );
  }

  // Create a copy of RedemptionCouponModel with new values.
  RedemptionCouponModel copyWith({
    String? id,
    String? userId,
    String? couponId,
    DateTime? date,
  }) {
    return RedemptionCouponModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      couponId: couponId ?? this.couponId,
      date: date ?? this.date,
    );
  }
}
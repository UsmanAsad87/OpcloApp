class WalletCouponModel {
  String id;
  String userId;
  String couponId;
  DateTime date;

  WalletCouponModel({
    required this.id,
    required this.userId,
    required this.couponId,
    required this.date,
  });

  // Factory method to create an instance from a Firestore document
  factory WalletCouponModel.fromMap(Map<String, dynamic> map,) {
    return WalletCouponModel(
      id:  map['id'],
      userId: map['userId'] as String,
      couponId: map['couponId'] as String,
      date:DateTime.parse(map['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'userId': userId,
      'couponId': couponId,
      'date': date.toIso8601String(),
    };
  }

  WalletCouponModel copyWith({
    String? id,
    String? userId,
    String? couponId,
    DateTime? date,
  }) {
    return WalletCouponModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      couponId: couponId ?? this.couponId,
      date: date ?? this.date,
    );
  }
}
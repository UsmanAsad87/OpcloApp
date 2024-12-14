import '../commons/common_enum/coupon_type/coupon_type.dart';
import '../commons/common_enum/coupons_category_enum/coupon_category.dart';

class CouponModel{
  final String id;
  final String placeName;
  final String detail;
  final String shortDescription;
  final String title;
  final String logo;
  final CouponCategory couponCategory;
  final CouponTypeEnum type;
  final String link;
  final DateTime createdAt;
  final DateTime expiryDate;
  final List<String>? likes;
  final List<String>? dislikes;
  final bool isPremium;

  CouponModel({
    required this.id,
    required this.placeName,
    required this.detail,
    required this.shortDescription,
    required this.couponCategory,
    required this.title,
    // required this.sale,
    required this.logo,
    required this.type,
    // required this.inStore,
    required this.link,
    required this.createdAt,
    required this.expiryDate,
    required this.isPremium,
    this.likes,
    this.dislikes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'placeName' : placeName,
      'detail': detail,
      'shortDescription': shortDescription,
      'title': title,
      'logo' : logo,
      'couponCategory' : couponCategory.name,
      'type': type.type,
      'link' : link,
      'createdAt': createdAt.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'likes': likes,
      'dislikes': dislikes,
      'isPremium' : isPremium
    };
  }

  factory CouponModel.fromMap(Map<String, dynamic> map) {
    return CouponModel(
      id: map['id'],
      placeName : map['placeName'],
      detail: map['detail'],
      shortDescription: map['shortDescription'],
      title: map['title'],
      // sale: map['sale'],
      logo: map['logo'],
      couponCategory : (map['couponCategory'] as String).toCouponCategoryEnum(),
      type: (map['type'] as String).toCouponTypeEnum(),
      // inStore: map['inStore'],
      link: map['link'],
      createdAt: DateTime.parse(map['createdAt']),
      expiryDate: DateTime.parse(map['expiryDate']),
      likes: List<String>.from(map['likes'] ?? []),
      dislikes: List<String>.from(map['dislikes'] ?? []),
      isPremium:  map['isPremium'] ?? false,
    );
  }

  CouponModel copyWith({
    String? id,
    String? placeName,
    String? detail,
    String? shortDescription,
    String? title,
    // int? sale,
    String? logo,
    CouponCategory? couponCategory,
    CouponTypeEnum? type,
    // bool? inStore,
    String? link,
    DateTime? createdAt,
    DateTime? expiryDate,
    List<String>? likes,
    List<String>? dislikes,
    bool? isPremium
  }) {
    return CouponModel(
        id: id ?? this.id,
        placeName: placeName ?? this.placeName,
        detail: detail ?? this.detail,
        shortDescription: shortDescription ?? this.shortDescription,
        title: title ?? this.title,
        logo : logo ?? this.logo,
        couponCategory : couponCategory ?? this.couponCategory,
        type: type ?? this.type,
        // inStore: inStore ?? this.inStore,
        link: link ?? this.link,
        createdAt: createdAt ?? this.createdAt,
        expiryDate: expiryDate ?? this.expiryDate,
        likes: likes ?? this.likes,
        dislikes: dislikes ?? this.dislikes,
        isPremium: isPremium ?? this.isPremium
    );
  }
}
// class CouponModel{
//   final String id;
//   final String placeName;
//   final String detail;
//   final String shortDescription;
//   final int sale;
//   final String logo;
//   final CouponCategory couponCategory;
//   final bool inStore;
//   final DateTime createdAt;
//   final DateTime expiryDate;
//   final List<String>? likes;
//   final List<String>? dislikes;
//   final bool isPremium;
//
//   CouponModel({
//     required this.id,
//     required this.placeName,
//     required this.detail,
//     required this.shortDescription,
//     required this.couponCategory,
//     required this.sale,
//     required this.logo,
//     required this.inStore,
//     required this.createdAt,
//     required this.expiryDate,
//     required this.isPremium,
//     this.likes,
//     this.dislikes,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'placeName' : placeName,
//       'detail': detail,
//       'shortDescription': shortDescription,
//       'sale': sale,
//       'logo' : logo,
//       'couponCategory' : couponCategory.name,
//       'inStore': inStore,
//       'createdAt': createdAt.toIso8601String(),
//       'expiryDate': expiryDate.toIso8601String(),
//       'likes': likes,
//       'dislikes': dislikes,
//       'isPremium' : isPremium
//     };
//   }
//
//   factory CouponModel.fromMap(Map<String, dynamic> map) {
//     return CouponModel(
//       id: map['id'],
//       placeName : map['placeName'],
//       detail: map['detail'],
//       shortDescription: map['shortDescription'],
//       sale: map['sale'],
//       logo: map['logo'],
//       couponCategory : (map['couponCategory'] as String).toCouponCategoryEnum(),
//       inStore: map['inStore'],
//       createdAt: DateTime.parse(map['createdAt']),
//       expiryDate: DateTime.parse(map['expiryDate']),
//       likes: List<String>.from(map['likes'] ?? []),
//       dislikes: List<String>.from(map['dislikes'] ?? []),
//       isPremium:  map['isPremium'] ?? false,
//     );
//   }
//
//   CouponModel copyWith({
//     String? id,
//     String? placeName,
//     String? detail,
//     String? shortDescription,
//     int? sale,
//     String? logo,
//     CouponCategory? couponCategory,
//     bool? inStore,
//     DateTime? createdAt,
//     DateTime? expiryDate,
//     List<String>? likes,
//     List<String>? dislikes,
//     bool? isPremium
//   }) {
//     return CouponModel(
//         id: id ?? this.id,
//         placeName: placeName ?? this.placeName,
//         detail: detail ?? this.detail,
//         shortDescription: shortDescription ?? this.shortDescription,
//         sale: sale ?? this.sale,
//         logo : logo ?? this.logo,
//         couponCategory : couponCategory ?? this.couponCategory,
//         inStore: inStore ?? this.inStore,
//         createdAt: createdAt ?? this.createdAt,
//         expiryDate: expiryDate ?? this.expiryDate,
//         likes: likes ?? this.likes,
//         dislikes: dislikes ?? this.dislikes,
//         isPremium: isPremium ?? this.isPremium
//     );
//   }
// }
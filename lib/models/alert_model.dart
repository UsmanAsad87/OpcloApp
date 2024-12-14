import 'package:opclo/commons/common_enum/alert_type.dart';
import 'alert_comment_model/alert_comment_model.dart';

class AlertModel {
  final String id;
  final String fsqId;
  final String placeName;
  final String userId;
  final AlertTypeEnum option;
  // final List<AlertCommentModel>? comments;
  final DateTime date;
  final DateTime uploadDate;

  AlertModel({
    required this.id,
    required this.fsqId,
    required this.placeName,
    required this.userId,
    required this.option,
    // this.comments,
    required this.date,
    required this.uploadDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fsqId': fsqId,
      'placeName': placeName,
      'userId': userId,
      'option': option.type,
      // 'comments': comments?.map((comment) => comment.toMap()).toList(),
      'date': date.toIso8601String(),
      'uploadDate': uploadDate.toIso8601String(),
    };
  }

  factory AlertModel.fromMap(Map<String, dynamic> map) {
    return AlertModel(
      id: map['id'],
      fsqId: map['fsqId'],
      placeName: map['placeName'] ?? '',
      userId: map['userId'],
      option: (map['option'] as String).toAlertTypeEnum(),
      // comments: map['comments'] == null
      //     ? null
      //     : (map['comments'] as List<dynamic>)
      //         .map((comment) => AlertCommentModel.fromMap(comment))
      //         .toList(),
      date: DateTime.parse(map['date']),
      uploadDate: map['uploadDate'] == null
          ? DateTime.parse(map['date'])
          : DateTime.parse(map['uploadDate']),
    );
  }

  AlertModel copyWith(
      {String? id,
      String? fsqId,
      String? userId,
      AlertTypeEnum? option,
      DateTime? date,
      DateTime? uploadDate,
      List<AlertCommentModel>? comments,
      String? placeName}) {
    return AlertModel(
      id: id ?? this.id,
      fsqId: fsqId ?? this.fsqId,
      placeName: placeName ?? this.placeName,
      userId: userId ?? this.userId,
      option: option ?? this.option,
      // comments: comments ?? this.comments,
      uploadDate: uploadDate ?? this.uploadDate,
      date: date ?? this.date,
    );
  }
}

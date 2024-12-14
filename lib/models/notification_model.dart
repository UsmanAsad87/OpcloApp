// import 'package:barber_app/core/enums/notification_type_enum.dart';

import 'package:opclo/commons/common_enum/alert_type.dart';
import 'package:opclo/commons/common_enum/reminder_option/repeat_option.dart';

import '../commons/common_enum/notification_enum.dart';

class NotificationModel {
  final String title;
  final String notificationId;
  final String description;
  final DateTime createdAt;
  final String placeId;
  final String? placeName;
  final NotificationEnum notificationType;
  final int? reminderId;
  final AlertTypeEnum? alertType;
  final RepeatOption? repeatOption;

//<editor-fold desc="Data Methods">
  const NotificationModel(
      {required this.title,
      required this.notificationId,
      required this.description,
      required this.createdAt,
      required this.placeId,
      required this.notificationType,
        this.reminderId,
      this.placeName,
      this.repeatOption,
      this.alertType});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationModel &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          notificationId == other.notificationId &&
          description == other.description &&
          createdAt == other.createdAt &&
          placeId == other.placeId
      // notificationTypeEnum == other.notificationTypeEnum &&
      );

  @override
  int get hashCode =>
      title.hashCode ^
      notificationId.hashCode ^
      description.hashCode ^
      createdAt.hashCode;

  // notificationTypeEnum.hashCode;

  @override
  String toString() {
    return '{title: $title,notificationId: $notificationId,description: $description,createdAt: ${createdAt.millisecondsSinceEpoch},}';
  }

  NotificationModel copyWith(
      {String? title,
      String? description,
      String? notificationId,
      DateTime? createdAt,
      String? placeId,
      String? placeName,
        int? reminderId,
      NotificationEnum? notificationType,
      AlertTypeEnum? alertType,
      RepeatOption? repeatOption
      // NotificationTypeEnum? notificationTypeEnum,
      }) {
    return NotificationModel(
        title: title ?? this.title,
        description: description ?? this.description,
        notificationId: notificationId ?? this.notificationId,
        createdAt: createdAt ?? this.createdAt,
        placeId: placeId ?? this.placeId,
        placeName: placeName ?? this.placeName,
        notificationType: notificationType ?? this.notificationType,
        alertType: alertType ?? this.alertType
        // notificationTypeEnum: notificationTypeEnum ?? this.notificationTypeEnum,
        );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'notificationId': notificationId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'placeId': placeId,
      'placeName': placeName,
      'reminderId' : reminderId,
      'notificationType': notificationType.type,
      'alertType': alertType?.type,
      'repeatOption' : repeatOption?.name
      // 'notificationTypeEnum': notificationTypeEnum.type,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
        title: map['title'] as String,
        description: map['description'] as String,
        notificationId: map['notificationId'] as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
        placeId: map['placeId'],
        placeName: map['placeName'],
        reminderId: map['reminderId'],
        notificationType:
            (map['notificationType'] as String).toNotificationTypeEnum(),
        alertType: map['alertType'] != null
            ? (map['alertType'] as String).toAlertTypeEnum()
            : null,
        repeatOption: map['repeatOption'] != null
            ? repeatOptionFromString( map['repeatOption'])
            : null
        // notificationTypeEnum:
        //     (map['notificationTypeEnum'] as String).toNotificationTypeEnum(),
        );
  }
}

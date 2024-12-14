import '../commons/common_enum/reminder_option/repeat_option.dart';

class ReminderModel {
  final String id;
  final String cancellationId;
  final String userId;
  final String userName;
  final String fsqId;
  final String placeName;
  final double lat;
  final double lng;
  final DateTime reminderDate;
  final RepeatOption repeatOption;
  // final bool inviteFriend;
  final bool addToCalendar;

  ReminderModel({
    required this.id,
    required this.cancellationId,
    required this.userId,
    required this.userName,
    required this.fsqId,
    required this.placeName,
    required this.lat,
    required this.lng,
    required this.reminderDate,
    required this.repeatOption,
    // required this.inviteFriend,
    required this.addToCalendar,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cancellationId':cancellationId,
      'userId': userId,
      'userName': userName,
      'fsqId': fsqId,
      'placeName': placeName,
      'lat': lat,
      'lng': lng,
      'reminderDate': reminderDate.toIso8601String(),
      'repeatOption': repeatOption.stringValue,
      // 'inviteFriend': inviteFriend,
      'addToCalendar': addToCalendar,
    };
  }

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id'],
      cancellationId: map['cancellationId'],
      userId: map['userId'],
      userName: map['userName'],
      fsqId: map['fsqId'],
      placeName: map['placeName'],
      lat: map['lat'],
      lng: map['lng'],
      reminderDate: DateTime.parse(map['reminderDate']),
      repeatOption: repeatOptionFromString(map['repeatOption']),
      // inviteFriend: map['inviteFriend'],
      addToCalendar: map['addToCalendar'],
    );
  }

  ReminderModel copyWith({
    String? id,
    String? cancellationId,
    String? userId,
    String? userName,
    String? fsqId,
    String? placeName,
    double? lat,
    double? lng,
    DateTime? reminderDate,
    RepeatOption? repeatOption,
    // bool? inviteFriend,
    bool? addToCalendar,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      cancellationId: cancellationId ?? this.cancellationId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      fsqId: fsqId ?? this.fsqId,
      placeName: placeName ?? this.placeName,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      reminderDate: reminderDate ?? this.reminderDate,
      repeatOption: repeatOption ?? this.repeatOption,
      // inviteFriend: inviteFriend ?? this.inviteFriend,
      addToCalendar: addToCalendar ?? this.addToCalendar,
    );
  }
}
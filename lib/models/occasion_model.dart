import 'package:opclo/commons/common_enum/occasion_option_enum/occasion_option_enum.dart';

import '../commons/common_enum/occassion_type_enum/occasion_type_enum.dart';

class OccasionModel{
  final String id;
  final String userId;
  final String fsqId;
  final OccasionTypeEnum occasionType;
  final OccasionOptionEnum option;
  final DateTime date;

  OccasionModel({
    required this.id,
    required this.fsqId,
    required this.userId,
    required this.occasionType,
    required this.option,
    required this.date,
  });

  factory OccasionModel.fromMap(Map<String, dynamic> map) {
    return OccasionModel(
      id: map['id'] ?? '',
      fsqId: map['fsqId'] ?? '',
      userId: map['userId'] ?? '',
      occasionType: (map['occasionType'] as String).toOccasionTypeEnum(),
      option: (map['option'] as String).toOccasionOptionEnum(),
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fsqId': fsqId,
      'userId': userId,
      'occasionType': occasionType.type,
      'option': option.type,
      'date': date.toIso8601String(),
    };
  }

  OccasionModel copyWith({
    String? id,
    String? locationId,
    String? userId,
    OccasionTypeEnum? occasionType,
    OccasionOptionEnum? option,
    DateTime? date,
  }) {
    return OccasionModel(
      id: id ?? this.id,
      fsqId: locationId ?? this.fsqId,
      userId: userId ?? this.userId,
      option: option ?? this.option,
      occasionType: occasionType ?? this.occasionType,
      date: date ?? this.date,
    );
  }
}
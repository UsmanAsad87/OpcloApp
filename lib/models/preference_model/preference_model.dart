import '../../commons/common_enum/goal_enum/goal_enum.dart';
class PreferenceModel {
  final String id;
  final List<GoalEnum> goals;
  final DateTime date;

  PreferenceModel({
    required this.id,
    required this.goals,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'goal': goals.map((g) => g.toString().split('.').last).toList(),
      'date': date.toIso8601String(),
    };
  }


  factory PreferenceModel.fromMap(Map<String, dynamic> map, String documentId) {
    return PreferenceModel(
      id: documentId,
      goals: (map['goal'] as List<dynamic>).map((g) => GoalEnum.values.firstWhere(
            (e) => e.toString().split('.').last == g,
        orElse: () => GoalEnum.achieveTravelGoals,
      )).toList(),
      // goal: (map['goal'] as String).toGoalEnum(),
      date: DateTime.parse(map['date'] as String),
    );
  }

  PreferenceModel copyWith({
    String? id,
    List<GoalEnum>? goal,
    DateTime? date,
  }) {
    return PreferenceModel(
      id: id ?? this.id,
      goals: goal ?? this.goals,
      date: date ?? this.date,
    );
  }
}
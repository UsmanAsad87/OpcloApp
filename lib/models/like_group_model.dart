class LikeGroupModel{
  final String id;
  final String groupName;
  final DateTime createdAt;
  final int orderIndex;
  final List<dynamic> likePlaces;

  LikeGroupModel({
    required this.id,
    required this.groupName,
    required this.createdAt,
    required this.orderIndex,
    required this.likePlaces
  });

  // Convert LikeGroupModel to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupName': groupName,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'likePlaces' : likePlaces,
      'orderIndex' : orderIndex,
    };
  }

  // Create LikeGroupModel from a map
  factory LikeGroupModel.fromMap(Map<String, dynamic> map) {
    return LikeGroupModel(
      id: map['id'],
      groupName: map['groupName'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      likePlaces: map['likePlaces'],
        orderIndex: map['orderIndex'] ?? 0
    );
  }

  // Create a copy of LikeGroupModel with new values
  LikeGroupModel copyWith({
    String? id,
    String? groupName,
    DateTime? createdAt,
    int? orderIndex,
    List<dynamic>? likePlaces
  }) {
    return LikeGroupModel(
      id: id ?? this.id,
      groupName: groupName ?? this.groupName,
      createdAt: createdAt ?? this.createdAt,
      likePlaces: likePlaces ?? this.likePlaces,
        orderIndex: orderIndex ?? this.orderIndex
    );
  }
}
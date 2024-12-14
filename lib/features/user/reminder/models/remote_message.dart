class RemoteMessage{
  final String id;
  final String title;
  final String body;


  RemoteMessage({
    required this.id,
    required this.title,
    required this.body,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
    };
  }

  factory RemoteMessage.fromMap(Map<String, dynamic> map) {
    return RemoteMessage(
      id: map['id'],
      title: map['title'],
      body: map['body'],
    );
  }

  RemoteMessage copyWith({
    String? id,
    String? title,
    String? body,
  }) {
    return RemoteMessage(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }
}
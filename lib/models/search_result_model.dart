class SearchResult {
  final String? placeId;
  final String query;
  final DateTime timestamp;

  SearchResult(
      {this.placeId,
      required this.query,
      required this.timestamp});

  // Convert SearchResult to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'placeId': placeId,
      'query': query,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create SearchResult object from JSON object
  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      placeId: json['placeId'] ?? '',
      query: json['query'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

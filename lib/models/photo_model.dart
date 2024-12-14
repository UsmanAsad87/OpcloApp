class PhotoModel {
  final String prefix;
  final String suffix;

  PhotoModel({required this.prefix, required this.suffix});

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      prefix: json['prefix'] ?? '',
      suffix: json['suffix'] ?? '',
    );
  }
}
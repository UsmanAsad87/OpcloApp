import 'dart:ui';

import '../commons/common_enum/banner_type.dart';

class CarouselModel {
  final String id;
  final String image;
  final String header;
  final String shortDesc;
  final String articleTitle;
  final String articleDesc;
  final Color color1;
  final Color color2;
  final BannerTypeEnum bannerType;
  final bool clickable;
  final String buttonText;
  final String link;

  CarouselModel({
    required this.id,
    required this.image,
    required this.header,
    required this.shortDesc,
    required this.articleTitle,
    required this.articleDesc,
    required this.color1,
    required this.color2,
    required this.bannerType,
    required this.clickable,
    required this.buttonText,
    required this.link,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'header': header,
      'image': image,
      'shortDesc': shortDesc,
      'articleTitle': articleTitle,
      'articleDesc': articleDesc,
      'color1': color1.value.toRadixString(16),
      'color2': color2.value.toRadixString(16),
      'bannerType' : bannerType.type,
      'clickable' : clickable,
      'buttonText': buttonText,
      'link' : link
    };
  }

  factory CarouselModel.fromMap(Map<String, dynamic> map) {
    return CarouselModel(
      id: map['id'] ?? '',
      header: map['header'] ?? '',
      image: map['image'] ?? '',
      shortDesc: map['shortDesc'] ?? '',
        articleTitle: map['articleTitle'] ?? '',
        articleDesc: map['articleDesc'] ?? '',
      color1: Color(int.parse(map['color1'], radix: 16)),
      color2: Color(int.parse(map['color2'], radix: 16)),
      bannerType: (map['bannerType'] as String).toBannerTypeEnum(),
        clickable : map['clickable'] ?? '',
        buttonText: map['buttonText'] ?? '',
        link: map['link'] ?? ''
    );
  }

  CarouselModel copyWith({
    String? id,
    String? header,
    String? image,
    String? detail,
    String? articleTitle,
    String? articleDesc,
    Color? color1,
    Color? color2,
    BannerTypeEnum? bannerType,
    bool? clickable,
    String? buttonText,
    String? link
  }) {
    return CarouselModel(
      id: id ?? this.id,
      header: header ?? this.header,
      image: image ?? this.image,
      shortDesc: detail ?? this.shortDesc,
        articleTitle: articleTitle ?? this.articleTitle,
        articleDesc: articleDesc ?? this.articleDesc,
        color1: color1 ?? this.color1,
        color2: color1 ?? this.color2,
      bannerType: bannerType ?? this.bannerType,
        clickable: clickable ?? this.clickable,
        buttonText: buttonText ?? this.buttonText,
      link: link ?? this.link
    );
  }

}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/font_manager.dart';

import '../common_shimmer/loading_images_shimmer.dart';

class CachedCircularNetworkImageWidget extends StatelessWidget {
  const CachedCircularNetworkImageWidget({
    super.key,
    required this.image,
    required this.size,
    this.name = 'UnKnown',
  });

  final String image;
  final int size;
  final String name;

  @override
  Widget build(BuildContext context) {
    return image == ''
        ? Initicon(
            text: name,
            backgroundColor: context.primaryColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(1000),
            size: size.h,
          )
        : SizedBox(
            width: size.w,
            height: size.h,
            child: CachedNetworkImage(
              imageUrl: image,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => Center(
                child: ShimmerWidget(
                  border: 100.r,
                ),
              ),
              errorWidget: (context, url, error) => Center(
                child: Initicon(
                  text: name,
                  backgroundColor: context.primaryColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(1000),
                  size: size.h,
                ),
              ),
            ),
          );
  }
}

class CachedCircularNetworkImageWidgetCoupon extends StatelessWidget {
  const CachedCircularNetworkImageWidgetCoupon({
    super.key,
    required this.image,
    required this.size,
    this.name = 'UnKnown',
  });

  final String image;
  final int size;
  final String name;

  @override
  Widget build(BuildContext context) {
    return image == ''
        ? CircleAvatar(
            radius: size / 2,
            backgroundColor: context.primaryColor.withOpacity(0.5),
            child: Text(
              'Coming\nSoon',
                textAlign: TextAlign.center,
              style: getSemiBoldStyle(
                  color: context.whiteColor, fontSize: MyFonts.size28),
            ),
          )
        : SizedBox(
            width: size.w,
            height: size.h,
            child: CachedNetworkImage(
              imageUrl: image,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => Center(
                child: ShimmerWidget(
                  border: 100.r,
                ),
              ),
              errorWidget: (context, url, error) => Center(
                child: Initicon(
                  text: name,
                  backgroundColor: context.primaryColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(1000),
                  size: size.h,
                ),
              ),
            ),
          );
  }
}

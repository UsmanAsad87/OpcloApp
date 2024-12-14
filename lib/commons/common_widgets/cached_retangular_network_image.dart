import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/font_manager.dart';

import '../common_imports/common_libs.dart';
import '../common_shimmer/loading_images_shimmer.dart';

class CachedRectangularNetworkImageWidget extends StatelessWidget {
  const CachedRectangularNetworkImageWidget({
    super.key,
    required this.image,
    required this.width,
    required this.height,
    this.fit,
    this.name = 'unknown'
  });

  final String image;
  final int width;
  final int height;
  final BoxFit? fit;
  final String name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      height: height.h,
      child: image==''?
      Initicon(
        text: name,
        style: getSemiBoldStyle(color: MyColors.white, fontSize: MyFonts.size28),
        backgroundColor: context.primaryColor.withOpacity(0.2),
       borderRadius: BorderRadius.circular(0),
        // size: size.h,
      ): CachedNetworkImage(
        imageUrl: image,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5.r),
            image:
                DecorationImage(image: imageProvider, fit: fit ?? BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => const Center(child: ShimmerWidget()),
        errorWidget: (context, url, error) => Center(
            child: SizedBox(
                width: 20.w, height: 20.h, child: const Icon(Icons.error))),
      ),
    );
  }
}
class CachedRectangularNetworkImageWidgetCoupon extends StatelessWidget {
  const CachedRectangularNetworkImageWidgetCoupon({
    super.key,
    required this.image,
    required this.width,
    required this.height,

    this.fit,
    this.name = 'unknown', required this.fontSize
  });

  final String image;
  final int width;
  final int height;
  final double fontSize;
  final BoxFit? fit;
  final String name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      height: height.h,
      child: image==''?
      Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color:context.primaryColor.withOpacity(0.5) ,
          borderRadius: BorderRadius.circular(5.r)
        ),
        child: Center(
          child: Text(
            'Coming\nSoon',
            textAlign: TextAlign.center,
            style: getSemiBoldStyle(
                color: context.whiteColor, fontSize: fontSize),
          ),
        ),
      ): CachedNetworkImage(
        imageUrl: image,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5.r),
            image:
            DecorationImage(image: imageProvider, fit: fit ?? BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => const Center(child: ShimmerWidget()),
        errorWidget: (context, url, error) => Center(
            child: SizedBox(
                width: 20.w, height: 20.h, child: const Icon(Icons.error))),
      ),
    );
  }
}

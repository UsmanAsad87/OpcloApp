import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_shimmer/loading_images_shimmer.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullScreenImageViewer extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  FullScreenImageViewer({required this.imageUrls, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.titleColor..withOpacity(.8),
      child: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: imageUrls.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(imageUrls[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 4,
              );
            },
            // loadingBuilder: (context, progress) => ShimmerWidget(
            //   height: 350.h,
            // ),
            pageController: PageController(initialPage: initialIndex),
            scrollPhysics: BouncingScrollPhysics(),
            backgroundDecoration: BoxDecoration(
              color: Colors.black,
            ),
            loadingBuilder: (context, progress) {
              return Center(
                child: CircularProgressIndicator(
                  color: context.primaryColor,
                  value: progress == null ? null : progress.cumulativeBytesLoaded / progress.expectedTotalBytes!,
                ),
              );
            },
          ),
          Material(
            color: context.titleColor..withOpacity(.8),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      color: context.whiteColor,
                      size: 26.sp,
                    ),
                  ),
                  padding16,
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/restaurant/controller/places_controller.dart';
import 'package:opclo/features/user/restaurant/views/full_screen_image_view.dart';

import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_shimmer/loading_images_shimmer.dart';
import '../../../../commons/common_widgets/cached_retangular_network_image.dart';

class PlacePhotosWidget extends StatelessWidget {
  const PlacePhotosWidget({
    super.key, required this.fsqId,
  });

  final String fsqId;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return ref
          .watch(getPhotosProvider(fsqId))
          .when(
          data: (photos) {
            return Container(
              height: 143.h,
              padding: EdgeInsets.only(left: 12.w),
              child: photos.length <= 0
                  ? Center(
                child: Text(
                  'No photos',
                  style: getSemiBoldStyle(
                      color: context.titleColor
                          .withOpacity(.6)),
                ),
              )
                  : ListView.builder(
                  itemCount: photos.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final photo = photos[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 6.w, vertical: 8.h),
                      child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return FullScreenImageViewer(
                                    imageUrls: photos
                                        .map((photo) =>
                                    '${photo.prefix}800x600${photo.suffix}')
                                        .toList(),
                                    initialIndex: index,
                                  );
                                });
                          },
                          child:
                          CachedRectangularNetworkImageWidget(
                            image:
                            '${photo.prefix}183x138${photo.suffix}',
                            height: 140,
                            width: 180,
                          )
                      ),
                    );
                  }),
            );
          },
          error: (error, stackTrace) => Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Text(
                'No photos',
                style: getSemiBoldStyle(
                    color:
                    context.titleColor.withOpacity(.6)),
              ),
            ),
          ),
          loading: () => ShimmerWidget(
            width: 100.w,
            height: 100.h,
          ));
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';

import '../../../../commons/common_shimmer/loading_images_shimmer.dart';
import '../../../../models/place_model.dart';
import '../../../../routes/route_manager.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/my_colors.dart';
import '../../../../utils/thems/styles_manager.dart';
import '../../favorites/controller/distance_notifier.dart';
import '../../search/controller/search_limit.dart';
import '../../welcome/widgets/item_contaianer.dart';

class SuggestionContainer extends ConsumerWidget {
  final PlaceModel placeModel;
  final int index;

  const SuggestionContainer({
    super.key,
    required this.placeModel,
    required this.index,
  });

  @override
  Widget build(BuildContext context, ref) {
    final distanceInMI = ((placeModel.distance?.toDouble() ?? 0) * 0.000621371);
    return InkWell(
      onTap: () {
        final isPrem =
            ref.read(authNotifierCtr).userModel?.subscriptionIsValid ?? false;
        if (!isPrem) {
          SearchLimiter.incrementSearchCount();
        }
        Navigator.pushNamed(context, AppRoutes.detailResturantScreen,
            arguments: {'placeModel': placeModel});
      },
      child: Container(
        padding: EdgeInsets.all(12.r),
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: context.titleColor, width: 1))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: context.primaryColor.withOpacity(.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: context.whiteColor,
                    )),
                Container(
                  width: 220.w,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        placeModel.placeName,
                        overflow: TextOverflow.ellipsis,
                        style: getSemiBoldStyle(
                            color: context.titleColor,
                            fontSize: MyFonts.size13),
                      ),
                      Text(
                        placeModel.locationName,
                        overflow: TextOverflow.ellipsis,
                        style: getRegularStyle(
                            color: context.titleColor.withOpacity(.4),
                            fontSize: MyFonts.size11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            placeModel.distance != null
                ? Text(
                    index == 0
                        ? 'Nearest'
                        : '${distanceInMI.toStringAsFixed(1)} mi',
                    style: getMediumStyle(
                        color: context.titleColor, fontSize: MyFonts.size10),
                  )
                : ref.watch(calculateDistanceNotifierProvider(placeModel)).when(
                      data: (distance) {
                        return Text(
                          index == 0
                              ? 'Nearest'
                              : '${distance.toStringAsFixed(1)} mi',
                          style: getMediumStyle(
                              color: context.titleColor,
                              fontSize: MyFonts.size10),
                        );
                      },
                      loading: () => ShimmerWidget(
                        height: 16.h,
                        width: 30.w,
                      ),
                      error: (error, stackTrace) => const Text(' '),
                    ),
          ],
        ),
      ),
    );
  }
}

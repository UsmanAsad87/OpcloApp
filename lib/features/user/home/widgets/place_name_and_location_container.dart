import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_controller.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/app_constants.dart';

import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_shimmer/loading_images_shimmer.dart';
import '../../../../models/place_model.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../favorites/controller/distance_notifier.dart';
import '../../welcome/widgets/item_contaianer.dart';

class PlaceNameAndLocationContainer extends ConsumerWidget {
  final PlaceModel place;
  final String title;
  final String subTitle;
  final double? horizontalMargin;

  const PlaceNameAndLocationContainer(
      {Key? key,
      required String this.title,
      required String this.subTitle,
      this.horizontalMargin,
      required this.place})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.detailResturantScreen,
            arguments: {
              'placeModel': place,
            });
      },
      child: Container(
          padding: EdgeInsets.all(12.r),
          margin: EdgeInsets.symmetric(
              vertical: 8.h,
              horizontal: horizontalMargin ?? AppConstants.horizontalPadding),
          decoration: BoxDecoration(
              color: MyColors.white,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: Offset(0, 0),
                  color: context.titleColor.withOpacity(.10),
                ),
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 235.w,
                        child: Text(
                          title,
                          style: getSemiBoldStyle(
                            color: context.titleColor,
                            fontSize: MyFonts.size16,
                          ),
                        ),
                      ),
                      place.distance != null
                          ? Text(
                              '${((place.distance?.toDouble() ?? 0) * 0.000621371).toStringAsFixed(1)} mi',
                              style: getMediumStyle(
                                  color: context.titleColor,
                                  fontSize: MyFonts.size10),
                            )
                          : ref
                              .watch(calculateDistanceNotifierProvider(place))
                              .when(
                                data: (distance) => Text(
                                  '${distance.toStringAsFixed(1)} mi',
                                  style: getMediumStyle(
                                      color: context.titleColor,
                                      fontSize: MyFonts.size10),
                                ),
                                loading: () => ShimmerWidget(
                                  height: 16.h,
                                  width: 30.w,
                                ),
                                error: (error, stackTrace) => Text(' '),
                              ),
                    ],
                  ),
                  SizedBox(
                    width: 250.w,
                    child: Text(
                      subTitle,
                      style: getMediumStyle(
                        color: context.titleColor.withOpacity(.5),
                        fontSize: MyFonts.size13,
                      ),
                    ),
                  )
                ],
              ),
              Icon(
                Icons.arrow_forward_ios_outlined,
                color: context.titleColor,
                size: 18.r,
              )
            ],
          )),
    );
  }
}

class PlaceNameAndLocationContainerQuick extends ConsumerWidget {
  final PlaceModel place;
  final String title;
  final String subTitle;
  final double? horizontalMargin;

  const PlaceNameAndLocationContainerQuick(
      {Key? key,
      required String this.title,
      required String this.subTitle,
      this.horizontalMargin,
      required this.place})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.detailResturantScreen,
            arguments: {
              'placeModel': place,
            });
      },
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) async {
          await ref
              .read(authControllerProvider.notifier)
              .updateQuickAccess(context: context, newId: place.fsqId);
        },
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(
              vertical: 8.h,
              horizontal: horizontalMargin ?? AppConstants.horizontalPadding),
          padding: EdgeInsets.all(20.r),
          child: Icon(Icons.delete, color: Colors.white),
        ),
        child: Container(
            padding: EdgeInsets.all(12.r),
            margin: EdgeInsets.symmetric(
                vertical: 8.h,
                horizontal: horizontalMargin ?? AppConstants.horizontalPadding),
            decoration: BoxDecoration(
                color: MyColors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: Offset(0, 0),
                    color: context.titleColor.withOpacity(.10),
                  ),
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 235.w,
                          child: Text(
                            title,
                            style: getSemiBoldStyle(
                              color: context.titleColor,
                              fontSize: MyFonts.size16,
                            ),
                          ),
                        ),
                        SizedBox(),
                        // place.distance != null
                        //     ? Text(
                        //   '${((place.distance?.toDouble() ?? 0) * 0.000621371).toStringAsFixed(1)} mi',
                        //   style: getMediumStyle(
                        //       color: context.titleColor,
                        //       fontSize: MyFonts.size10),
                        // ) : ref.watch(distanceInMilesDoubleQuickProvider(place)).when(
                        //   data: (distance) => Text(
                        //     '${distance.toStringAsFixed(1)} mi',
                        //     style: getMediumStyle(
                        //         color: context.titleColor,
                        //         fontSize: MyFonts.size10),
                        //   ),
                        //   loading: () => ShimmerWidget(
                        //     height: 16.h,
                        //     width: 30.w,
                        //   ),
                        //   error: (error, stackTrace) => Text(' '),
                        // ),
                      ],
                    ),
                    SizedBox(
                      width: 250.w,
                      child: Text(
                        subTitle,
                        style: getMediumStyle(
                          color: context.titleColor.withOpacity(.5),
                          fontSize: MyFonts.size13,
                        ),
                      ),
                    )
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: context.titleColor,
                  size: 18.r,
                )
              ],
            )),
      ),
    );
  }
}

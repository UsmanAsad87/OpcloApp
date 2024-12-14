import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';
import 'package:opclo/commons/common_functions/show_login.dart';
import 'package:opclo/commons/common_shimmer/loading_images_shimmer.dart';
import 'package:opclo/commons/common_widgets/show_toast.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_controller.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
import 'package:opclo/features/user/location/location_controller/location_notifier_controller.dart';
import 'package:opclo/features/user/location/model/location_detail.dart';
import 'package:opclo/features/user/restaurant/controller/places_controller.dart';
import 'package:opclo/models/favorite_model.dart';
import 'package:opclo/models/photo_model.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/loading.dart';
import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_widgets/cached_retangular_network_image.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../models/place_model.dart';
import '../../../../models/user_model.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/my_colors.dart';
import '../../../../utils/thems/styles_manager.dart';
import '../../favorites/controller/distance_notifier.dart';
import '../../favorites/widgets/favourit_bottom_sheet.dart';
import '../../location/model/location_model.dart';
import '../../restaurant/api/quick_acess_places_api.dart';
import '../../restaurant/controller/quick_access_places_controller.dart';

class ResturantItemContainer extends ConsumerStatefulWidget {
  final PlaceModel? placeModel;
  final double? verticalMargin;
  final double? rightMargin;
  final double? cardWidth;
  final Function()? onTap;

  const ResturantItemContainer({
    super.key,
    this.placeModel,
    this.verticalMargin,
    this.cardWidth,
    this.rightMargin,
    this.onTap,
  });

  @override
  ConsumerState<ResturantItemContainer> createState() =>
      _ResturantItemContainerState();
}

class _ResturantItemContainerState
    extends ConsumerState<ResturantItemContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: widget.cardWidth,
      padding: EdgeInsets.all(12.r),
      margin: EdgeInsets.only(
          top: widget.verticalMargin ?? 8.h,
          bottom: widget.verticalMargin ?? 8.h,
          right: widget.rightMargin ?? 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
          color: context.whiteColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 10.r,
              spreadRadius: 0,
              color: (widget.placeModel?.isOpen ?? false)
                  ? MyColors.shadowColor.withOpacity(.30.r)
                  : MyColors.red.withOpacity(.30.r),
              offset: Offset(0, 1.h),
            )
          ]),
      child: InkWell(
        onTap: widget.onTap ??
            () {
              Navigator.pushNamed(context, AppRoutes.detailResturantScreen,
                  arguments: {'placeModel': widget.placeModel});
            },
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: ref
                        .watch(getPhotosProvider(widget.placeModel!.fsqId))
                        .when(
                            data: (photos) {
                              PhotoModel? photo =
                                  photos.isNotEmpty ? photos[0] : null;
                              return CachedRectangularNetworkImageWidget(
                                image: photo != null
                                    ? '${photo.prefix}320x142${photo.suffix}'
                                    : '',
                                height: 143,
                                width: width.toInt(),
                                name: widget.placeModel?.placeName ?? '',
                              );
                            },
                            error: (error, stackTrace) => SizedBox(
                                  height: 143,
                                  child: Center(
                                    child: Icon(
                                      Icons.info,
                                      color: context.titleColor.withOpacity(.5),
                                    ),
                                  ),
                                ),
                            loading: () => const ShimmerWidget(
                                  height: 132,
                                ))),
                Padding(
                  padding: EdgeInsets.all(AppConstants.allPadding),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 4.r, horizontal: 8.r),
                        decoration: BoxDecoration(
                          color: widget.placeModel?.isOpen ?? true
                              ? MyColors.green
                              : MyColors.red,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          widget.placeModel?.isOpen ?? true ? 'OPEN' : 'CLOSE',
                          style: getMediumStyle(
                              color: context.whiteColor,
                              fontSize: MyFonts.size10),
                        ),
                      ),
                      padding8,
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.r, horizontal: 8.r),
                          decoration: BoxDecoration(
                            color: context.whiteColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: widget.placeModel?.distance != null
                              ? Text(
                                  '${((widget.placeModel?.distance?.toDouble() ?? 0) * 0.000621371).toStringAsFixed(1)} Miles',
                                  style: getMediumStyle(
                                      color: context.titleColor,
                                      fontSize: MyFonts.size10),
                                )
                              : ref
                                  .watch(calculateDistanceNotifierProvider(widget.placeModel!))
                                  .when(
                                    data: (distance) => Text(
                                      '${distance.toStringAsFixed(1)} Miles',
                                      style: getMediumStyle(
                                          color: context.titleColor,
                                          fontSize: MyFonts.size10),
                                    ),
                                    loading: () => ShimmerWidget(
                                      height: 16.h,
                                      width: 30.w,
                                    ),
                                    error: (error, stackTrace) => const SizedBox(),
                                  )),
                    ],
                  ),
                )
              ],
            ),
            padding16,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: (widget.cardWidth ?? 310.w) > 300.w
                              ? 220.w
                              : 170.w,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              widget.placeModel?.placeName ?? '',
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: getSemiBoldStyle(
                                  color: context.titleColor,
                                  fontSize: MyFonts.size16),
                            ),
                          ),
                        ),
                        padding8,
                        Container(
                          padding: EdgeInsets.all(4.r),
                          decoration: BoxDecoration(
                              color:
                                  MyColors.starContainerColor.withOpacity(.1.r),
                              borderRadius: BorderRadius.circular(4.r)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: MyColors.starContainerColor,
                                size: 14.r,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                widget.placeModel?.rating.toString() ?? '0.0',
                                style: getSemiBoldStyle(
                                    color: context.titleColor,
                                    fontSize: MyFonts.size10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    padding4,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          AppAssets.container_location,
                          width: 14.w,
                          height: 15.h,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        SizedBox(
                          width: (widget.cardWidth ?? 310.w) > 300.w
                              ? 220.w
                              : 190.w,
                          child: Text(
                            widget.placeModel?.locationName ?? '',
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: getMediumStyle(
                                color: context.titleColor.withOpacity(.5),
                                fontSize: MyFonts.size12),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Consumer(builder: (context, ref, child) {
                  return ref
                      .watch(getFavouriteByFsq(widget.placeModel?.fsqId ?? ''))
                      .when(
                          data: (fav) {
                            final bool isLike = fav != null;
                            return InkWell(
                              overlayColor:
                                  WidgetStateProperty.all(Colors.transparent),
                              onTap: () {
                                UserModel? user =
                                    ref.watch(authNotifierCtr).userModel;
                                if (user != null) {
                                  if (isLike) {
                                    ref
                                        .read(authControllerProvider.notifier)
                                        .updateFavorites(
                                            context: context,
                                            favoriteModel: fav,
                                            ref: ref);
                                  } else {
                                    showModalBottomSheet(
                                        context: context,
                                        enableDrag: true,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) {
                                          return FavoriteBottomSheet(
                                              placeModel: widget.placeModel!);
                                        });
                                  }
                                } else {
                                  showLogInBottomSheet(context: context);
                                }
                              },
                              child: Container(
                                  width: 40.w,
                                  height: 40.h,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 10.w),
                                  decoration: BoxDecoration(
                                      color:
                                          MyColors.heartColor.withOpacity(.3),
                                      borderRadius: BorderRadius.circular(8.r)),
                                  child: Icon(
                                    CupertinoIcons.suit_heart_fill,
                                    size: 23.sp,
                                    color: isLike
                                        ? MyColors.redText
                                        : MyColors.heartColor,
                                  )),
                            );
                          },
                          error: (e, s) => const SizedBox(),
                          loading: () => const LoadingWidget());
                })
              ],
            )
          ],
        ),
      ),
    );
  }
}

  //TODO: calculate distance of the places


//
// final distanceInMilesDoubleProvider =
//     FutureProvider.family((ref, PlaceModel place) async {
//       final locationRef = ref.read(locationDetailNotifierCtr).locationDetail;
//       final UserModel? user = ref.read(authNotifierCtr).userModel;
//       double lat1 = 37.4219983;
//       double lon1 = -122.084;
//
//       if (locationRef != null) {
//         lat1 = locationRef.latitude;
//         lon1 = locationRef.longitude;
//       } else {
//         final location = await locationCheck();
//         lat1 = location?.latitude ??
//             user?.homeAddress?.latitude ??
//             user?.workAddress?.latitude ??
//             0;
//         lon1 = location?.longitude ??
//             user?.homeAddress?.longitude ??
//             user?.workAddress?.longitude ??
//             0; // Fix here
//       }
//   return await distanceInMilesInDouble(place, lat1, lon1);
// });
//
// Future<double> distanceInMilesInDouble(PlaceModel place, lat1, lon1) async {
//   const earthRadiusMiles = 3958.8;
//   // final locationRef = ref.read(locationDetailNotifierCtr).locationDetail;
//   // final UserModel? user = ref.read(authNotifierCtr).userModel;
//   // double lat1 = 0;
//   // double lon1 = 0;
//   // double lat1 = 37.4219983;
//   // double lon1 = -122.084;
//   //
//   //  if (locationRef != null) {
//   //    lat1 = locationRef.latitude;
//   //    lon1 = locationRef.longitude;
//   //  } else {
//   //    final location = await locationCheck();
//   //    lat1 = location?.latitude ??
//   //        user?.homeAddress?.latitude ??
//   //        user?.workAddress?.latitude ??
//   //        0;
//   //    lon1 = location?.longitude ??
//   //        user?.homeAddress?.longitude ??
//   //        user?.workAddress?.longitude ??
//   //        0; // Fix here
//   //  }
//
//   print("Lat1: $lat1, Lon1: $lon1");
//   print("Place Lat: ${place.lat}, Place Lon: ${place.lon}");
//   double dLat = degreesToRadians(place.lat - lat1);
//   double dLon = degreesToRadians(place.lon - lon1);
//
//   double a = sin(dLat / 2) * sin(dLat / 2) +
//       cos(degreesToRadians(lat1)) *
//           cos(degreesToRadians(place.lat)) *
//           sin(dLon / 2) *
//           sin(dLon / 2);
//   double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//   double distance = earthRadiusMiles * c;
//
//   return distance;
// }
//
Future<LocationData?> locationCheck() async {
  Location location = Location();
  return await location.getLocation();
}
//
// double degreesToRadians(double degrees) {
//   return degrees * pi / 180.0;
// }

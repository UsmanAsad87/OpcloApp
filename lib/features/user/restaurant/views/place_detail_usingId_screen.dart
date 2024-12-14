import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:opclo/commons/common_shimmer/loading_images_shimmer.dart';
import 'package:opclo/commons/common_widgets/custom_button.dart';
import 'package:opclo/commons/common_widgets/show_toast.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_controller.dart';
import 'package:opclo/features/user/alert/alerts_extended/occasions/controller/occasion_controller.dart';
import 'package:opclo/features/user/alert/controller/alert_controller.dart';
import 'package:opclo/features/user/reminder/api/dynamic_link_service.dart';
import 'package:opclo/features/user/reminder/widgets/detail_shimmer.dart';
import 'package:opclo/features/user/restaurant/controller/places_controller.dart';
import 'package:opclo/features/user/restaurant/widgets/alert_container.dart';
import 'package:opclo/features/user/restaurant/widgets/custom_about_button.dart';
import 'package:opclo/features/user/restaurant/widgets/custom_speed_dial.dart';
import 'package:opclo/features/user/favorites/widgets/favourit_bottom_sheet.dart';
import 'package:opclo/features/user/restaurant/widgets/occasion_chip.dart';
import 'package:opclo/models/place_model.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/loading.dart';
import 'package:opclo/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../commons/common_functions/is_alert_exprire.dart';
import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_widgets/cached_retangular_network_image.dart';
import '../../../../models/alert_model.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../auth/controller/auth_notifier_controller.dart';
import '../controller/place_subscription_controller.dart';
import '../widgets/alerts_widget.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/ocassions_widget.dart';
import 'full_screen_image_view.dart';

class PlaceDetailUsingIdScreen extends ConsumerStatefulWidget {
  final String placeId;

  const PlaceDetailUsingIdScreen({
    Key? key,
    required this.placeId,
  }) : super(key: key);

  @override
  ConsumerState<PlaceDetailUsingIdScreen> createState() =>
      _DetailViewScreenState();
}

class _DetailViewScreenState extends ConsumerState<PlaceDetailUsingIdScreen> {
  BitmapDescriptor? _customMarkerIcon;
  bool isNotification = true;
  bool isSpeedDialOpen = false;
  bool isReminder = false;

  // var likePlaces;

  @override
  void initState() {
    super.initState();
    // likePlaces = ref.read(authNotifierCtr).likePlaces;
    _loadCustomMarker();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final reminder =
          ref.watch(checkUserExistsInPlaceSubscriptionProvider(widget.placeId));
      reminder.when(
          data: (value) {
            setState(() {
              isReminder = value;
            });
          },
          error: (error, stackTrace) => debugPrint('Error'),
          loading: () => null);
    });
  }

  openMap({required PlaceModel placeModel}) async {
    var _googleMapsUrl = Uri.parse(
        "google.navigation:q=${placeModel.lat},${placeModel.lon}&mode=d");
    var _appleMapsUrl =
        Uri.parse("maps://?q=${placeModel.lat},${placeModel.lon}");

    try {
      bool googleMapsLaunched = await launchUrl(_googleMapsUrl);
      if (!googleMapsLaunched) {
        bool appleMapsLaunched = await launchUrl(_appleMapsUrl);
        if (!appleMapsLaunched) {
          print('Could not launch any map app');
          throw Exception('Could not launch any map app');
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      throw Exception('Error launching URL: $e');
    }
  }

  void _loadCustomMarker() async {
    _customMarkerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        size: Size(60.w, 60.h),
      ),
      AppAssets.mapContainerLocationIconImage,
    );
  }

  Future<void> _launchWebsiteUrl(String url) async {
    if (url == '') {
      showSnackBar(context, 'website does not exist');
      return;
    }
    var _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      showSnackBar(context, 'website does not exist');
      // throw 'Could not launch $url';
    }
  }

  Future<void> _launchPhoneCall(String phoneNumber) async {
    if (phoneNumber == '') {
      showSnackBar(context, 'phone number does not exist');
      return;
    }
    final url = 'tel:$phoneNumber';
    var _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      showSnackBar(context, 'phone number does not exist');
      // throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getPlacesByIdProvider(widget.placeId)).when(
        data: (placeModel) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: context.whiteColor,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  backgroundColor: context.whiteColor,
                  leading: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    splashColor: Colors.transparent,
                    child: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: context.titleColor,
                    ),
                  ),
                  centerTitle: true,
                  title: Text(
                    placeModel!.placeName,
                    style: getSemiBoldStyle(
                        color: context.titleColor, fontSize: MyFonts.size14),
                  ),
                  actions: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            if (ref.read(authNotifierCtr).userModel == null) {
                              showSnackBar(
                                  context, 'Sign in to subscribe Places');
                              return;
                            }
                            setState(() {
                              isReminder = !isReminder;
                            });
                            ref
                                .read(placeSubControllerProvider.notifier)
                                .addUserIdInPlaceSub(
                                  placeId: placeModel.fsqId,
                                );
                          },
                          splashColor: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.all(4.r),
                            child: Image.asset(
                              AppAssets.sirenGreyIcon,
                              width: 22.w,
                              height: 22.h,
                              color: isReminder
                                  ? MyColors.green
                                  : MyColors.heartColor,
                            ),
                          ),
                        ),
                        padding4,
                        ref.watch(getFavouriteByFsq(widget.placeId)).when(
                              data: (fav) {
                                return InkWell(
                                  onTap: () {
                                    // showModalBottomSheet(
                                    //     context: context,
                                    //     enableDrag: true,
                                    //     isScrollControlled: true,
                                    //     backgroundColor: Colors.transparent,
                                    //     builder: (context) {
                                    //       return const FavoriteBottomSheet();
                                    //     });
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.all(4.r),
                                      child: Icon(
                                        CupertinoIcons.suit_heart_fill,
                                        size: 24.5.sp,
                                        color: fav != null
                                            ? MyColors.redText
                                            : MyColors.heartColor,
                                      )),
                                );
                              },
                              error: (e, s) => SizedBox(),
                              loading: () => Padding(
                                  padding: EdgeInsets.all(4.r),
                                  child: Icon(
                                    CupertinoIcons.suit_heart_fill,
                                    size: 24.5.sp,
                                    color: MyColors.heartColor,
                                  )),
                            ),
                        padding4,
                      ],
                    ),
                  ],
                ),
                floatingActionButton: CustomSpeedDial(
                  place: placeModel,
                  onOpen: () {
                    setState(() {
                      isSpeedDialOpen = true;
                    });
                  },
                  onClose: () {
                    setState(() {
                      isSpeedDialOpen = false;
                    });
                  },
                ),
                body: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            height: 116.h,
                            child: GoogleMap(
                              mapType: MapType.normal,
                              zoomControlsEnabled: false,
                              markers: {
                                if (_customMarkerIcon != null)
                                  Marker(
                                    markerId: const MarkerId('locate'),
                                    zIndex: 1,
                                    // onDragEnd: (LatLng newPosition) {
                                    //   setState(() {
                                    //     _latitude = newPosition.latitude;
                                    //     _longitude = newPosition.longitude;
                                    //   });
                                    // },
                                    icon: _customMarkerIcon!,
                                    position:
                                        LatLng(placeModel.lat, placeModel.lon),
                                    // position: LatLng(_latitude, _longitude),
                                  )
                              },
                              onTap: (latLng) {
                                Navigator.pushNamed(context, AppRoutes.mapView,
                                    arguments: {
                                      'lat': placeModel.lat,
                                      'lng': placeModel.lon
                                    });
                              },
                              initialCameraPosition: CameraPosition(
                                  target:
                                      LatLng(placeModel.lat, placeModel.lon),
                                  zoom: 16.478),
                            ),
                          ),
                          Positioned(
                            bottom: -30.h,
                            right: 30.w,
                            child: CustomButton(
                                buttonWidth: 130.w,
                                buttonHeight: 40.h,
                                onPressed: () {
                                  openMap(placeModel: placeModel);
                                },
                                icon: Icon(
                                  Icons.directions,
                                  size: 23.r,
                                  color: context.whiteColor,
                                ),
                                borderRadius: 10.r,
                                buttonText: 'Directions'),
                          ),
                          if (isSpeedDialOpen)
                            Container(
                              height: 116.h,
                              width: double.infinity,
                              color: context.titleColor.withOpacity(.5),
                            )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.horizontalPadding,
                            vertical: 12.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: List.generate(
                                5,
                                (index) {
                                  print(
                                      '${index + 1}  ${placeModel.rating! / 2}   ${index + 2 < placeModel.rating! / 2}');
                                  Color starColor =
                                      index + 1 < (placeModel.rating ?? 9.0) / 2
                                          ? MyColors.starContainerColor
                                          : Colors.grey.shade400;
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 2.h),
                                    child: Image.asset(
                                      AppAssets.starIconImage,
                                      width: 18.w,
                                      color: starColor,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 4.h),
                              child: Text(
                                placeModel.placeName, // 'Ben & Jerry’s',
                                style: getSemiBoldStyle(
                                    color: context.primaryColor,
                                    fontSize: MyFonts.size16),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 2.w, top: 4.h),
                              child: Text(
                                placeModel.locationName,
                                //'705 Wharf St SW, Washington,',
                                style: getRegularStyle(
                                    color: context.titleColor.withOpacity(.5),
                                    fontSize: MyFonts.size13),
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.symmetric(
                            //       horizontal: 2.w, vertical: 0.h),
                            //   child: Text(
                            //     'DC 20024',
                            //     style: getRegularStyle(
                            //         color: context.titleColor.withOpacity(.5),
                            //         fontSize: MyFonts.size13),
                            //   ),
                            // ),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 4.h),
                                  child: Text(
                                    placeModel.categories?.join(', ') ?? '',
                                    //'Dessert, Cafe',
                                    style: getRegularStyle(
                                        color:
                                            context.titleColor.withOpacity(.5),
                                        fontSize: MyFonts.size13),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 4.h),
                                  child: Text(
                                    placeModel.isOpen ? 'Open' : 'Close',
                                    style: getMediumStyle(
                                        color: placeModel.isOpen
                                            ? MyColors.green
                                            : MyColors.red,
                                        fontSize: MyFonts.size13),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 4.h),
                                  child: Text(
                                    'Closes at 9 PM',
                                    style: getMediumStyle(
                                        color:
                                            context.titleColor.withOpacity(.5),
                                        fontSize: MyFonts.size11),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Consumer(builder: (context, ref, child) {
                        return ref
                            .watch(getPhotosProvider(placeModel.fsqId))
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
                                                  horizontal: 6.w,
                                                  vertical: 8.h),
                                              child: InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return FullScreenImageViewer(
                                                            imageUrls: photos
                                                                .map((photo) =>
                                                                    '${photo.prefix}183x138${photo.suffix}')
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
                                                  )),
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
                              loading: () => Padding(
                                padding: EdgeInsets.symmetric(horizontal: 18.w),
                                child: Row(
                                  children: [
                                    ShimmerWidget(
                                      width: 100.w,
                                      height: 100.h,
                                    ),
                                    padding4,
                                    ShimmerWidget(
                                      width: 100.w,
                                      height: 100.h,
                                    ),
                                    padding4,
                                    ShimmerWidget(
                                      width: 100.w,
                                      height: 100.h,
                                    ),
                                  ],
                                ),
                              ),
                            );
                      }),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.r),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomAboutButton(
                              onTap: () {
                                _launchWebsiteUrl(
                                    placeModel.website.toString());
                              },
                              text: 'Website',
                              image: AppAssets.globeIconImage,
                              fillColor: context.primaryColor,
                            ),
                            CustomAboutButton(
                                onTap: () {
                                  _launchPhoneCall(placeModel.tel.toString());
                                },
                                icon: Icons.phone,
                                text: 'Call'),
                            CustomAboutButton(
                                onTap: () async {
                                  openMap(placeModel: placeModel);
                                },
                                icon: Icons.directions,
                                text: 'Directions'),
                            CustomAboutButton(
                                onTap: () {
                                  DynamicLinkService.buildDynamicLinkForPlace(
                                      true, placeModel);
                                },
                                image: AppAssets.shareAppImage,
                                text: 'Share'),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(AppConstants.padding),
                        decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Color(0xffFFFFFF),
                                Color(0xffF4EBE0),
                              ],
                              stops: [
                                0.1,
                                7,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12.r)),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.h, horizontal: 8.w),
                              child: Image.asset(
                                AppAssets.fastFoodImage,
                                width: 110.w,
                                height: 70.h,
                              ),
                            ),
                            padding4,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Delicious Food',
                                    style: getSemiBoldStyle(
                                        color: MyColors.foodTextColor,
                                        fontSize: MyFonts.size16)),
                                SizedBox(
                                  width: 200.w,
                                  child: Text(
                                      'Get your latest offers today at our nearest stores',
                                      style: getMediumStyle(
                                          color: context.titleColor,
                                          fontSize: MyFonts.size11)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(AppConstants.padding),
                        margin: EdgeInsets.symmetric(
                          horizontal: AppConstants.padding,
                        ),
                        decoration: BoxDecoration(
                            color: context.containerColor,
                            borderRadius: BorderRadius.circular(12.r)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(6.r),
                              decoration: BoxDecoration(
                                color: Color(0xffF26C4F),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.info_outline_rounded,
                                color: context.whiteColor,
                              ),
                            ),
                            padding12,
                            Expanded(
                              child: Text(
                                  'Our app utilizes a location-based API. We’re constantly enhancing its performance.',
                                  style: getRegularStyle(
                                      color: context.titleColor,
                                      fontSize: MyFonts.size13)),
                            )
                          ],
                        ),
                      ),
                      AlertsWidget(
                        fsqId: placeModel.fsqId,
                      ),
                      OcassionsWidget(
                        fsqId: placeModel.fsqId,
                      ),
                      padding8,
                      Container(
                        width: double.infinity,
                        color: MyColors.subContainer1.withOpacity(.2),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 8.h,
                                top: 50.h,
                              ),
                              child: Text(
                                'Love it here?',
                                style: getSemiBoldStyle(
                                    color: context.titleColor,
                                    fontSize: MyFonts.size20),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 2.h,
                                  top: 2.h,
                                  left: 12.w,
                                  right: 12.w),
                              child: Text(
                                'To stay up to date with the latest charges and news, please follow us on social media',
                                textAlign: TextAlign.center,
                                style: getRegularStyle(
                                    color: context.titleColor.withOpacity(.5),
                                    fontSize: MyFonts.size13),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Text(
                                '@OpcloApp',
                                style: getSemiBoldStyle(
                                    color: context.primaryColor.withOpacity(.9),
                                    fontSize: MyFonts.size15),
                              ),
                            ),
                            Image.asset(
                              AppAssets.poweredByImage,
                              width: 220.w,
                            ),
                            padding56,
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppConstants.horizontalPadding,
                                  vertical: 18.r),
                              child: CustomButton(
                                onPressed: () {},
                                buttonText: 'Report Place',
                                backColor: MyColors.pizzaHutColor,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (isNotification)
                Consumer(builder: (context, ref, child) {
                  Future.delayed(Duration(seconds: 3), () {
                    setState(() {
                      isNotification = false;
                    });
                  });
                  return ref.watch(getAllAlertsProvider(placeModel.fsqId)).when(
                      data: (alerts) {
                        AlertModel? activeAlert = alerts.isEmpty ? null : alerts.first;
                        // try {
                        //   activeAlert = alerts.firstWhere(
                        //     (alert) => !isAlertExpired(alert),
                        //   );
                        // } catch (e) {
                        //   activeAlert = null;
                        // }
                         if (activeAlert != null) {
                          return GestureDetector(
                            onVerticalDragUpdate: (details) {
                              if (details.primaryDelta! < -10) {
                                setState(() {
                                  isNotification = false;
                                });
                              }
                            },
                            child: CustomDialog(
                              name: placeModel.placeName,
                              alert: activeAlert,
                            ),
                          );
                        } else {
                          return SizedBox(width: 0, height: 0);
                        }
                      },
                      error: (error, stackTrace) =>
                          SizedBox(width: 0, height: 0),
                      loading: () => LoadingWidget());
                }),
            ],
          );
        },
        error: (error, stackTrace) {
          Navigator.pop(context);
          return DetailShimmer();
        },
        loading: () => DetailShimmer());
  }

  String getIcon(String title) {
    switch (title.toLowerCase()) {
      case 'birthdays':
        return AppAssets.birthDayImage;
      case 'weddings':
        return AppAssets.weddingImage;
      case 'anniversaries':
        return AppAssets.valentinesDayImage;
      case 'graduation':
        return AppAssets.graduationImage;
      case 'gift':
        return AppAssets.giftBoxImage;
      default:
        return AppAssets.giftBoxImage;
    }
  }

  String getAlertIcon(String title) {
    switch (title) {
      case 'incorrect hours':
        return AppAssets.clockImage;
      case 'dineThurClosed':
        return AppAssets.driveImage;
      case 'dineInClosed':
        return AppAssets.driveImage;
      case 'womenOwned':
        return AppAssets.womenOwnedImage;
      case 'blackOwned':
        return AppAssets.blackOwnedImage;
      case 'maintenance':
        return AppAssets.maintenanceImage;
      case 'construction':
        return AppAssets.constructionImage;
      case 'movedLocation':
        return AppAssets.redLocationImage;
      case 'newAlert':
        return AppAssets.newAlertImage;
      case 'existingAlert':
        return AppAssets.alertImage;
      default:
        return AppAssets.clockImage;
    }
  }
}

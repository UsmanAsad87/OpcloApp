import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:opclo/commons/common_widgets/custom_button.dart';
import 'package:opclo/commons/common_widgets/show_toast.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/alert/controller/alert_controller.dart';
import 'package:opclo/features/user/reminder/api/dynamic_link_service.dart';
import 'package:opclo/features/user/restaurant/controller/place_subscription_controller.dart';
import 'package:opclo/features/user/restaurant/widgets/custom_about_button.dart';
import 'package:opclo/features/user/restaurant/widgets/custom_speed_dial.dart';
import 'package:opclo/models/alert_model.dart';
import 'package:opclo/models/place_model.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/loading.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../commons/common_functions/is_alert_exprire.dart';
import '../../../../commons/common_functions/open_map.dart';
import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_functions/show_login.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../firebase_analytics/firebase_analytics.dart';
import '../../../../models/favorite_model.dart';
import '../../../../models/user_model.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../../auth/controller/auth_notifier_controller.dart';
import '../widgets/alerts_widget.dart';
import '../widgets/custom_dialog.dart';
import '../../favorites/widgets/favourit_bottom_sheet.dart';
import '../widgets/ocassions_widget.dart';
import '../widgets/place_photos_widget.dart';

class DetailViewScreen extends ConsumerStatefulWidget {
  final PlaceModel placeModel;

  const DetailViewScreen({
    Key? key,
    required this.placeModel,
  }) : super(key: key);

  @override
  ConsumerState<DetailViewScreen> createState() => _DetailViewScreenState();
}

class _DetailViewScreenState extends ConsumerState<DetailViewScreen> {
  double _latitude = 0.0, _longitude = 0.0;
  BitmapDescriptor? _customMarkerIcon;
  bool isNotification = true;
  bool isSpeedDialOpen = false;
  bool isReminder = false;

  initialize() async {
    _latitude = widget.placeModel.lat;
    _longitude = widget.placeModel.lon;
    isReminder = await ref
        .read(placeSubControllerProvider.notifier)
        .checkUserExistsInPlaceSubscription(placeId: widget.placeModel.fsqId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialize();
    _loadCustomMarker();
  }

  void _loadCustomMarker() async {
    _customMarkerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        size: Size(60.w, 60.h),
      ),
      AppAssets.mapContainerLocationIconImage,
    );
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
    // final likePlaces = ref.watch(authNotifierCtr).likePlaces;
    // final isLike = likePlaces?.contains(widget.placeModel.fsqId) ?? false;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: context.whiteColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: context.whiteColor,
            leading: InkWell(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
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
              widget.placeModel.placeName,
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
                        showSnackBar(context, 'Sign in to subscribe Places');
                        return;
                      }
                      setState(() {
                        isReminder = !isReminder;
                      });
                      ref
                          .read(placeSubControllerProvider.notifier)
                          .addUserIdInPlaceSub(
                            placeId: widget.placeModel.fsqId,
                          );
                      // Navigator.pushNamed(context, AppRoutes.shareScreen);
                    },
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    child: Padding(
                      padding: EdgeInsets.all(4.r),
                      child: Image.asset(
                        AppAssets.sirenGreyIcon,
                        width: 22.w,
                        height: 22.h,
                        color:
                            isReminder ? MyColors.green : MyColors.heartColor,
                      ),
                      // ActionIcon(
                      //   icon: AppAssets.sirenIcon,
                      // ),
                    ),
                  ),
                  padding4,
                  Padding(
                      padding: EdgeInsets.all(4.r),
                      child: ref
                          .watch(getFavouriteByFsq(widget.placeModel.fsqId))
                          .when(
                              data: (fav) {
                                print(fav);
                                return InkWell(
                                  onTap: () {
                                    UserModel? user =
                                        ref.watch(authNotifierCtr).userModel;
                                    if (user != null) {
                                      if (fav != null) {
                                        FavoriteModel favorite = fav;
                                        ref
                                            .read(
                                                authControllerProvider.notifier)
                                            .updateFavorites(
                                                context: context,
                                                favoriteModel: favorite,
                                                ref: ref);
                                      } else {
                                        showModalBottomSheet(
                                            context: context,
                                            enableDrag: true,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) {
                                              return FavoriteBottomSheet(
                                                  placeModel:
                                                      widget.placeModel);
                                            });
                                      }
                                    } else {
                                      showLogInBottomSheet(context: context);
                                    }
                                  },
                                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                                  child: Icon(
                                    CupertinoIcons.suit_heart_fill,
                                    size: 24.5.sp,
                                    color: fav != null
                                        ? MyColors.redText
                                        : MyColors.heartColor,
                                  ),
                                );
                              },
                              error: (e, s) => SizedBox(),
                              loading: () => LoadingWidget())),
                  padding4,
                ],
              ),
            ],
          ),
          floatingActionButton: CustomSpeedDial(
            place: widget.placeModel,
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
                              onDragEnd: (LatLng newPosition) {
                                setState(() {
                                  _latitude = newPosition.latitude;
                                  _longitude = newPosition.longitude;
                                });
                              },
                              icon: _customMarkerIcon!,
                              position: LatLng(_latitude, _longitude),
                            )
                        },
                        onTap: (latLng) {
                          Navigator.pushNamed(context, AppRoutes.mapView,
                              arguments: {'lat': _latitude, 'lng': _longitude});
                        },
                        initialCameraPosition: CameraPosition(
                            target: LatLng(_latitude, _longitude),
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
                            openMap(
                                lat: widget.placeModel.lat,
                                lng: widget.placeModel.lon);
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
                            Color starColor = index + 1 <
                                    (widget.placeModel.rating ?? 9.0) / 2
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
                          widget.placeModel.placeName, // 'Ben & Jerry’s',
                          style: getSemiBoldStyle(
                              color: context.primaryColor,
                              fontSize: MyFonts.size16),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.w, top: 4.h),
                        child: Text(
                          widget.placeModel.locationName,
                          //'705 Wharf St SW, Washington,',
                          style: getRegularStyle(
                              color: context.titleColor.withOpacity(.5),
                              fontSize: MyFonts.size13),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 4.h),
                            child: Text(
                              widget.placeModel.categories?.join(', ') ?? '',
                              //'Dessert, Cafe',
                              style: getRegularStyle(
                                  color: context.titleColor.withOpacity(.5),
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
                              widget.placeModel.isOpen ? 'Open' : 'Close',
                              style: getMediumStyle(
                                  color: widget.placeModel.isOpen
                                      ? MyColors.green
                                      : MyColors.red,
                                  fontSize: MyFonts.size13),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 4.h),
                            child: Text(
                              widget.placeModel.isOpen
                                  ? widget.placeModel.closingTime == ''
                                      ? ''
                                      : 'Closes at ${widget.placeModel.closingTime}'
                                  : widget.placeModel.openTime == ''
                                      ? ''
                                      : 'Open at ${widget.placeModel.openTime}',
                              style: getMediumStyle(
                                  color: context.titleColor.withOpacity(.5),
                                  fontSize: MyFonts.size11),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PlacePhotosWidget(fsqId: widget.placeModel.fsqId),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomAboutButton(
                        onTap: () {
                          launchWebsiteUrl(
                              context: context, url: widget.placeModel.website.toString());
                        },
                        text: 'Website',
                        image: AppAssets.globeIconImage,
                        fillColor: context.primaryColor,
                      ),
                      CustomAboutButton(
                          onTap: () {
                            _launchPhoneCall(widget.placeModel.tel.toString());
                          },
                          icon: Icons.phone,
                          text: 'Call',
                      ),
                      CustomAboutButton(
                          onTap: () async {
                            openMap(
                                lat: widget.placeModel.lat,
                                lng: widget.placeModel.lon);
                            // openMap();
                          },
                          icon: Icons.directions,
                          text: 'Directions'),
                      CustomAboutButton(
                          onTap: () {
                            DynamicLinkService.buildDynamicLinkForPlace(
                                true, widget.placeModel);
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
                                    fontSize: MyFonts.size11)
                            ),
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
                            'Information may occasionally be inaccurate as we enhance our data sources.',
                            style: getRegularStyle(
                                color: context.titleColor,
                                fontSize: MyFonts.size13)),
                      )
                    ],
                  ),
                ),
                AlertsWidget(
                  fsqId: widget.placeModel.fsqId,

                ),
                OcassionsWidget(
                  fsqId: widget.placeModel.fsqId,
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
                            bottom: 2.h, top: 2.h, left: 12.w, right: 12.w),
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
                              fontSize: MyFonts.size15
                          ),
                        ),
                      ),
                      Image.asset(
                        AppAssets.poweredByImage,
                        width: 220.w,
                      ),
                      padding20,
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.horizontalPadding,
                            vertical: 18.r,
                        ),
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
            return ref
                .watch(getAllAlertsProvider(widget.placeModel.fsqId))
                .when(
                    data: (alerts) {
                      // AlertModel? activeAlert;
                      // try {
                      //   activeAlert = alerts.firstWhere(
                      //     (alert) => !isAlertExpired(alert),
                      //   );
                      // } catch (e) {
                      //   activeAlert = null;
                      // }
                      if (alerts.isNotEmpty) {
                        return GestureDetector(
                          onVerticalDragUpdate: (details) {
                            if (details.primaryDelta! < -10) {
                              setState(() {
                                isNotification = false;
                              });
                            }
                          },
                          child: CustomDialog(
                            name: widget.placeModel.placeName,
                            alert: alerts.first,
                            // alert: activeAlert,
                          ),
                        );
                      } else {
                        return SizedBox(width: 0, height: 0);
                      }
                    },
                    error: (error, stackTrace) => SizedBox(width: 0, height: 0),
                    loading: () => LoadingWidget());
          }),
      ],
    );
  }
}

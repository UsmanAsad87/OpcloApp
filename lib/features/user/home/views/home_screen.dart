import 'dart:io' show Platform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_shimmer/coupon_shimmers/coupons_row_shimmer.dart';
import 'package:opclo/commons/common_widgets/custom_search_fields.dart';
import 'package:opclo/commons/common_widgets/custom_see_all_widget.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
import 'package:opclo/features/user/coupons/controller/coupon_controller.dart';
import 'package:opclo/features/user/home/widgets/action_icons.dart';
import 'package:opclo/features/user/home/widgets/categories_row.dart';
import 'package:opclo/features/user/home/widgets/coupon_container.dart';
import 'package:opclo/features/user/home/widgets/custom_horizontal_cards.dart';
import 'package:opclo/features/user/home/widgets/opclo_premium_container.dart';
import 'package:opclo/features/user/location/location_controller/location_notifier_controller.dart';
import 'package:opclo/features/user/location/views/search_location_bootom_sheet.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../../commons/common_functions/check_conectivity.dart';
import '../../../../commons/common_functions/show_login.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_providers/shared_pref_helper.dart';
import '../../../../commons/common_widgets/show_toast.dart';
import '../../../../commons/common_widgets/version_check.dart';
import '../../../../firebase_analytics/firebase_analytics.dart';
import '../../../../models/coupon_model.dart';
import '../../../../models/user_model.dart';
import '../../alert/controller/alert_controller.dart';
import '../../main_menu/controller/conectivity_notifier.dart';
import '../../main_menu/controller/main_menu_controller.dart';
import '../../no_internet/views/no_connection.dart';
import '../../restaurant/controller/places_controller.dart';
import '../../search/constants/popular_store.dart';
import '../../search/widgets/search_button.dart';
import '../controller/nearby_notiifer.dart';
import '../controller/sheet_height_controller.dart';
import '../widgets/bottom_sheet_home_page.dart';
import '../widgets/home_screen_places.dart';
import '../widgets/notification_icon_widget.dart';

// final GlobalKey<NavigatorState> homeScaffoldKey = GlobalKey<NavigatorState>();

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  VersionCheckClass versionCheckClass = VersionCheckClass();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final isInternet = ref.watch(connectivityProvider);
      if (isInternet) {
        NearByController(
                placesController:
                    ref.read(placesControllerProviderForNotification),
                alertController:
                    ref.read(alertControllerProviderForNotification))
            .init(context: context, ref: ref);
        initiallize();
        startShowCase();
        AnalyticsHelper.logScreenView(screenName: 'HomeScreen');
      }
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  initiallize() async {
    await versionCheckClass.checkVersion(context: context);
  }

  void startShowCase() {
    _checkShowcasePreference();
  }

  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  bool showShowcase = false;

  Future<void> _checkShowcasePreference() async {
    final result = await SharedPrefHelper.getShowCase();
    setState(() {
      showShowcase = result;
    });

    if (showShowcase) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([_one, _two]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel? userModel = ref.watch(authNotifierCtr).userModel;
    bool isInternet = ref.read(connectivityProvider);
    return !isInternet
        ? NoConnection(
            isPop: false,
            onTap: () async {
              // isInternet = await isInternetConnected();
              isInternet = ref.read(connectivityProvider);
              if (isInternet) {
                setState(() {});
              } else {
                showToast(
                    msg: 'No Connection yet',
                    backgroundColor: context.primaryColor.withOpacity(.2));
              }
            },
          )
        : Scaffold(
            // key: homeScaffoldKey,
            backgroundColor: context.whiteColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
              title: InkWell(
                overlayColor:
                MaterialStateProperty.all(Colors.transparent),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      enableDrag: true,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return SearchLocationBottomSheet();
                      });
                },
                splashColor: Colors.transparent,
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: context.primaryColor,
                    ),
                    padding4,
                    Expanded(
                      child: Text(
                        ref
                            .watch(locationDetailNotifierCtr)
                            .locationDetail !=
                            null
                            ? ref
                            .watch(locationDetailNotifierCtr)
                            .locationDetail!
                            .name
                            : 'Current Location',
                        overflow: TextOverflow.ellipsis,
                        style: getSemiBoldStyle(
                            color: context.titleColor,
                            fontSize: MyFonts.size14),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.all(3.r),
                  child: InkWell(
                    onTap: () {
                      if (ref.read(authNotifierCtr).userModel == null) {
                        ref.read(mainMenuProvider).setIndex(4);
                        return;
                      }
                      Navigator.pushNamed(
                          context, AppRoutes.favouritesScreen, arguments: {'pop' : true});
                    },
                    splashColor: Colors.transparent,
                    child: ActionIcon(
                        icon: AppAssets.redHeart, color: MyColors.red),
                  ),
                ),
                NotificationIconWidget(),
                padding12,
              ],
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // padding64,
                      // if (Platform.isIOS) ...[
                      //   padding32,
                      // ],
                      padding8,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppConstants.allPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome',
                              style: getSemiBoldStyle(
                                  color: context.titleColor,
                                  fontSize: MyFonts.size28),
                            ),
                            Text(
                              'Millions of places you know and love.',
                              style: getSemiBoldStyle(
                                  color: context.titleColor.withOpacity(.3.r)),
                            ),
                          ],
                        ),
                      ),
                      padding12,
                      const SearchButton(),
                      padding12,
                      CategoriesRow(),
                      const CustomHorizontalCards(),
                      padding16,
                      if (Platform.isIOS &&
                          (userModel == null ||
                              (!userModel.subscriptionIsValid!)))
                      const OpcloPremiumContainer(),
                      padding12,
                      CustomSeeAllWidget(
                          title: 'Popular Stores',
                          buttonText: '',
                          onTap: () {}),
                      Container(
                        height: 120.h,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: ListView.builder(
                            itemCount: PopularStoreConstant.storeName.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: index == 0 ? 16.w : 0, right: 12.w),
                                child: InkWell(
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, AppRoutes.placeChainScreen,
                                        arguments: {
                                          'categoryName': PopularStoreConstant
                                              .storeName[index],
                                          'chainId': PopularStoreConstant
                                              .storeChainId[index]
                                        });
                                  },
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 32.r,
                                        child: ClipOval(
                                          child: Image.asset(
                                            PopularStoreConstant.storeLogo[index],
                                            fit: index == 5 || index == 8
                                                ? BoxFit.fitHeight
                                                : BoxFit.cover,
                                            width: 64.r,
                                            height: 64.r,
                                          ),
                                        ),
                                      ),
                                      padding4,
                                      Text(
                                        PopularStoreConstant.storeName[index],
                                        style: getRegularStyle(
                                            color: context.bodyTextColor,
                                            fontSize: 12.r),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      CustomSeeAllWidget(
                          title: 'Coupons',
                          buttonText: 'See all',
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.listOfCouponsScreen);
                            // Navigator.of(context)
                            //     .push(MaterialPageRoute(builder: (context) {
                            //   return CreateCouponScreen();
                            // }));
                          }),
                      Container(
                        margin: EdgeInsets.only(left: 12.w),
                        height: 190.h,
                        child: ref.watch(getAllCouponsProvider).when(
                              data: (coupons) {
                                bool isPrem = false;
                                if (userModel != null) {
                                  isPrem = userModel.subscriptionIsValid ?? false;
                                }
                                final filteredCoupons = coupons.where((coupon) {
                                  return isPrem || !coupon.isPremium;
                                }).toList();
                                return filteredCoupons.isEmpty
                                    ? Center(
                                        child: Text(
                                        'No Coupons yet!',
                                        style: getSemiBoldStyle(
                                            color: context.titleColor
                                                .withOpacity(.5)),
                                      ))
                                    : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: filteredCoupons.length,
                                        itemBuilder: (context, index) {
                                          final CouponModel coupon =
                                              filteredCoupons[index];
                                          return CouponContainer(
                                            couponModel: coupon,
                                          );
                                        });
                              },
                              error: (error, stackTrace) => const SizedBox(),
                              loading: () => const CouponsRowShimmer(count: 4),
                            ),
                      ),
                      padding16,
                      const HomeScreenPlaces(),
                      padding40,
                    ],
                  ),
                ),
                // Positioned(
                //   top: 0.0,
                //   left: 0.0,
                //   right: 0.0,
                //   child: AppBar(
                //     automaticallyImplyLeading: false,
                //     elevation: 0,
                //     backgroundColor: Colors.white,
                //     foregroundColor: Colors.red,
                //     title: InkWell(
                //       overlayColor:
                //           MaterialStateProperty.all(Colors.transparent),
                //       onTap: () {
                //         showModalBottomSheet(
                //             context: context,
                //             enableDrag: true,
                //             isScrollControlled: true,
                //             backgroundColor: Colors.transparent,
                //             builder: (context) {
                //               return SearchLocationBottomSheet();
                //             });
                //       },
                //       splashColor: Colors.transparent,
                //       child: Row(
                //         children: [
                //           Icon(
                //             Icons.location_on,
                //             color: context.primaryColor,
                //           ),
                //           padding4,
                //           Expanded(
                //             child: Text(
                //               ref
                //                           .watch(locationDetailNotifierCtr)
                //                           .locationDetail !=
                //                       null
                //                   ? ref
                //                       .watch(locationDetailNotifierCtr)
                //                       .locationDetail!
                //                       .name
                //                   : 'Current Location',
                //               overflow: TextOverflow.ellipsis,
                //               style: getSemiBoldStyle(
                //                   color: context.titleColor,
                //                   fontSize: MyFonts.size14),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //     actions: [
                //       Padding(
                //         padding: EdgeInsets.all(3.r),
                //         child: InkWell(
                //           onTap: () {
                //             if (ref.read(authNotifierCtr).userModel == null) {
                //               ref.read(mainMenuProvider).setIndex(4);
                //               return;
                //             }
                //             Navigator.pushNamed(
                //                 context, AppRoutes.favouritesScreen, arguments: {'pop' : true});
                //           },
                //           splashColor: Colors.transparent,
                //           child: ActionIcon(
                //               icon: AppAssets.redHeart, color: MyColors.red),
                //         ),
                //       ),
                //       NotificationIconWidget(),
                //       padding12,
                //     ],
                //   ),
                // ),
                Consumer(builder: (context, ref, child) {
                  return ref.watch(sheetHeightProvider).height! > 44
                      ? Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: context.titleColor.withOpacity(.4),
                        )
                      : SizedBox();
                }),
                if (showShowcase) ...[
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: 30.h,
                      child: Showcase(
                        key: _one,
                        title: "Quick Access",
                        titleTextStyle: getSemiBoldStyle(
                            color: context.whiteColor,
                            fontSize: MyFonts.size20),
                        showArrow: true,
                        descTextStyle: getMediumStyle(
                            color: context.whiteColor,
                            fontSize: MyFonts.size12),
                        description:
                            'Quickly access your favorite places from here.',
                        targetShapeBorder: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: SizedBox(),
                        tooltipBackgroundColor: Colors.transparent,
                        disposeOnTap: true,
                        onBarrierClick: () {
                          SharedPrefHelper.setShowcaseVisited(false);
                          ShowCaseWidget.of(context).dismiss();
                        },
                        onTargetClick: () {
                          SharedPrefHelper.setShowcaseVisited(false);
                          ShowCaseWidget.of(context).dismiss();
                        },
                      ),
                    ),
                  )
                ],
                BottomSheetHomePage(),
              ],
            ),

            // bottomSheet: QuickAccessBottomSheet(),
          );
  }
}

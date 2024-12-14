import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_shimmer/coupon_shimmers/coupon_horizontal_card.dart';
import 'package:opclo/commons/common_widgets/custom_see_all_widget.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
import 'package:opclo/features/user/coupons/controller/coupon_controller.dart';
import 'package:opclo/features/user/profile/profile_extended/add_note/controller/note_controller.dart';
import 'package:opclo/features/user/profile/widgets/note_container.dart';
import 'package:opclo/features/user/profile/widgets/profile_info.dart';
import 'package:opclo/features/user/profile/widgets/wallet_coupon_widget.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import '../../../../commons/common_functions/show_login.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_shimmer/loading_images_shimmer.dart';
import '../../../../firebase_analytics/firebase_analytics.dart';
import '../../../../models/coupon_model.dart';
import '../../../../models/user_model.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../widgets/profile_place_houlder.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:io' show Platform;
import '../widgets/subscription_alert_container.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  UserModel? userModel;

  // bool? isLoggedIn;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      userModel = ref.watch(authNotifierCtr).userModel;
      if (userModel == null) {
        showLogInBottomSheet(context: context,);
      }
      AnalyticsHelper.logScreenView(screenName: 'Profile-Screen');
    });
  }

  List<Color> colors = [
    MyColors.containerColor2,
    MyColors.containerColor3,
    MyColors.containerColor4,
  ];

  int selectedCardIndex = 0;

  @override
  Widget build(BuildContext context) {
    userModel = ref.watch(authNotifierCtr).userModel;
    return Scaffold(
      backgroundColor: context.whiteColor,
      appBar: AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 50.w,
          ),
          Text(
            'Profile',
            style: getSemiBoldStyle(
              fontSize: MyFonts.size18,
              color: context.titleColor,
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 1,
                      color: context.titleColor.withOpacity(.1))),
              child: GestureDetector(
                onTap: () {
                  if (userModel == null) {
                    showLogInBottomSheet(context: context);
                    return;
                  }
                  Navigator.pushNamed(
                      context, AppRoutes.profileDetailScreen,
                      arguments: {'userModel': userModel});
                },
                child: Icon(
                  Icons.settings,
                  color: context.primaryColor,
                  weight: 24,
                ),
              )),
        ],
      ),
      // Text(
      //   'Rewards',
      //   style: getSemiBoldStyle(
      //       color: context.titleColor, fontSize: MyFonts.size26),
      // ),
    ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SafeArea(
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     SizedBox(
              //       width: 50.w,
              //     ),
              //     Text(
              //       'Profile',
              //       style: getSemiBoldStyle(
              //         fontSize: MyFonts.size18,
              //         color: context.titleColor,
              //       ),
              //     ),
              //     Container(
              //         margin: EdgeInsets.symmetric(horizontal: 8.w),
              //         padding: EdgeInsets.all(4.r),
              //         decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             border: Border.all(
              //                 width: 1,
              //                 color: context.titleColor.withOpacity(.1))),
              //         child: GestureDetector(
              //           onTap: () {
              //             if (userModel == null) {
              //               showLogInBottomSheet(context: context);
              //               return;
              //             }
              //             Navigator.pushNamed(
              //                 context, AppRoutes.profileDetailScreen,
              //                 arguments: {'userModel': userModel});
              //           },
              //           child: Icon(
              //             Icons.settings,
              //             color: context.primaryColor,
              //             weight: 24,
              //           ),
              //         )),
              //   ],
              // ),
            // ),
            Padding(
              padding: EdgeInsets.all(AppConstants.allPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userModel != null
                      ? ProfileInfo(userModel: userModel!)
                      : ProfilePlaceHoulder(
                          onTap: () {
                            showLogInBottomSheet(context: context);
                          },
                        ),
                  Text(
                    'My Notes',
                    style: getSemiBoldStyle(
                      color: context.titleColor,
                      fontSize: MyFonts.size16,
                    ),
                  ),
                  // Horizontal masonry grid view
                  SizedBox(
                    height: 200.h,
                    child: ref.watch(getAllNotesProvider(context)).when(
                          data: (notes) {
                            // Create a horizontal masonry grid view
                            return GridView.custom(
                              scrollDirection: Axis.horizontal,
                              gridDelegate: SliverWovenGridDelegate.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 2,
                                pattern: [
                                  WovenGridTile(
                                    .9 / 1.5,
                                  ),
                                  WovenGridTile(
                                    2.1 / 4,
                                    crossAxisRatio: 0.9,
                                    alignment: AlignmentDirectional.topCenter,
                                  ),
                                ],
                              ),
                              childrenDelegate:
                                  SliverChildBuilderDelegate((context, index) {
                                final color = colors[index % colors.length];
                                if (index == 0) {
                                  return InkWell(
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    onTap: () {
                                      if (userModel != null) {
                                        Navigator.pushNamed(
                                            context, AppRoutes.addNoteScreen);
                                      } else {
                                        showLogInBottomSheet(context: context);
                                      }
                                    },
                                    child: Container(
                                      height: 100.h,
                                      margin: EdgeInsets.fromLTRB(
                                          0.w, 8.h, 8.w, 8.w),
                                      decoration: BoxDecoration(
                                        color: MyColors.containerColor1,
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.r),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Add Note',
                                              style: getSemiBoldStyle(
                                                  color: context.whiteColor),
                                            ),
                                            Image.asset(
                                              AppAssets.addImage,
                                              color: context.whiteColor,
                                              width: 21.r,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  final note = notes[index - 1];
                                  return NoteContainer(
                                    color: color,
                                    note: note,
                                  );
                                }
                              },
                                      childCount: notes.length + 1),
                            );
                          },
                          error: (error, stackTrace) => SizedBox(),
                          loading: () => Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: ShimmerWidget(height: 90),
                          ),
                        ),
                  ),
                  CustomSeeAllWidget(
                      title: 'Coupons',
                      padding: EdgeInsets.zero,
                      onTap: () {
                        if (userModel == null) {
                          showLogInBottomSheet(context: context);
                          return;
                        }
                        Navigator.pushNamed(
                            context, AppRoutes.couponsScreen);
                      }),
                  padding4,
                  userModel == null
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'LogIn to Add Coupons to Wallet',
                              style: getSemiBoldStyle(
                                  color: context.titleColor
                                      .withOpacity(.5)
                              ),
                            ),
                          ),
                        )
                      : ref.watch(getWalletCouponsProvider).when(
                          data: (walletCoupons) {
                            return WalletCouponWidget(coupons: walletCoupons);
                          },
                          error: (error, stackTrace) => SizedBox(),
                          loading: () => CouponHorizontalCard()),
                  padding16,
                  padding16,
                  if (Platform.isIOS &&
                      (userModel == null ||
                          (userModel != null &&
                              !userModel!.subscriptionIsValid!)))
                    SubscriptionAlertContainer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> images = [
    AppAssets.pizzaHutImage,
    AppAssets.mac,
    AppAssets.starBucks
  ];
}

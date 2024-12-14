import 'package:opclo/commons/common_enum/coupons_category_enum/coupon_category.dart';
import 'package:opclo/commons/common_widgets/show_toast.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
import 'package:opclo/features/user/main_menu/controller/conectivity_notifier.dart';
import '../../../../commons/common_functions/check_conectivity.dart';
import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_shimmer/coupon_shimmers/coupon_horizontal_card.dart';
import '../../../../commons/common_widgets/custom_see_all_widget.dart';
import '../../../../firebase_analytics/firebase_analytics.dart';
import '../../../../models/coupon_model.dart';
import '../../../../routes/route_manager.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../../auth/view/auth_screen.dart';
import '../../coupons/controller/coupon_controller.dart';
import '../../no_internet/views/no_connection.dart';
import '../../profile/widgets/wallet_coupon_widget.dart';
import '../widgets/featured_coupons.dart';

class SavingScreen extends ConsumerStatefulWidget {
  const SavingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SavingScreen> createState() => _SavingScreenState();
}

class _SavingScreenState extends ConsumerState<SavingScreen> {
  // bool showAll = false;
  bool isPremiumUser = false;
  // bool isInternet = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // isInternet = await isInternetConnected();
      final isInternet = await ref.read(connectivityProvider);
      if (isInternet) {
        init();
      }
    });
  }

  init() {
    AnalyticsHelper.logScreenView(screenName: 'Saving-Screen');
    isPremiumUser = ref.watch(currentUserModelData).when(
        data: (user) => user?.subscriptionIsValid ?? false,
        error: (e, s) => false,
        loading: () => false);
  }

  showLogInBottomSheet({required BuildContext context}) {
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return const AuthScreen(isSignIn: true);
        });
  }

  List<String> couponCategories = [
    'Dining & Takeout',
    'Health & Fitness',
    'Travel',
    'Sports',
    'Clothing',
    'Outdoors',
    'Makeup & Skincare',
    'Baby & Kids',
    'Electronics',
    'Toys & Games',
    'Home & Garden',
    'Pet Supplies',
    'Furniture & Decor',
    'Car Rental',
    'Bed & Bath',
    'Auto Services',
  ];

  List<String> couponCategoriesIcon = [
    AppAssets.diningAndTakeoutIcon,
    AppAssets.healthAndFitnessIcon,
    AppAssets.travelIcon,
    AppAssets.sportsIcon,
    AppAssets.clothingIcon,
    AppAssets.outdoorsIcon,
    AppAssets.makeupAndSkincareIcon,
    AppAssets.babyAndKidsIcon,
    AppAssets.electronicsIcon,
    AppAssets.toysAndGamesIcon,
    AppAssets.homeAndGardenIcon,
    AppAssets.petSuppliesIcon,
    AppAssets.furnitureAndDecorIcon,
    AppAssets.carRentalIcon,
    AppAssets.bedAndBathIcon,
    AppAssets.autoServicesIcon,
  ];

  @override
  Widget build(
    BuildContext context,
  ) {
    final userModel = ref.read(authNotifierCtr).userModel;
    bool isInternet = ref.read(connectivityProvider);
    return !isInternet
        ? NoConnection(
            isPop: false,
            onTap: () async {
              isInternet = await isInternetConnected();
              if (isInternet) {
                init();
                setState(() {});
              } else {
                showToast(
                    msg: 'No Connection yet',
                    backgroundColor: context.primaryColor.withOpacity(.2));
              }
            },
          )
        : Scaffold(
            backgroundColor: context.whiteColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.white,
              title: Text(
                'Rewards',
                style: getSemiBoldStyle(
                    color: context.titleColor, fontSize: MyFonts.size26),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          padding12,
                          // InkWell(
                          //   onTap: (){
                          //     Navigator.pushNamed(context, AppRoutes.feedbackScreen);
                          //   },
                          //   child: Text(
                          //     'Rewards',
                          //     style: getSemiBoldStyle(
                          //         color: context.titleColor, fontSize: MyFonts.size26),
                          //   ),
                          // ),
                          padding18,
                          CustomSeeAllWidget(
                              title: 'Your Wallet',
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
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          AppAssets.noAlertsIcon,
                                          width: 45.w,
                                          height: 45.h,
                                        ),
                                        padding12,
                                        Text(
                                          'LogIn to Add Coupons',
                                          style: getSemiBoldStyle(
                                              color: context.titleColor
                                                  .withOpacity(.5)),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : ref.watch(getWalletCouponsProvider).when(
                                  data: (walletCoupons) {
                                    return WalletCouponWidget(
                                        coupons: walletCoupons);
                                  },
                                  error: (error, stackTrace) => SizedBox(),
                                  loading: () => CouponHorizontalCard()),
                        ],
                      ),
                    ),
                  ),
                  padding16,
                  FeaturedCoupons(
                    isPremiumUser: userModel != null
                        ? userModel.subscriptionIsValid!
                        : false,
                  ),
                  padding16,
                  CustomSeeAllWidget(
                      title: 'Coupon For Everyone',
                      buttonText: '',
                      onTap: () {
                        // setState(() {
                        //   showAll = true;
                        // });
                      }),
                  Container(
                    padding: EdgeInsets.all(AppConstants.allPadding),
                    child: GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: couponCategories.length,
                        // itemCount: showAll ? couponCategories.length : 4,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.w,
                            mainAxisSpacing: 8.h,
                            childAspectRatio: 1.7.r),
                        itemBuilder: (context, index) {
                          return InkWell(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.listOfCouponsScreen,
                                  arguments: {
                                    'category': couponCategories[index]
                                        .toCouponCategoryEnum()
                                  });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 10.w),
                              decoration: BoxDecoration(
                                color: context.containerColor,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        couponCategories[index],
                                        style: getMediumStyle(
                                            color: context.titleColor,
                                            fontSize: MyFonts.size14),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Image.asset(
                                      couponCategoriesIcon[index],
                                      width: 50.w,
                                      height: 50.w,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
  }
}

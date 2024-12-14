import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_widgets/cached_retangular_network_image.dart';
import 'package:opclo/commons/common_widgets/custom_outline_button.dart';
import 'package:opclo/commons/common_widgets/custom_see_all_widget.dart';
import 'package:opclo/commons/common_widgets/show_toast.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/subscription/controllers/subscription_notifier_ctr.dart';
import 'package:opclo/features/user/subscription/widgets/faq_dropdown.dart';
import 'package:opclo/features/user/subscription/widgets/payment_option_container.dart';
import 'package:opclo/features/user/subscription/widgets/subscription_button.dart';
import 'package:opclo/features/user/subscription/widgets/subscription_points.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_shimmer/coupon_shimmers/coupons_row_shimmer.dart';
import '../../../../core/constants/subcription_constants.dart';
import '../../../../models/coupon_model.dart';
import '../../../../models/user_model.dart';
import '../../../auth/controller/auth_notifier_controller.dart';
import '../../../auth/view/auth_screen.dart';
import '../../coupons/controller/coupon_controller.dart';
import '../../home/widgets/coupon_container.dart';
import '../../main_menu/controller/main_menu_controller.dart';
import '../widgets/faq_section.dart';
import '../widgets/feature_and_rating.dart';
import '../widgets/payment_option_contaienr_shimmet.dart';
import '../widgets/success_stories.dart';

class SubSubscriptionScreen extends ConsumerStatefulWidget {
  const SubSubscriptionScreen({Key? key, required this.fromSignup}) : super(key: key);
  final bool fromSignup;

  @override
  ConsumerState<SubSubscriptionScreen> createState() => _SubSubscriptionScreenState();
}

class _SubSubscriptionScreenState extends ConsumerState<SubSubscriptionScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  bool _isAvailable = false;
  String _notice ="";
  List<ProductDetails> _products = [];
  bool _loading = true;
  ProductDetails? selectedProduct;

  @override
  void initState() {
    super.initState();
    initStoreInfo();
  }

  Future<void> initStoreInfo() async {
    try{
      final bool isAvailable = await _inAppPurchase.isAvailable();
      setState(() {
        _isAvailable = isAvailable;
      });

      if (!_isAvailable) {
        setState(() {
          _loading = false;
          _notice = "There are no upgrades at this time";
        });
        return;
      }

      // get IAP.
      ProductDetailsResponse productDetailsResponse = await _inAppPurchase.queryProductDetails(SubscriptionConstants.productIds.toSet());

      setState(() {
        _loading = false;
        _products = productDetailsResponse.productDetails;
        _products.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
        selectedProduct= _products.first;
      });

      if (productDetailsResponse.error != null) {
        setState(() {
          _loading = false;
          _notice = "There was a problem connecting to the store";
        });
      } else if (productDetailsResponse.productDetails.isEmpty) {
        setState(() {
          _loading = false;
          _notice = "There are no upgrades at this time";
        });
      }
    }catch(e){
      _loading  =false;
      _notice = "There are no upgrades at this time from App Store";
    }

  }
  showLogInBottomSheet() {
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        // context.titleColor.withOpacity(
        //     .05.r),
        builder: (context) {
          return const AuthScreen(isSignIn: true);
        });
  }
  Future<void> purchaseSubs() async {
    UserModel? userModel = ref.read(authNotifierCtr).userModel;
    if (userModel == null) {
      showLogInBottomSheet();
      return;
    }
    if(selectedProduct==null){
      showToast(msg: "Kindly Select A Package!");
    }
    late PurchaseParam purchaseParam;
    purchaseParam = PurchaseParam(productDetails: selectedProduct!);
    ref.read(subscriptionNotifierCtr).setSubscriptionTap(isSubsTapped: true);
    if (SubscriptionConstants.consumableIds.contains(selectedProduct!.id)) {
      await InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
    } else {
      await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    }
    // if(widget.fromSignup){
    //   Navigator.pushNamed(context, AppRoutes.conformationScreen);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar:
        (_products.isNotEmpty && _products.length==2)?
    Padding(
      padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: SubscriptionButton(onTap:(){
        purchaseSubs();
      }),
    ):null,
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      MyColors.subContainer1,
                      MyColors.subContainer2
                      // Colors.transparent,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.allPadding),
                  child: Column(
                    children: [
                      SafeArea(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Restore',
                              style: getMediumStyle(
                                  color: context.whiteColor,
                                  fontSize: MyFonts.size16),
                            ),
                            Consumer(
                              builder: (context, ref, child) {
                                return GestureDetector(
                                  onTap: (){
                                    if(widget.fromSignup){
                                      Navigator.pushNamedAndRemoveUntil(
                                          context, AppRoutes.mainMenuScreen, (route) => false);
                                      ref.read(mainMenuProvider).setIndex(0);
                                    }else{
                                      Navigator.pop(context);}
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: context.whiteColor,
                                    size: 26.r,
                                  ),
                                );
                              }
                            )
                          ],
                        ),
                      ),
                      Image.asset(
                        AppAssets.subImage,
                        width: 70.w,
                        height: 70.h,
                      ),
                      padding8,
                      Text(
                        'Premium',
                        style: getSemiBoldStyle(
                            color: context.whiteColor,
                            fontSize: MyFonts.size18),
                      ),
                      padding8,
                      OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: context.whiteColor),
                          ),
                          child: Text(
                            'Free for 1 Month',
                            style: getRegularStyle(
                                color: context.whiteColor,
                                fontSize: MyFonts.size14),
                          )),
                      padding24
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: -1,
                child: Container(
                  height: 30.h,
                  decoration: BoxDecoration(
                      color: context.whiteColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.r),
                        topRight: Radius.circular(50.r),
                      ),
                      border: null),
                ),
              )
            ],
          ),
          // padding16,
          buildSubcriptionContainer(),
          FeaturesAndRating(),
          SuccessStories(),
          CustomSeeAllWidget(title: 'Featured Coupons',buttonText: '', onTap: () {}),
          Consumer(
            builder: (context,ref,child) {
              return Container(
                margin: EdgeInsets.only(left: 12.w),
                height: 180.h,
                child: ref.watch(getAllCouponsProvider).when(
                    data: (coupons) {
                      final filteredCoupons = coupons.where((coupon) {
                        return !coupon.isPremium;
                      }).toList();
                      return filteredCoupons.length <= 0
                          ? Center(
                          child: Text(
                            'No Coupons yet!',
                            style: getSemiBoldStyle(
                                color: context.titleColor.withOpacity(.5)),
                          ))
                          : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filteredCoupons.length,
                          itemBuilder: (context, index) {
                            final CouponModel coupon = filteredCoupons[index];
                            return CouponContainer(
                              couponModel: coupon,
                            );
                          });
                    },
                    error: (error, stackTrace) => Center(
                        child: Text(
                          'No Coupons yet!',
                          style: getSemiBoldStyle(
                              color: context.titleColor.withOpacity(.5)),
                        )),
                    loading: () => CouponsRowShimmer(count: 4)),
              );
            }
          ),
          padding8,
          buildSubcriptionContainer(),
          padding8,
          FAQsection(),
          PrivacyAndTermsWidget(),
          padding8,
          // SubscriptionButton(onTap: () {
          //   Navigator.pushNamed(context, AppRoutes.conformationScreen);
          // }),
        ]),
      ),
    );
  }

  Column buildSubcriptionContainer() {
    return Column(
          children: [
            if(_products.isNotEmpty && _products.length==2)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
                child: Row(
                  children: [
                    Expanded(
                        child: PaymentOptionContainer(
                          productDetails: _products[0],
                          isSave: _products[0].id == SubscriptionConstants.opcloYearly,
                          onTap: (){
                            setState(() {
                              selectedProduct = _products[0];
                            });
                          },
                          isSelected: selectedProduct!=null && selectedProduct!.id==_products[0].id ,

                        )),
                    Expanded(
                        child: PaymentOptionContainer(
                          productDetails:_products[1] ,
                          isSave:  _products[1].id == SubscriptionConstants.opcloYearly,
                          onTap: (){
                            setState(() {
                              selectedProduct = _products[1];
                            });
                          },
                          isSelected: selectedProduct!=null && selectedProduct!.id==_products[1].id ,
                        )),

                    // Expanded(child: PaymentOptionContainer())
                  ],
                ),
              ),
            if(_loading)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
                child: Row(
                  children: [
                    Expanded(
                      child:ShimmerPaymentOptionContainer(),
                    ),
                    Expanded(
                      child:ShimmerPaymentOptionContainer(),
                    ),
                    // Expanded(child: PaymentOptionContainer())
                  ],
                ),
              ),
            if(!_loading && _products.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 50.w),
                  child: Column(
                    children: [
                      Image.asset(
                        AppAssets.noAlertsIcon,
                        width: 45.w,
                        height: 45.h,
                      ),
                      padding12,
                      Text(
                        _notice!,
                        textAlign: TextAlign.center,
                        style: getRegularStyle(
                            color:
                            context.titleColor.withOpacity(.5),fontSize: MyFonts.size14),
                      ),
                    ],
                  ),
                ),
              )
          ],
        );
  }
}


class PrivacyAndTermsWidget extends StatelessWidget {
  const PrivacyAndTermsWidget({
    super.key,
  });

  Future<void> _launchUrl(String url) async {
    try {
      final Uri _url = Uri.parse(url);
      if (!await launchUrl(_url)) {}
    } catch (e) {
      showToast(msg: 'Invalid link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppConstants.allPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Recutting billing - cancel anytime, no questions asked. After free trial, your iTunes account will be charged for opclo Premium. By continuing, you agree to the',
            textAlign: TextAlign.center,
            style: getMediumStyle(
                color: context.titleColor.withOpacity(.6),
                fontSize: MyFonts.size10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _launchUrl('https://opclo.app/privacy-policy/'),
                child: Text(
                  'Privacy Policy',
                  style: getMediumStyle(
                      color: context.primaryColor,
                      fontSize: MyFonts.size10),
                ),
              ),
              Text(
                ' and ',
                style: getMediumStyle(
                    color: context.titleColor.withOpacity(.6),
                    fontSize: MyFonts.size10),
              ),
              GestureDetector(
                onTap: () => _launchUrl('https://opclo.app/terms-of-use/'),
                child: Text(
                  'Terms & Conditions',
                  style:  getMediumStyle(
                      color: context.primaryColor,
                      fontSize: MyFonts.size10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


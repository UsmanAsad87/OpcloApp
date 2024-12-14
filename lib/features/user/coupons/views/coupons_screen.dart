import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_enum/coupon_type/coupon_type.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_shimmer/coupon_shimmers/coupon_horizontal_card.dart';
import 'package:opclo/commons/common_shimmer/loading_images_shimmer.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/coupons/views/online_coupons.dart';
import 'package:opclo/features/user/coupons/widgets/coupons_chip.dart';
import 'package:opclo/models/coupon_model.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/font_manager.dart';

import '../../../../commons/common_imports/common_libs.dart';
import '../../../auth/controller/auth_controller.dart';
import '../controller/coupon_controller.dart';
import '../controller/coupon_notifier_controller.dart';
import 'onsite_coupons.dart';

class CouponsScreen extends ConsumerStatefulWidget {
  CouponsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends ConsumerState<CouponsScreen> {
  final List<String> options = [
    CouponTypeEnum.all.type,
    CouponTypeEnum.online.type,
    CouponTypeEnum.instore.type
  ];

  // bool isPremiumUser = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   isPremiumUser = ref.watch(currentUserModelData).when(
    //       data: (user) => user?.subscriptionIsValid ?? false,
    //       error: (e, s) => false,
    //       loading: () => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.whiteColor,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: context.titleColor,
          ),
        ),
        title: Text(
          'Wallet',
          style: getSemiBoldStyle(
              color: context.titleColor, fontSize: MyFonts.size18),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Consumer(builder: (context, ref, child) {
              final couponsState = ref.watch(getWalletCouponsProvider);
              return couponsState.maybeWhen(
                data: (walletCoupons) {
                  final onlineCoupons = <CouponModel>[];
                  List<CouponModel> allCoupons = <CouponModel>[];
                  final onsiteCoupons = <CouponModel>[];
                  for(final coupon in walletCoupons){
                      allCoupons.add(coupon);
                      if (coupon.type == CouponTypeEnum.instore) {
                        onsiteCoupons.add(coupon);
                      } else if (coupon.type == CouponTypeEnum.online) {
                        onlineCoupons.add(coupon);
                      }
                  }
                  return Column(
                    children: [
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: AppConstants.padding),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                ref
                                    .watch(couponNotifierCtr)
                                    .setSelectedOption(0);
                              },
                              child: CouponsChip(
                                text: '${options[0]} (${allCoupons.length})',
                                isSelected: ref
                                        .watch(couponNotifierCtr)
                                        .selectedIndex ==
                                    0,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                ref
                                    .read(couponNotifierCtr)
                                    .setSelectedOption(1);
                              },
                              child: CouponsChip(
                                text: '${options[1]} (${onlineCoupons.length})',
                                isSelected: ref
                                        .watch(couponNotifierCtr)
                                        .selectedIndex ==
                                    1,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                ref
                                    .read(couponNotifierCtr)
                                    .setSelectedOption(2);
                              },
                              child: CouponsChip(
                                text: '${options[2]} (${onsiteCoupons.length})',
                                isSelected: ref
                                        .watch(couponNotifierCtr)
                                        .selectedIndex ==
                                    2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      padding12,
                      Expanded(
                        child: ref.read(couponNotifierCtr).selectedIndex == 0
                            ? OnlineCoupons(
                                coupons: allCoupons,
                                isWallet: true,
                              )
                            : ref.read(couponNotifierCtr).selectedIndex == 1
                                ? OnlineCoupons(
                                    coupons: onlineCoupons,
                                    isWallet: true,
                                  )
                                : OnsiteCoupons(
                                    coupons: onsiteCoupons,
                                    isWallet: true,
                                  ),
                      ),
                    ],
                  );
                },
                orElse: () => ListView(
                  shrinkWrap: true,
                  children: [
                    padding20,
                    Row(
                      children: [
                        ShimmerWidget(
                          highlightColor: context.primaryColor,
                          width: 40.w,
                          height: 20,
                        ),
                        padding16,
                        ShimmerWidget(
                          width: 40.w,
                          height: 20,
                        ),
                      ],
                    ),
                    padding16,
                    CouponHorizontalCard(),
                    CouponHorizontalCard(),
                    CouponHorizontalCard(),
                    CouponHorizontalCard(),
                    CouponHorizontalCard(),
                    CouponHorizontalCard(),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

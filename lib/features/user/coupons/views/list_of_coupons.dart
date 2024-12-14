import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/commons/common_enum/coupon_type/coupon_type.dart';
import 'package:opclo/commons/common_enum/coupons_category_enum/coupon_category.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_controller.dart';
import 'package:opclo/features/user/coupons/controller/coupon_notifier_controller.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import '../../../../commons/common_functions/padding.dart';
import '../../../../models/coupon_model.dart';
import '../../../../models/user_model.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';
import '../../../auth/controller/auth_notifier_controller.dart';
import '../controller/coupon_controller.dart';
import '../widgets/coupons_chip.dart';
import 'online_coupons.dart';
import 'onsite_coupons.dart';

class ListOfCoupons extends ConsumerStatefulWidget {
  final CouponCategory? category;

  const ListOfCoupons({Key? key, this.category}) : super(key: key);

  @override
  ConsumerState<ListOfCoupons> createState() => _ListOfCouponsState();
}

class _ListOfCouponsState extends ConsumerState<ListOfCoupons> {
  final List<String> options = [
    CouponTypeEnum.all.type,
    CouponTypeEnum.online.type,
    CouponTypeEnum.instore.type
  ];
  bool isPremiumUser = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      isPremiumUser = ref.watch(currentUserModelData).when(
          data: (user) => user?.subscriptionIsValid ?? false,
          error: (e, s) => false,
          loading: () => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? userModel = ref.watch(authNotifierCtr).userModel;
    return Scaffold(
      backgroundColor: context.whiteColor,
      appBar: AppBar(
        backgroundColor: context.whiteColor,
        elevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          widget.category == null ? 'Coupons' : '',
          style: getSemiBoldStyle(
              color: context.titleColor, fontSize: MyFonts.size18),
        ),
        leading: InkWell(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: context.titleColor,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.category != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.category!.type,
                    style: getSemiBoldStyle(
                        color: context.titleColor, fontSize: MyFonts.size26),
                  ),
                  Text(
                    'Redeem Now',
                    style: getMediumStyle(
                        color: context.titleColor.withOpacity(.5),
                        fontSize: MyFonts.size15),
                  ),
                ],
              ),
            ),
          ],
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final onlineCoupons = <CouponModel>[];
                List<CouponModel> allCoupons = <CouponModel>[];
                final onsiteCoupons = <CouponModel>[];

                final couponState = ref.watch(widget.category == null
                    ? getAllCouponsProvider
                    : getCategoryCouponsProvider(widget.category!.name));
                couponState.when(
                  data: (coupons) {
                    if (userModel != null) {
                      isPremiumUser = userModel.subscriptionIsValid!;
                    }
                    for (final coupon in coupons) {
                      if (!isPremiumUser && coupon.isPremium) {
                        continue;
                      }
                      // allCoupons = coupons;
                      if (coupon.type == CouponTypeEnum.instore) {
                        onsiteCoupons.add(coupon);
                        allCoupons.add(coupon);
                      } else if (coupon.type == CouponTypeEnum.online) {
                        onlineCoupons.add(coupon);
                        allCoupons.add(coupon);
                      }
                    }
                  },
                  error: (error, stackTrace) =>
                      debugPrint('Error fetching coupon: $error'),
                  loading: () => debugPrint('Loading coupon data...'),
                );
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.padding),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              ref.watch(couponNotifierCtr).setSelectedOption(0);
                            },
                            child: CouponsChip(
                              text: '${options[0]} (${allCoupons.length})',
                              isSelected:
                                  ref.watch(couponNotifierCtr).selectedIndex ==
                                      0,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              ref.read(couponNotifierCtr).setSelectedOption(1);
                            },
                            child: CouponsChip(
                              text: '${options[1]} (${onlineCoupons.length})',
                              isSelected:
                                  ref.watch(couponNotifierCtr).selectedIndex ==
                                      1,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              ref.read(couponNotifierCtr).setSelectedOption(2);
                            },
                            child: CouponsChip(
                              text: '${options[2]} (${onsiteCoupons.length})',
                              isSelected:
                                  ref.watch(couponNotifierCtr).selectedIndex ==
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
                              isWallet: false,
                            )
                          : ref.read(couponNotifierCtr).selectedIndex == 1
                              ? OnsiteCoupons(
                                  coupons: onlineCoupons,
                                  isWallet: false,
                                )
                              : OnsiteCoupons(
                                  coupons: onsiteCoupons,
                                  isWallet: false,
                                ),
                    ),
                  ],
                );
              },
              //  orElse: () => LoadingWidget(),
              //   );
              //  }
            ),
          ),
        ],
      ),
    );
  }
}

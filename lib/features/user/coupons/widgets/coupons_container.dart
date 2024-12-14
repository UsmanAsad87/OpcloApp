import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/commons/common_widgets/cached_retangular_network_image.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/coupons/controller/coupon_controller.dart';
import 'package:opclo/routes/route_manager.dart';

import '../../../../commons/common_functions/padding.dart';
import '../../../../models/coupon_model.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/my_colors.dart';
import '../../../../utils/thems/styles_manager.dart';

class CouponsContainer extends StatelessWidget {
  final CouponModel coupon;
  final bool isWallet;

  const CouponsContainer(
      {Key? key, required this.coupon, required this.isWallet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.couponsDetailScreen,
            arguments: {'couponModel': coupon});
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h, left: 20.w, right: 20.w),
        padding: EdgeInsets.all(8.r),
        // width: 160.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: context.whiteColor,
            boxShadow: [
              BoxShadow(
                  spreadRadius: 0,
                  blurRadius: 10,
                  color: context.titleColor.withOpacity(.10),
                  offset: const Offset(0, 0))
            ]),
        child: Row(
          children: [
            CachedRectangularNetworkImageWidgetCoupon(
              image: coupon.logo,
              width: 83,
              height: 83,
              fontSize: MyFonts.size12,
            ),
            padding8,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 225.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        coupon.type.type,
                        // coupon.inStore ? 'ONSITE' : 'ONLINE',
                        style: getMediumStyle(
                            color: context.titleColor.withOpacity(.5.r),
                            fontSize: MyFonts.size8),
                      ),
                      // ToDO : wallet coupon removal;
                      // if (isWallet)
                      // Consumer(
                      //     builder: (context, ref, child) {
                      //       return InkWell(
                      //         onTap: () {
                      //           ref.read(couponControllerProvider.notifier)
                      //               .deleteCouponFromWallet(
                      //                walletCouponId: coupon.id, context: context);
                      //         },
                      //         child: Text(
                      //           '- Remove from wallet',
                      //           style: getMediumStyle(
                      //               color: context.primaryColor,
                      //               fontSize: MyFonts.size11),
                      //         ),
                      //       );
                      //     }
                      // ),
                    ],
                  ),
                ),
                padding2,
                Text(
                  coupon.title,
                  // '${coupon.sale}% off Sale',
                  style: getSemiBoldStyle(
                      color: context.titleColor, fontSize: MyFonts.size14),
                ),
                padding2,
                Text(
                  coupon.shortDescription,
                  style: getRegularStyle(
                      color: context.titleColor.withOpacity(.5.r),
                      fontSize: MyFonts.size11),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../models/coupon_model.dart';
import '../../../../utils/thems/styles_manager.dart';
import '../../coupons/widgets/coupon_horizontal_container.dart';

class WalletCouponWidget extends StatelessWidget {
  final List<CouponModel> coupons;

  const WalletCouponWidget({Key? key, required this.coupons}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(coupons.isEmpty);
    return coupons.isEmpty
        ? Center(
            child: Text(
              'No Coupon Saved Yet!',
              style:
                  getSemiBoldStyle(color: context.titleColor.withOpacity(.5)),
            ),
          )
        : SizedBox(
            height: coupons.length == 1
                ? 115.h
                : coupons.length == 2
                    ? 200.h
                    : coupons.length >= 3
                        ? 230.h
                        : 0.h,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                for (int i = 0; i < coupons.length && i < 3; i++)
                  Positioned(
                    top: i * 60.h,
                    child: CouponHorizontalContainer(
                      couponModel: coupons[i],
                    ),
                  ),
              ],
            ),
          );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../commons/common_shimmer/coupon_shimmers/coupons_row_shimmer.dart';
import '../../../../commons/common_widgets/custom_see_all_widget.dart';
import '../../../../models/coupon_model.dart';
import '../../../../routes/route_manager.dart';
import '../../../../utils/thems/styles_manager.dart';
import '../../coupons/controller/coupon_controller.dart';
import '../../home/widgets/coupon_container.dart';

class FeaturedCoupons extends ConsumerWidget {
  final bool isPremiumUser;
  const FeaturedCoupons({Key? key, required this.isPremiumUser,}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      children: [
        CustomSeeAllWidget(
            title: 'Featured Coupon\'s',
            buttonText: 'See all',
            onTap: () {
              Navigator.pushNamed(
                  context, AppRoutes.listOfCouponsScreen);
            }),
        padding16,
        Container(
          // margin: EdgeInsets.only(left: 12.w),
          height: 180.h,
          child: ref.watch(getAllCouponsProvider).when(
              data: (coupons) {
                final filteredCoupons = coupons.where((coupon) {
                  return isPremiumUser || !coupon.isPremium;
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
                      return Padding(
                        padding: EdgeInsets.only(left: index == 0 ? 12.w : 0),
                        child: CouponContainer(
                          couponModel: coupon,
                        ),
                      );
                    });
              },
              error: (error, stackTrace) => SizedBox(),
              loading: () => CouponsRowShimmer(count: 4)
          ),
        )
      ],
    );
  }
}

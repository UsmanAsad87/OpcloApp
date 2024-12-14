import 'package:flutter/material.dart';
import 'package:opclo/commons/common_widgets/cached_retangular_network_image.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/models/coupon_model.dart';
import 'package:opclo/routes/route_manager.dart';

import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';

class CouponContainer extends StatelessWidget {
  final CouponModel couponModel;

  const CouponContainer({Key? key, required this.couponModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.couponsDetailScreen,
            arguments: {'couponModel': couponModel});
      },
      child: Container(
        margin: EdgeInsets.all(8.r),
        padding: EdgeInsets.all(8.r),
        width: 113.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: context.whiteColor,
            boxShadow: [
              BoxShadow(
                  spreadRadius: 0,
                  blurRadius: 17.r,
                  color: context.titleColor.withOpacity(.10),
                  offset: const Offset(0, 0)
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 66.h,
              child: CachedRectangularNetworkImageWidgetCoupon(
                image: couponModel.logo,
                width: 60,
                height: 60,
                fit: BoxFit.contain,
                fontSize: MyFonts.size12,
              ),
            ),
            padding8,
            Text(
              couponModel.type.type,
              style: getMediumStyle(
                  color: context.titleColor.withOpacity(.5),
                  fontSize: MyFonts.size8),
            ),
            padding2,
            Text(
              couponModel.title,
              style: getSemiBoldStyle(
                  color: context.titleColor, fontSize: MyFonts.size13),
            ),
            padding2,
            Expanded(
              child: Text(
                couponModel.shortDescription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: getRegularStyle(
                    color: context.titleColor.withOpacity(.5),
                    fontSize: MyFonts.size10),
              ),
            )
          ],
        ),
      ),
    );
  }
}

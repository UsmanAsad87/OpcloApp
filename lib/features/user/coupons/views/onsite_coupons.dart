import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/features/user/coupons/views/no_coupons.dart';
import 'package:opclo/models/coupon_model.dart';

import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../utils/loading.dart';
import '../../../../utils/utils.dart';
import '../controller/coupon_controller.dart';
import '../widgets/coupons_container.dart';

class OnsiteCoupons extends StatelessWidget {
  final List<CouponModel> coupons;
  final bool isWallet;

  const OnsiteCoupons({Key? key, required this.coupons, required this.isWallet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return coupons.length <= 0
        ? NoCoupons()
        : ListView.builder(
            itemCount: coupons.length,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            itemBuilder: (context, index) {
              return CouponsContainer(
                coupon: coupons[index],
                isWallet: isWallet,
              );
            });
  }
}

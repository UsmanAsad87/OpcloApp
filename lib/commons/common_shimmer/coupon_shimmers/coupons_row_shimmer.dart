import 'package:flutter/material.dart';
import 'package:opclo/commons/common_shimmer/coupon_shimmers/coupon_card_shimmer.dart';

class CouponsRowShimmer extends StatelessWidget {
  final int count;
  const CouponsRowShimmer({Key? key, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: count,
        itemBuilder: (context, index) {
          return CouponCardShimmer();
        });
  }
}

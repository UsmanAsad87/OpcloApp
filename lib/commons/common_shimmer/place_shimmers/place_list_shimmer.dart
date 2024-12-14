import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/commons/common_shimmer/place_shimmers/place_card_shimmer.dart';

class PlaceListShimmer extends StatelessWidget {
  final int count;
  final Axis? scrollDirection;
  final ScrollPhysics? physics;
  final double? cardWidth;
  final double? cardRightMargin;
  final bool leftMargin;

  const PlaceListShimmer(
      {Key? key,
      required this.count,
      this.scrollDirection,
      this.physics,
      this.cardWidth,
      this.cardRightMargin,
      this.leftMargin = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: physics ?? NeverScrollableScrollPhysics(),
        scrollDirection: scrollDirection ?? Axis.vertical,
        itemCount: count,
        itemBuilder: (context, index) {
          return PlaceCardShimmer(
            width: cardWidth,
            rightMargin: cardRightMargin,
            leftMargin: leftMargin && index == 0 ? 20.w : null,
          );
        });
  }
}

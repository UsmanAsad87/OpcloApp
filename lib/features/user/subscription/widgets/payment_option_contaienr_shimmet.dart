import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../commons/common_functions/padding.dart';


class ShimmerPaymentOptionContainer extends StatelessWidget {
  const ShimmerPaymentOptionContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            width: 150.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          padding8,
          Container(
            margin: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                  width: 1.5.w, color: Colors.grey[300]!),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    padding8,

                    Container(
                      width: 100.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    padding8,
                    Container(
                      width: 70.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    padding16,
                    Container(
                      width: double.infinity,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.r),
                          bottomRight: Radius.circular(12.r),
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(4.r),
                    child: Container(
                      width: 20.r,
                      height: 20.r,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

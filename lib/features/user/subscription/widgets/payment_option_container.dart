import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/subscription/widgets/shapes_painter.dart';

import '../../../../commons/common_functions/padding.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';

class PaymentOptionContainer extends StatelessWidget {
  final isSave;
  final Function() onTap;
  final bool isSelected;
  final ProductDetails productDetails;

  const PaymentOptionContainer(
      {Key? key,
      required this.isSave, required this.onTap, required this.isSelected, required this.productDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap ,
      child: Column(
        children: [
          Text(
            productDetails.description,
            style: getSemiBoldStyle(
                color: context.titleColor, fontSize: MyFonts.size16),
          ),
          padding8,
          Container(
            margin: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                    width: 1.5.w, color: isSelected?MyColors.green:context.titleColor.withOpacity(.1.r))),
            child: Stack(
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          productDetails.title.split(" ")[0],
                          style: getBoldStyle(
                              color: context.titleColor,
                              fontSize: MyFonts.size28),
                        ),
                        Text(
                          productDetails.title.split(" ")[1],
                          style: getSemiBoldStyle(
                            color: context.titleColor,
                          ),
                        ),
                      ],
                    ),
                    padding16,
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: MyColors.alertContainerColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12.r),
                              bottomRight: Radius.circular(12.r),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: !isSave ? 18.h : 12.h, horizontal: 23.w),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  productDetails.price,
                                  style: getBoldStyle(
                                      color: context.titleColor,
                                      fontSize: MyFonts.size18),
                                ),
                               if (isSave)
                                Text(
                                  isSave ? '(${productDetails.currencySymbol}${(productDetails.rawPrice/12).round()}/month)' : '',
                                  style: getSemiBoldStyle(
                                      color: context.titleColor.withOpacity(.3.r),
                                      fontSize: MyFonts.size10),
                                )
                              ],
                            ),
                          ),
                        ),
                        if (isSave)
                          Positioned(
                            top: -10.h,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.h, horizontal: 8.w),
                                decoration: BoxDecoration(
                                    color: MyColors.triangleColor,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Text(
                                  'save 33%',
                                  style: getSemiBoldStyle(
                                      color: context.whiteColor,
                                      fontSize: MyFonts.size8),
                                ),
                              ),
                            ),
                          )
                      ],
                    )
                  ],
                ),
                if (isSave)
                  ClipRRect(
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(12.r)),
                    child: CustomPaint(
                      painter: ShapesPainter(MyColors.triangleColor),
                      child: Container(
                        height: 50.h,
                      ),
                    ),
                  ),
                if (isSave)
                  Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(4.r),
                        child: Icon(
                          Icons.check_circle,
                          color: context.whiteColor,
                          size: 20.r,
                        ),
                      ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
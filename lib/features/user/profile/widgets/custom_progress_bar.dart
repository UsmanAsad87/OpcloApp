import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';

class CustomProgressBar extends StatelessWidget {

  final bool profileExist;
  const CustomProgressBar({Key? key, required this.profileExist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(8.r),
          padding: EdgeInsets.all(2.r),
          width: double.infinity,
          height: 15.h,
          decoration: BoxDecoration(
            color: context.primaryColor,
            borderRadius: BorderRadius.circular(50.r),
            border: Border.all(color: context.containerColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.r),
                    bottomLeft: Radius.circular(50.r),
                  )),
                ),
              ),
              Container(
                height: double.infinity,
                width: 2.w,
                color: context.whiteColor,
              ),
              Expanded(
                child: Container(
                  height: double.infinity,
                  color: profileExist ? null : context.whiteColor,
                ),
              ),
              Container(
                height: double.infinity,
                width: 2,
                // color: profileExist ? context.primaryColor : context.red,
              ),
              Expanded(
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: context.containerColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50.r),
                        bottomRight: Radius.circular(50.r),
                      )),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          top: 0,
          left: profileExist ? 100 : 0,
          // left: 100.w,
          right: profileExist ? 0 : 100.w,
          child: Container(
            width: 25.w,
            height: 25.h,
            decoration: BoxDecoration(
                color: context.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(width: 3.w,color: context.whiteColor)
            ),
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import '../../../../utils/thems/styles_manager.dart';

class ContainerButton extends StatelessWidget {
  final buttonText;
  final onPressed;
  Color? color;
  double? fontSize;
  double? borderRadius;
  ContainerButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
     this.fontSize,
    this.borderRadius,
    this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: onPressed,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.r),
        decoration: BoxDecoration(
          color: color ?? Colors.red.withOpacity(.8.r),
          borderRadius: BorderRadius.circular( borderRadius ?? 8.r),
        ),
          child: Text(
            buttonText,
            style: getSemiBoldStyle(
                color: context.whiteColor,
                fontSize: fontSize ?? 14.r
            ),
          )
      ),
    );
  }
}

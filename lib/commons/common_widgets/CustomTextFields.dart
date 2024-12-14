import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import 'package:opclo/utils/thems/styles_manager.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onFieldSubmitted;
  final TextInputType? inputType;
  final Function(String) onChanged;
  final bool obscure;
  final IconData? icon;
  final String? Function(String?)? validatorFn;
  final Widget? leadingIcon;
  final Widget? tailingIcon;
  final String? leadingIconPath;
  final double? texfieldHeight;
  // final String label;
  final bool showLabel;
  final int? maxline;
  final Function()? onEditingComplete;
  final TextInputAction? textInputAction;

  const CustomTextField({
    Key? key,
    required this.controller,

    required this.hintText,
    required this.onChanged,
    required this.onFieldSubmitted,
    this.inputType,
    this.leadingIcon,
    required this.obscure,
    this.validatorFn,
    this.icon,
    this.tailingIcon,
    this.leadingIconPath,
    this.texfieldHeight,
    this.showLabel = true,
    this.maxline,
    this.onEditingComplete,
    this.textInputAction
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: texfieldHeight != null
              ? BoxConstraints(minHeight: texfieldHeight!)
              : BoxConstraints(minHeight: 62.h),
          decoration: BoxDecoration(
            color: context.whiteColor,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: TextFormField(
            maxLines: maxline ?? 1,
            onEditingComplete: onEditingComplete,
            textInputAction: textInputAction,
            validator: validatorFn,
            obscureText: obscure,
            controller: controller,
            keyboardType: inputType,
            style: getMediumStyle(fontSize: MyFonts.size14, color: MyColors.black.withOpacity(.5)),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
              prefixIcon: leadingIconPath !=null?
              Padding(
                padding: EdgeInsets.all(13.0.h),
                child: Image.asset(
                  leadingIconPath!,
                  width: 15.w,
                  height: 15.h,
                ),
              ):null,
              errorStyle: getRegularStyle(
                  fontSize: MyFonts.size10,
                  color: Theme.of(context).colorScheme.error),
              suffixIcon: tailingIcon,
              hintText: hintText,
              hintStyle: getMediumStyle(
                  fontSize: MyFonts.size14,
                  color: context.titleColor.withOpacity(.4)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color:  context.titleColor.withOpacity(.5))
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color:  context.titleColor.withOpacity(.5))
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color:  context.titleColor.withOpacity(.5))
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color:  context.titleColor.withOpacity(.5))
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            onFieldSubmitted: onFieldSubmitted,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

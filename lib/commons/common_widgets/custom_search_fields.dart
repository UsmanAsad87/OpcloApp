
import 'package:flutter_svg/flutter_svg.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../utils/constants/assets_manager.dart';
import '../../utils/constants/font_manager.dart';


class CustomSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final TextInputType? inputType;
  final String? Function(String?)? validatorFn;
  final double? texFieldHeight;
  final double? borderRadius;
  final double? verticalPadding;
  final double? verticalMargin;
  final Color? fillColor;
  final int? maxLines;
  final BorderSide? borderSide;
  final Color? hintColor;
  final Widget? icon;
  final Color? iconColor;
  final FocusNode? focusNode;
  final bool? enable;
  final Function()? prefixOnTap;
  final Function()? onEditingComplete;
  final TextInputAction? textInputAction;
  const CustomSearchField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onFieldSubmitted,
    this.inputType,
    this.validatorFn,
    this.texFieldHeight,
    this.fillColor,
    this.maxLines,
    this.borderRadius,
    this.verticalPadding,
    this.verticalMargin,
    this.borderSide,
    this.hintColor,
    this.icon,
    this.iconColor,
    this.focusNode,
    this.enable,
    this.prefixOnTap,
    this.onEditingComplete,
    this.textInputAction
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.containerColor.withOpacity(.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      margin: EdgeInsets.symmetric(vertical: verticalMargin ?? 10.h),
      child: TextFormField(
        onEditingComplete: onEditingComplete,
        textInputAction: textInputAction,
        validator: validatorFn,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines ?? 1,
        enabled: enable ?? true,
        style: getRegularStyle(
            fontSize: MyFonts.size14, color: context.titleColor),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w, vertical: verticalPadding ?? 0.0),
          errorStyle: getRegularStyle(
              fontSize: MyFonts.size10,
              color: Theme.of(context).colorScheme.error),
          prefixIcon: InkWell(
            onTap: prefixOnTap,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            child: Padding(
              padding: EdgeInsets.all(13.0.h),
              child: icon ?? SvgPicture.asset(
                AppAssets.search,
                width: 8.w,
                height: 8.h,
                color: iconColor ?? context.primaryColor,
              ),
            ),
          ),
          hintText: hintText,
          hintStyle: getRegularStyle(
              fontSize: MyFonts.size13, color: hintColor ?? context.bodyTextColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
            borderSide: borderSide ?? BorderSide(
                color: context.bodyTextColor.withOpacity(0.4), width: 1.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
            borderSide: borderSide ?? BorderSide(color: context.bodyTextColor, width: 1.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
            borderSide: borderSide ?? BorderSide(color: context.bodyTextColor, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
            borderSide: BorderSide(color: context.errorColor, width: 1.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
            borderSide: BorderSide(color: context.errorColor, width: 1.0),
          ),
        ),
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        focusNode: focusNode,
      ),
    );
  }
}

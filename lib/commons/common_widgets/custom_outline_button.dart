

import 'package:opclo/core/extensions/color_extension.dart';

import '../../utils/constants/font_manager.dart';
import '../../utils/loading.dart';
import '../common_imports/common_libs.dart';

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.isLoading = false,
    this.backColor,
    this.textColor,
    this.buttonWidth,
    this.buttonHeight,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.borderColor,
  });

  final Function()? onPressed;
  final String buttonText;
  final bool isLoading;
  final Color? backColor;
  final Color? textColor;
  final double? buttonWidth;
  final double? buttonHeight;
  final double? fontSize;
  final double? padding;
  final double? borderRadius;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('customOnlineButtonContainer'),
      height: buttonHeight ?? 53.h,
      margin: EdgeInsets.symmetric(vertical: padding ?? 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          border: Border.all(color: context.primaryColor, width: 1.h)),
      child: RawMaterialButton(
        key: const Key('customOutlineButton'),
        elevation: 2,
        fillColor: backColor ?? context.whiteColor,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
        ),
        child: SizedBox(
          // padding: EdgeInsets.symmetric(vertical: 10.h),
          width: buttonWidth ?? double.infinity,
          height: buttonHeight ?? 45.h,
          child: Center(
            child: isLoading
                ? LoadingWidget(color: context.titleColor)
                : Text(
                    key: const Key('buttonText'),
                    buttonText,
                    style: getSemiBoldStyle(
                        color: textColor ?? context.primaryColor,
                        fontSize: fontSize ?? MyFonts.size16),
                  ),
          ),
        ),
      ),
    );
  }
}

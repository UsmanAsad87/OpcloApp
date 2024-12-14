import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import 'package:opclo/utils/loading.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.isLoading = false,
    this.loadingColor,
    this.backColor,
    this.textColor,
    this.buttonWidth,
    this.buttonHeight,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.borderSide,
    this.icon,
  });
  final Function()? onPressed;
  final String buttonText;
  final bool isLoading;
  final Color? loadingColor;
  final Color? backColor;
  final Color? textColor;
  final double? buttonWidth;
  final double? buttonHeight;
  final double? fontSize;
  final double? padding;
  final double? borderRadius;
  final BorderSide? borderSide;
  final Icon?  icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: buttonHeight ?? 53.h,
      margin: EdgeInsets.symmetric(vertical: padding ?? 10.h),
      child: RawMaterialButton(
        elevation: 2,
        fillColor: backColor ?? Theme.of(context).primaryColor,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          side: borderSide ?? BorderSide.none,
        ),
        child: SizedBox(
          // padding: EdgeInsets.symmetric(vertical: 10.h),
          width: buttonWidth ?? double.infinity,
          height: buttonHeight ?? 56.h,
          child: Center(
              child: isLoading
                  ?  LoadingWidget(
                      color: loadingColor ?? Theme.of(context).colorScheme.onPrimary
                    )
                  : icon == null ? Text(
                      buttonText,
                      style: getSemiBoldStyle(
                          color: textColor ?? Colors.white,
                          fontSize: fontSize ?? MyFonts.size14),
                    ):
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon!,
                  padding4,
                  Text(
                    buttonText,
                    style: getSemiBoldStyle(
                        color: textColor ?? Colors.white,
                        fontSize: fontSize ?? MyFonts.size14),
                  )
                ],
              )),
        ),
      ),
    );
  }
}

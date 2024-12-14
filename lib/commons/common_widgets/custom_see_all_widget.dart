import 'package:opclo/core/extensions/color_extension.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/font_manager.dart';
import '../common_imports/common_libs.dart';

class CustomSeeAllWidget extends StatelessWidget {
  final String title;
  final Function() onTap;
  final String? buttonText;
  final padding;
  final double? fontSize;
  final Color? buttonTextColor;

  const CustomSeeAllWidget({
    Key? key,
    required this.title,
    required this.onTap,
    this.padding,
    this.buttonText,
    this.fontSize,
    this.buttonTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: getSemiBoldStyle(
                color: context.titleColor,
                fontSize: fontSize ?? MyFonts.size16),
          ),
          InkWell(
            onTap: onTap,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            splashColor: Colors.transparent,
            child: Text(
              buttonText ?? 'See all',
              style: getRegularStyle(
                  color: buttonTextColor ?? context.primaryColor,
                  fontSize: MyFonts.size14),
            ),
          )
        ],
      ),
    );
  }
}

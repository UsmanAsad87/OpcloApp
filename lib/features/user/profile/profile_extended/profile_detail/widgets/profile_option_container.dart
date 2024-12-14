import 'package:flutter_svg/flutter_svg.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';

import '../../../../../../commons/common_imports/common_libs.dart';

class ProfileOptionContainer extends StatelessWidget {
  final BorderSide? bottomBorder;
  final String title;
  final String? icon;
  final Color? textColor;
  final Widget? trilling;
  final Function()? onTap;

  const ProfileOptionContainer(
      {Key? key,
      this.bottomBorder,
      required this.title,
      this.icon,
      this.textColor,
      this.trilling,
      this.onTap,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: 1.5.r, color: context.titleColor.withOpacity(.2)),
                bottom: bottomBorder ?? BorderSide.none)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                icon == null
                    ? padding8
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Image.asset(
                          icon!,
                          width: 19.w,
                          height: 18.h,
                          color: icon == AppAssets.starIconImage
                              ? context.titleColor.withOpacity(.4)
                              : null,
                        ),
                        //Icon(icon ?? Icons.subscriptions),
                      ),
                Text(
                  title,
                  style: getMediumStyle(
                      color: textColor ?? context.titleColor.withOpacity(.5),
                      fontSize: MyFonts.size15),
                ),
              ],
            ),
            if (trilling != null) trilling!
          ],
        ),
      ),
    );
  }
}

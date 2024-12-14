import 'package:flutter_svg/flutter_svg.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../utils/constants/font_manager.dart';
import '../controller/main_menu_controller.dart';

class BottomBarItem extends StatelessWidget {
  const BottomBarItem({
    super.key,
    required this.mainMenuCtr,
    required this.onTap,
    required this.label,
    required this.icon,
    required this.index,
    this.isAdd = false,
  });

  final MainMenuController mainMenuCtr;
  final Function() onTap;
  final String label;
  final String icon;
  final int index;
  final bool isAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isAdd ? 10.w : 0.w,
      ),
      child: SizedBox(
        width: isAdd ? 45.w : 70.w,
        height: 50.h,
        child: InkWell(
          onTap: onTap,
          child: isAdd
              ? Container(
                  color: context.whiteColor,
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: 5.w,
                    ),
                    decoration: BoxDecoration(
                        color: context.primaryColor,
                        borderRadius: BorderRadius.circular(4.r)),
                    child: Center(
                      child: SvgPicture.asset(icon,
                          width: 24.w, height: 24.h, color: context.whiteColor),
                    ),
                  ),
                )
              : Container(
                  color: context.whiteColor,
                  child: SvgPicture.asset(
                    icon,
                    width: 2.w,
                    height: 2.h,
                    color: mainMenuCtr.index == index
                        ? context.primaryColor
                        : context.titleColor.withOpacity(.3),
                  ),
                ),
        ),
      ),
    );
  }
}

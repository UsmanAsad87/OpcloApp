import 'package:flutter_svg/flutter_svg.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/alert/alerts_extended/custom_widgets/custom_radio.dart';
import 'package:opclo/features/user/alert/alerts_extended/occasions/widgets/selectable_option.dart';
import 'package:opclo/utils/constants/assets_manager.dart';

import '../../../../../../commons/common_imports/common_libs.dart';
import '../../../../../../utils/constants/font_manager.dart';

class DropDown extends StatefulWidget {
  const DropDown({
    super.key,
    required this.title,
    required this.icon,
    this.initiallyExpanded,
    this.items,

  });

  final String title;
  final bool? initiallyExpanded;
  final String icon;
  final Widget? items;

  @override
  State<DropDown> createState() => _ExpandTileWidgetState();
}

class _ExpandTileWidgetState extends State<DropDown> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: MyColors.occasionContainerColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTileTheme(
        contentPadding: EdgeInsets.zero,
        dense: true,
        horizontalTitleGap: 0,
        minLeadingWidth: 0,
        minVerticalPadding: 0,
        child: ExpansionTile(
          onExpansionChanged: (val) {
            setState(() {
              isExpanded = val;
            });
          },
          collapsedBackgroundColor: MyColors.occasionContainerColor,
          initiallyExpanded: widget.initiallyExpanded ?? isExpanded,
          maintainState: true,
          // backgroundColor: context.scaffoldBackgroundColor,
          tilePadding: EdgeInsets.symmetric(horizontal: 8.h),
          iconColor: isExpanded ? context.whiteColor : context.titleColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          collapsedIconColor: context.titleColor,
          childrenPadding: const EdgeInsets.all(0),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                margin: EdgeInsets.only(right: 12.w),
                decoration: BoxDecoration(
                    color: context.whiteColor, shape: BoxShape.circle),
                child: Image.asset(
                  widget.icon,
                  width: 21.w,
                  height: 22.h,
                ),
              ),
              Text(
                widget.title,
                style: getMediumStyle(
                    fontSize: MyFonts.size15, color: context.titleColor),
              ),
            ],
          ),
          trailing: Icon(
            isExpanded
                ? Icons.keyboard_arrow_up_sharp
                : Icons.keyboard_arrow_down_sharp,
            size: 23.h,
            color: context.titleColor,
          ),
          children: <Widget>[
            Container(
              height: .5.h,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: context.titleColor.withOpacity(.5),
              ),
            ),
            if (widget.items != null)
            widget.items!,

          ],
        ),
      ),
    );
  }

}

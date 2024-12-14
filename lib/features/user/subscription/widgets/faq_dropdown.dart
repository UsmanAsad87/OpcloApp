import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../commons/common_imports/common_libs.dart';
import '../../../../utils/constants/font_manager.dart';

class FAQDropdown extends StatefulWidget {
  const FAQDropdown({
    super.key,
    required this.title,
    required this.desc,
    this.initiallyExpanded,
  });

  final String title;
  final String desc;
  final bool? initiallyExpanded;

  @override
  State<FAQDropdown> createState() => _ExpandTileWidgetState();
}

class _ExpandTileWidgetState extends State<FAQDropdown> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.0.w, vertical: 0.h),
      child: Container(
       padding: EdgeInsets.symmetric(/*horizontal: 12.w,*/ vertical: 8.h),
        decoration: BoxDecoration(
            color: context.whiteColor,
            border: Border(
                bottom: BorderSide(
                    width: 1, color: MyColors.heartColor))
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
            collapsedBackgroundColor: context.whiteColor,
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
            title: Text(
              widget.title,
              style: getRegularStyle(
                  fontSize: MyFonts.size12, color: context.titleColor),
            ),
            trailing: Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: context.primaryColor.withOpacity(.1.r),
                borderRadius: BorderRadius.circular(8.r)

              ),
              child: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up_sharp
                    : Icons.add,
                size: 23.h,
                color: context.primaryColor.withOpacity(.6.r),
              ),
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                child: ListTile(
                  title: Padding(
                    padding:  EdgeInsets.only(left: 8.w),
                    child: Text(
                      widget.desc,
                      style: getRegularStyle(
                          color: context.titleColor.withOpacity(.8.r),
                          fontSize: MyFonts.size11),
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 10.h,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

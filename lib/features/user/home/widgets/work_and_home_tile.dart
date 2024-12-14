import 'package:flutter_svg/svg.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';

class WorkAndHomeTile extends StatelessWidget {
  final title;
  final subtitle;
  final iconPath;

  const WorkAndHomeTile(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.iconPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: context.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 16.r,
            spreadRadius: 0,
            offset: Offset(0,0),
            color: context.titleColor.withOpacity(.05),
          )
        ]
      ),
      child: ListTile(
        tileColor: context.whiteColor,
        leading: SvgPicture.asset(iconPath, width: 25),
        title: Text(
            title,
            style: getSemiBoldStyle(
                color: context.titleColor, fontSize: MyFonts.size16)),
        subtitle: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            subtitle,
            maxLines: 2,
            style: getMediumStyle(
                color: context.titleColor.withOpacity(.4),
                fontSize: MyFonts.size13),
          ),
        ),
        trailing: SvgPicture.asset(
          AppAssets.pinIcon,
          width: 20,
          color: context.titleColor.withOpacity(.5),
        ),
      ),
    );
  }
}

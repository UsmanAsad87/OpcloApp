import 'package:flutter_svg/svg.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../commons/common_imports/common_libs.dart';

class ActionIcon extends StatelessWidget {
  final icon;
  Color? color;

  ActionIcon({Key? key, required this.icon, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              width: .3.w, color: context.titleColor.withOpacity(.2.r))),
      child: SvgPicture.asset(
        icon,
        color: color ?? context.primaryColor,
        width: 18.w,
        height: 18.h,
      ),
    );
  }
}

import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../commons/common_imports/common_libs.dart';
import '../../../../utils/constants/font_manager.dart';

class CustomFavCopContainer extends StatelessWidget {
  final value;
  final name;
  const CustomFavCopContainer({Key? key,required this.value, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          value,
          style: getSemiBoldStyle(
              color: context.titleColor,
              fontSize: MyFonts.size20
          ),
        ),
        Text(
         name,
          style: getMediumStyle(
              color: context.titleColor.withOpacity(.5.r),
              fontSize: MyFonts.size13
          ),
        )
      ],
    );
  }
}

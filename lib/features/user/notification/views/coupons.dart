import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../utils/constants/font_manager.dart';

List<String> images = [
  AppAssets.pizzaHutImage,
  AppAssets.mac,
  AppAssets.starBucks
];

class Coupons extends StatelessWidget {
  const Coupons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 32.r),
          child: Image.asset(
            AppAssets.noCouponsImage,
            width: 230.w,
            height: 280.h,
          ),
        ),
        padding16,
        Text(
          'No Coupons (yet!)',
          style: getSemiBoldStyle(color: context.titleColor),
        ),
        padding8,
        Text(
          "Check this section for daily coupons",
          textAlign: TextAlign.center,
          style: getMediumStyle(
              color: context.titleColor.withOpacity(.5),
              fontSize: MyFonts.size13),
        ),
        // CouponContainerNotification(
        //   icon: AppAssets.starBucks,
        //   title: '\$3 Off Code',
        //   subtitle:  'Lorem ipsum is a placeholder text',
        //   time: '1w',
        //   type: "ONLINE",
        //   bgColor: MyColors.starbucksColor,
        // ),CouponContainerNotification(
        //   icon:  AppAssets.mac,
        //   title: 'Only \$18.99',
        //   subtitle:  'Lorem ipsum is a placeholder text commonly used to demonstrate the visual',
        //   time: '2w',
        //   type: "IN-STORE",
        //   bgColor: MyColors.red,
        // ),
        //
        // CouponContainerNotification(
        //   icon:  AppAssets.pizzaHutImage,
        //   title: '\$3 Off Code',
        //   subtitle:  'Lorem ipsum is a placeholder text commonly used',
        //   time: '1w',
        //   type: "ONLINE",
        //
        //   bgColor: MyColors.pizzaHutColor,
        // )
      ],
    );
  }
}

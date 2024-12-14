import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import '../../../../commons/common_functions/padding.dart';
import '../../../../routes/route_manager.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import 'container_button.dart';

class OpcloPremiumContainer extends StatelessWidget {
  const OpcloPremiumContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
            context, AppRoutes.subscriptionScreen);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.8.r,
            colors: const [
              Color(0xff393939),
              Color(0xff232323)
            ],
            stops: const [.2, 8],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppConstants.allPadding),
          child: Row(
            children: [
              Image.asset(
                AppAssets.premiumStart,
                width: 85.w,
                height: 85.h,
              ),
              padding12,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Opclo Premium',
                    style: getSemiBoldStyle(
                        color: context.whiteColor,
                        fontSize: MyFonts.size18),
                  ),
                  Text(
                    'Free for 1 Month',
                    style: getMediumStyle(
                        color: context.whiteColor
                            .withOpacity(.5.r),
                        fontSize: MyFonts.size11),
                  ),
                  padding4,
                  // GestureDetector(
                  //   onTap: (){
                  //     Navigator.pushNamed(
                  //         context, AppRoutes.subscriptionScreen);
                  //   },
                  //   child:
                    ContainerButton(
                      buttonText: 'TRY NOW',
                      fontSize: 12.r,
                      color: Colors.red.withOpacity(.8.r),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, AppRoutes.subscriptionScreen);
                      },
                    // ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

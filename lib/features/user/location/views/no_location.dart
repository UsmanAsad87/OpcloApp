import 'package:opclo/core/extensions/color_extension.dart';
import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_widgets/custom_button.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';

class NoLocation extends StatelessWidget {
  final Function() onTap;
  const NoLocation({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: context.whiteColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: context.whiteColor,
              leading: InkWell(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: context.titleColor,
                ),
              ),
              centerTitle: true,
              title: Text(
                'Location Services',
                style: getSemiBoldStyle(
                    color: context.titleColor, fontSize: MyFonts.size18),
              ),
            ),
            body: Column(
              children: [
                Image.asset(
                  AppAssets.noLocationImage,
                  width: 300.w,
                  height: 400.h,
                ),
                Padding(
                  padding: EdgeInsets.all(AppConstants.allPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Location Services turned off',
                        style: getSemiBoldStyle(
                            color: context.titleColor,
                            fontSize: MyFonts.size18),
                      ),
                      padding8,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: Text(
                          'Please enable location access to use Opclo',
                          textAlign: TextAlign.center,
                          style: getMediumStyle(
                              color: context.titleColor.withOpacity(.3),
                              fontSize: MyFonts.size13),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  onPressed: onTap,
                  buttonText: 'Go To Settings',
                  buttonWidth: 200.w,
                )
              ],
            ),
          );
  }
}

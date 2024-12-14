import 'package:flutter_svg/svg.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../commons/common_functions/padding.dart';
import '../../../commons/common_imports/common_libs.dart';
import '../../../commons/common_widgets/custom_button.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/assets_manager.dart';
import '../../../utils/constants/font_manager.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 700.h,
        decoration: BoxDecoration(
          color: context.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
        ),
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(AppConstants.allPadding),
                child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new_outlined,
                                color: context.titleColor,
                              )),
                        ],
                      ),
                      padding16,
                      Center(
                          child: SvgPicture.asset(
                            AppAssets.appLogo,
                            width: 61,
                            height: 66,
                            color: context.primaryColor,
                          )),
                      padding16,
                      Text(
                        'Success',
                        style: getSemiBoldStyle(
                            color: context.titleColor,
                            fontSize: MyFonts.size20),
                      ),
                      padding4,
                      SizedBox(
                        width: 225.w,
                        child: Text(
                          'you’ll receive an email with a reset link shortly if an account exist with that email',
                          textAlign: TextAlign.center,
                          style: getMediumStyle(
                              color: context.titleColor.withOpacity(.5),
                              fontSize: MyFonts.size13),
                        ),
                      ),
                      padding24,
                      CustomButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        buttonText: 'Okay',
                        buttonWidth: 200.w,
                        backColor: context.primaryColor,
                      ),
                      padding16,

                    ]))));
  }
}

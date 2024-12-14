import 'package:flutter_svg/svg.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../commons/common_functions/padding.dart';
import '../../../commons/common_functions/validator.dart';
import '../../../commons/common_imports/apis_commons.dart';
import '../../../commons/common_widgets/CustomTextFields.dart';
import '../../../commons/common_widgets/custom_button.dart';
import '../../../routes/route_manager.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/assets_manager.dart';
import '../../../utils/constants/font_manager.dart';
import '../controller/auth_controller.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  final onTap;
  final bool isSkip;

  const ForgotPassword({Key? key, this.onTap, this.isSkip = false})
      : super(key: key);

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  forget() async {
    if (formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus!.unfocus();
      await ref.read(authControllerProvider.notifier).forgetPassword(
            email: emailController.text.trim(),
          );
    }
  }

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
                child: Column(children: [
                  Row(
                    mainAxisAlignment: widget.isSkip
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      widget.isSkip
                          ? InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.mainMenuScreen);
                              },
                              child: Text(
                                'Skip',
                                style:
                                    getMediumStyle(color: context.primaryColor),
                              ))
                          : IconButton(
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
                    ),
                  ),
                  padding16,
                  Text(
                    'Forgot Password',
                    style: getSemiBoldStyle(
                        color: context.titleColor, fontSize: MyFonts.size20),
                  ),
                  padding4,
                  SizedBox(
                    width: 200.w,
                    child: Text(
                      'We will send you a link to reset you password',
                      textAlign: TextAlign.center,
                      style: getMediumStyle(
                          color: context.titleColor.withOpacity(.5),
                          fontSize: MyFonts.size13),
                    ),
                  ),
                  padding24,
                  Form(
                    key: formKey,
                    child: CustomTextField(
                      controller: emailController,
                      hintText: 'Emial address',
                      validatorFn: emailValidator,
                      onChanged: (value) {},
                      onFieldSubmitted: (value) {},
                      obscure: false,
                    ),
                  ),
                  CustomButton(
                    isLoading: ref.watch(authControllerProvider),
                    onPressed: () async {
                      await forget();
                      widget.onTap();
                    },
                    buttonText: 'Reset Password',
                    backColor: context.primaryColor,
                  ),
                  padding16,
                  Text(
                    'Don’t receive an account?',
                    style: getMediumStyle(
                        color: context.titleColor.withOpacity(.3),
                        fontSize: MyFonts.size15),
                  ),
                  padding4,
                  InkWell(
                    onTap: () {},
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    child: Text(
                      'Resend Now',
                      style: getBoldStyle(
                          color: MyColors.green,
                          fontSize: MyFonts.size13,
                          isUnderLine: true),
                    ),
                  )
                ]))));
  }
}

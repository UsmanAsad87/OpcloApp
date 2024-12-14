import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_widgets/CustomTextFields.dart';
import 'package:opclo/commons/common_widgets/custom_button.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import '../../../commons/common_functions/validator.dart';
import '../../../commons/common_imports/common_libs.dart';
import '../controller/auth_controller.dart';

class SignInScreen extends ConsumerWidget {
  final onTap;
  final forgotButton;
  final bool isSkip;

  SignInScreen({super.key, this.onTap, this.forgotButton, this.isSkip = false,});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Container(
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
                  Stack(
                    children: [
                      if(!isSkip)
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: context.titleColor,
                          )),
                      Center(
                          child: SvgPicture.asset(
                        AppAssets.appLogo,
                        width: 50,
                        height: 50,
                        color: context.primaryColor,
                      )),
                      if(isSkip)
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.mainMenuScreen);
                            },
                            child: Text(
                              'Skip',
                              style:
                                  getMediumStyle(color: context.primaryColor),
                            )),
                      )
                    ],
                  ),
                  padding12,
                  Text(
                    isSkip ? 'Log In' : 'Welcome Back',
                    style: getSemiBoldStyle(
                        color: context.titleColor, fontSize: MyFonts.size20),
                  ),
                  Text(
                    'login with your email and password',
                    style: getMediumStyle(
                        color: context.titleColor.withOpacity(.5),
                        fontSize: MyFonts.size13),
                  ),
                  padding12,
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: emailController,
                          hintText: 'Email address',
                          validatorFn: emailValidator,
                          onChanged: (value) {},
                          onFieldSubmitted: (value) {},
                          obscure: false,
                          texfieldHeight: 55.h,
                        ),
                        CustomTextField(
                          controller: passwordController,
                          hintText: 'Password (min 6 characters)',
                          validatorFn: passValidator,
                          onChanged: (value) {},
                          onFieldSubmitted: (value) {},
                          obscure: false,
                          texfieldHeight: 55.h,
                        ),
                      ],
                    ),
                  ),
                  padding12,
                  InkWell(
                    onTap: forgotButton,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    child: Text(
                      'Forgot Password?',
                      style: getMediumStyle(
                        color: context.primaryColor,
                        fontSize: MyFonts.size13,
                      ),
                    ),
                  ),
                  padding12,
                  CustomButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await ref
                            .read(authControllerProvider.notifier)
                            .signInWithUsernameAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                                context: context,
                                ref: ref);
                      }
                    },
                    buttonText: 'Log in',
                  ),
                  padding12,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                            height: 1,
                            color: context.titleColor.withOpacity(.2)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('or',
                            style: getMediumStyle(
                                color: context.titleColor.withOpacity(.5),
                                fontSize: MyFonts.size13)),
                      ),
                      Expanded(
                        child: Container(
                            height: 1,
                            color: context.titleColor.withOpacity(.2)),
                      ),
                    ],
                  ),
                  padding12,
                  CustomButton(
                    onPressed: () {
                      ref
                          .read(authControllerProvider.notifier)
                          .signInWithApple(context: context, ref: ref);
                    },
                    buttonText: 'Sign in with Apple',
                    backColor: context.titleColor.withOpacity(.8),
                    icon: Icon(
                      Icons.apple,
                      color: context.whiteColor,
                      size: 32.r,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ref
                          .read(authControllerProvider.notifier)
                          .signInWithGoogle(context: context, ref: ref);
                    },
                    child: Container(
                      height: 53.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.sp),
                        color: MyColors.facebookColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppAssets.googleIconImage,
                            height: 24.sp,
                            width: 24.sp,
                          ),
                          SizedBox(width: 10.sp),
                          Text(
                            'Sign in Google',
                            style: getSemiBoldStyle(
                                color: MyColors.white,
                                fontSize: MyFonts.size16),
                          )
                        ],
                      ),
                    ),
                  ),
                  // CustomButton(
                  //   onPressed: () {},
                  //   buttonText: 'Continue with Facebook',
                  //   backColor: MyColors.facebookColor,
                  //   icon:
                  //   // Icon(
                  //   //   Icons.chrome,
                  //   //   color: context.whiteColor,
                  //   //   size: 32.r,
                  //   // ),
                  // ),
                  padding12,
                  Text(
                    'Don\'t have an account?',
                    style: getSemiBoldStyle(
                        color: context.titleColor.withOpacity(.3),
                        fontSize: MyFonts.size15),
                  ),
                  padding4,
                  InkWell(
                    onTap: onTap,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    child: Text(
                      'SignUp',
                      style: getBoldStyle(
                          color: MyColors.green,
                          fontSize: MyFonts.size14,
                          isUnderLine: true),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        if (ref.watch(authControllerProvider))
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: context.titleColor.withOpacity(.3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  color: context.primaryColor,
                ),
              ),
            ),
          ),
      ],
    );
    // )
    //   ],
    // );
  }
}

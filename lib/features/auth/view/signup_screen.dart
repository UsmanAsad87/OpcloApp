import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../commons/common_functions/padding.dart';
import '../../../commons/common_functions/validator.dart';
import '../../../commons/common_imports/common_libs.dart';
import '../../../commons/common_widgets/CustomTextFields.dart';
import '../../../commons/common_widgets/custom_button.dart';
import '../../../commons/common_widgets/show_toast.dart';
import '../../../routes/route_manager.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/assets_manager.dart';
import '../../../utils/constants/font_manager.dart';
import 'dart:io' show Platform;

class SignUpScreen extends ConsumerStatefulWidget {
  final onTap;
  final bool isSkip;

  const SignUpScreen({Key? key, this.onTap, this.isSkip = false,}) : super(key: key);

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

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
                      if(!widget.isSkip)
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
                      if(widget.isSkip)
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
                    'Join Us Today!',
                    style: getSemiBoldStyle(
                        color: context.titleColor, fontSize: MyFonts.size20),
                  ),
                  Text(
                    'Sign up with your email and password',
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
                            controller: nameController,
                            hintText: 'Name',
                            validatorFn: uNameValidator,
                            onChanged: (value) {},
                            onFieldSubmitted: (value) {},
                            obscure: false,
                            texfieldHeight: 55.h),
                        CustomTextField(
                            controller: usernameController,
                            hintText: 'User Name',
                            onChanged: (value) {},
                            onFieldSubmitted: (value) {},
                            validatorFn: validateUsername,
                            obscure: false,
                            texfieldHeight: 55.h),
                        CustomTextField(
                            controller: emailController,
                            hintText: 'Email address',
                            validatorFn: emailValidator,
                            onChanged: (value) {},
                            onFieldSubmitted: (value) {},
                            obscure: false,
                            texfieldHeight: 55.h),
                        CustomTextField(
                            controller: passwordController,
                            hintText: 'Password (min 6 characters)',
                            validatorFn: passValidator,
                            onChanged: (value) {},
                            onFieldSubmitted: (value) {},
                            obscure: false,
                            texfieldHeight: 55.h),
                      ],
                    ),
                  ),
                  padding12,
                  Text(
                    'By signing up, you agree to our',
                    style: getMediumStyle(
                        color: context.titleColor.withOpacity(.4),
                        fontSize: MyFonts.size13),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            _launchUrl('https://opclo.app/terms-of-use/'),
                        child: Text(
                          'Terms of service',
                          style: getBoldStyle(
                              color: MyColors.green,
                              fontSize: MyFonts.size12,
                              isUnderLine: true),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.r),
                        child: Text(
                          '&',
                          style: getSemiBoldStyle(
                              color: context.titleColor.withOpacity(.4)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            _launchUrl('https://opclo.app/privacy-policy/'),
                        child: Text(
                          'Privacy Policy',
                          style: getBoldStyle(
                              color: MyColors.green,
                              isUnderLine: true,
                              fontSize: MyFonts.size12),
                        ),
                      ),
                    ],
                  ),
                  padding12,
                  Consumer(builder: (context, ref, child) {
                    return CustomButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          ref
                              .read(authControllerProvider.notifier)
                              .registerWithEmailAndPassword(
                                  name: nameController.text.trim(),
                                  uname: usernameController.text.trim(),
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  context: context,
                                  ref: ref);
                        }
                      },
                      buttonText: 'Create Account',
                    );
                  }),
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
                  Row(
                    children: [
                      if (Platform.isIOS)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.r),
                            child: CustomButton(
                              onPressed: () {
                                ref
                                    .read(authControllerProvider.notifier)
                                    .signInWithApple(
                                        context: context, ref: ref);
                              },
                              buttonText: 'Apple',
                              backColor: context.titleColor.withOpacity(.8),
                              icon: Icon(
                                Icons.apple,
                                color: context.whiteColor,
                                size: 32.r,
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(8.0.h),
                        child: GestureDetector(
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
                                  'Google',
                                  style: getSemiBoldStyle(
                                      color: MyColors.white,
                                      fontSize: MyFonts.size16),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                          // Padding(
                          //   padding: EdgeInsets.all(8.r),
                          //   child: CustomButton(
                          //     onPressed: () {},
                          //     buttonText: 'Facebook',
                          //     backColor: MyColors.facebookColor,
                          //     icon: Icon(
                          //       Icons.facebook,
                          //       color: context.whiteColor,
                          //       size: 32.r,
                          //     ),
                          //   ),
                          // ),
                          ),
                    ],
                  ),
                  padding12,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: getMediumStyle(
                            color: context.titleColor.withOpacity(.3),
                            fontSize: MyFonts.size13),
                      ),
                      padding4,
                      InkWell(
                        onTap: widget.onTap,
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        child: Text(
                          'Login',
                          style: getBoldStyle(
                              color: MyColors.green,
                              fontSize: MyFonts.size14,
                              isUnderLine: true),
                        ),
                      ),
                    ],
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
  }

  Future<void> _launchUrl(String url) async {
    try {
      final Uri _url = Uri.parse(url);
      if (!await launchUrl(_url)) {}
    } catch (e) {
      showToast(msg: 'Invalid link');
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/commons/common_enum/signup_type/signup_type.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
import 'package:opclo/features/user/main_menu/controller/main_menu_controller.dart';

import '../../../../../../commons/common_functions/padding.dart';
import '../../../../../../commons/common_functions/validator.dart';
import '../../../../../../commons/common_imports/common_libs.dart';
import '../../../../../../commons/common_widgets/CustomTextFields.dart';
import '../../../../../../commons/common_widgets/custom_button.dart';
import '../../../../../../utils/constants/assets_manager.dart';
import '../../../../../../utils/constants/font_manager.dart';
import '../../../../../auth/controller/auth_controller.dart';

class ConfirmDialog extends ConsumerStatefulWidget {
  const ConfirmDialog({super.key});

  @override
  ConsumerState<ConfirmDialog> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<ConfirmDialog> {
  final TextEditingController passwordController = TextEditingController();
  bool passObscure = true;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(authControllerProvider.notifier);
    final signInType = ref.read(authNotifierCtr).userModel?.signupTypeEnum;
    return Container(
      // height: ref.read(profileNotifierCtr).isDeleteAccount ? 395.h : 300.h,
      height: 300.h,
      width: 300.w,
      decoration: BoxDecoration(
        color: context.whiteColor,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      onTap: () {
                        Navigator.pop(context);
                        // ref.read(profileNotifierCtr).setIsDeleteAccount(false);
                      },
                      child: Icon(
                        Icons.close,
                        size: 25.r,
                      )
                      // Image.asset(
                      //   AppAssets.dialogCloseIcon,
                      //   height: 25.h,
                      //   width: 25.h,
                      // ),
                      ),
                ],
              ),
              padding8,
              // Image.asset(
              //   AppAssets.infoRound,
              //   height: 70.h,
              //   width: 70.w,
              // ),
              padding12,
              Text(
                'Are You Sure Want To Delete The Account Permanently?',
                textAlign: TextAlign.center,
                style: getRegularStyle(
                    color: context.secondaryContainerColor,
                    fontSize: MyFonts.size15),
              ),
              padding4,
              Text(
                'All your data will be lost.',
                textAlign: TextAlign.center,
                style: getMediumStyle(
                    color: context.errorColor, fontSize: MyFonts.size14),
              ),
              // ref.watch(profileNotifierCtr).isDeleteAccount
              //     ?
              if(signInType == SignupTypeEnum.email )
              CustomTextField(
                // fillColor: context.secondaryContainerColor.withOpacity(0.4),
                controller: passwordController,
                hintText: 'Enter Password',
                // label: 'Password',
                validatorFn: passValidator,
                obscure: passObscure,
                tailingIcon: passObscure == false
                    ? InkWell(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          setState(() {
                            passObscure = !passObscure;
                          });
                        },
                        child: Icon(
                          CupertinoIcons.eye,
                          color: context.bodyTextColor,
                          size: 20.h,
                        ))
                    : InkWell(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          setState(() {
                            passObscure = !passObscure;
                          });
                        },
                        child: Icon(
                          CupertinoIcons.eye_slash,
                          color: context.bodyTextColor,
                          size: 20.h,
                        )),
                onChanged: (String) {},
                onFieldSubmitted: (String) {},
              ),

              // : Container(),
              padding24,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                      //borderColor: context.secondaryContainerColor,
                      backColor: Colors.transparent,
                      buttonHeight: 38.h,
                      buttonWidth: 130.w,
                      onPressed: () {
                        Navigator.pop(context);
                        // ref.read(profileNotifierCtr).setIsDeleteAccount(false);
                      },
                      textColor: context.secondaryContainerColor,
                      buttonText: 'Cancel'),
                  CustomButton(
                      isLoading: ref.watch(authControllerProvider),
                      backColor: context.errorColor,
                      buttonHeight: 38.h,
                      buttonWidth: 130.w,
                      onPressed: () async {
                        if (signInType == SignupTypeEnum.google || signInType == SignupTypeEnum.apple) {

                          await controller.deleteAccount(
                              context: context,
                              isGoogle: signInType == SignupTypeEnum.google ||
                                  signInType == SignupTypeEnum.apple);
                          ref.read(mainMenuProvider).setIndex(0);
                        } else {
                          await controller.deleteAccount(
                              context: context,
                              password: passwordController.text,
                              isGoogle: false);
                          ref.read(mainMenuProvider).setIndex(0);
                        }
                      },
                      textColor: MyColors.white,
                      buttonText: 'Delete'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

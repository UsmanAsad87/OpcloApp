import 'dart:ui';

import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/view/forgot_password.dart';
import 'package:opclo/features/auth/view/signin_screen.dart';
import 'package:opclo/features/auth/view/signup_screen.dart';
import 'package:opclo/features/auth/view/success_screen.dart';

import '../../../commons/common_imports/common_libs.dart';

class AuthScreen extends StatefulWidget {
  final bool isSignIn;
  final bool? isSkip;

  const AuthScreen({Key? key, required this.isSignIn, this.isSkip})
      : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool isSignIn;
  bool isForgot = false;
  bool isSuccess = false;

  @override
  void initState() {
    isSignIn = widget.isSignIn;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:  () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Stack(
          children: [
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 700.h,
              margin: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: context.containerColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
            )),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: isSuccess
                ? SuccessScreen()
                : isForgot
                    ? ForgotPassword(
                        onTap: () {
                          setState(() {
                            isSuccess = true;
                          });
                        },
                        isSkip: widget.isSkip ?? false,
                      )
                    : isSignIn
                        ? SignInScreen(
                            onTap: () {
                              setState(() {
                                isSignIn = false;
                              });
                            },
                            forgotButton: () {
                              setState(() {
                                isForgot = true;
                              });
                            },
                            isSkip: widget.isSkip ?? false,
                          )
                        : SignUpScreen(
                            onTap: () {
                              setState(() {
                                isSignIn = true;
                              });
                            },
                            isSkip: widget.isSkip ?? false),
        ),
      ]),
    );
  }
}

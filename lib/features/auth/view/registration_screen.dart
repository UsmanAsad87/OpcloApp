import 'package:flutter/material.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../commons/common_functions/show_login.dart';
import '../../../commons/common_providers/shared_pref_helper.dart';
import 'auth_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) async {
      await showModalBottomSheet(
          context: context,
          isDismissible: false,
          enableDrag: false,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return const AuthScreen(isSignIn: true, isSkip: true,);
          });
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
    );
  }
}

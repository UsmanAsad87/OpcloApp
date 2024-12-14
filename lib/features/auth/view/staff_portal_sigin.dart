import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/commons/common_widgets/CustomTextFields.dart';
import 'package:opclo/commons/common_widgets/common_circle_widget.dart';
import 'package:opclo/commons/common_widgets/custom_button.dart';
import 'package:opclo/commons/common_functions/validator.dart';
import 'package:opclo/features/auth/controller/auth_controller.dart';
import 'package:opclo/features/auth/widgets/sigin_custom_button.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';

class StaffPortalSignInScreen extends StatefulWidget {
  const StaffPortalSignInScreen({Key? key}) : super(key: key);

  @override
  State<StaffPortalSignInScreen> createState() =>
      _StaffPortalSignInScreenState();
}

class _StaffPortalSignInScreenState extends State<StaffPortalSignInScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  GlobalKey<FormState> loginInKey = GlobalKey<FormState>();
  var passObscure = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: [

            ],
          ),
        ),
      ),
    );
  }
}

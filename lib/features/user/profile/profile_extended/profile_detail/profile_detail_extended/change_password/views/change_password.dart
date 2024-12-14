import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_widgets/custom_button.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/profile/profile_extended/edit_profile/widgets/profile_text_field.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import '../../../../../../../../commons/common_imports/common_libs.dart';
import '../../../../../../../../commons/common_widgets/show_toast.dart';
import '../../../../../../../../utils/constants/font_manager.dart';
import '../../../../../../../auth/controller/auth_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController conformPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    oldPasswordController.dispose();
    conformPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.whiteColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: context.titleColor,
          ),
        ),
        title: Text(
          'Change Password',
          style: getSemiBoldStyle(
            color: context.titleColor,
            fontSize: MyFonts.size18,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppConstants.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  // Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 16.h),
                  //   child: Text(
                  //     'Create an account to continue',
                  //     style: getRegularStyle(
                  //       color: context.titleColor.withOpacity(.3),
                  //       fontSize: MyFonts.size13,
                  //     ),
                  //   ),
                  // ),
                  ProfileTextField(
                    controller: oldPasswordController,
                    title: 'Old Password',
                  ),
                  ProfileTextField(
                    controller: passwordController,
                    title: 'Password',
                  ),
                  ProfileTextField(
                    controller: conformPasswordController,
                    title: 'Conform Password',
                  ),
                ],
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                return CustomButton(
                  // onPressed: () {},
                  isLoading: ref.watch(authControllerProvider),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      if (passwordController.text ==
                          conformPasswordController.text) {
                        await ref
                            .read(authControllerProvider.notifier)
                            .changeUserPassword(
                            currentPass: oldPasswordController.text,
                            newPass: passwordController.text,
                            context: context);
                      } else {
                        showToast(msg: 'Pssword dont match!');
                      }
                    } else {
                      showToast(msg: 'All Fields are required!');
                    }
                  },
                  buttonText: 'Change Password',
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}

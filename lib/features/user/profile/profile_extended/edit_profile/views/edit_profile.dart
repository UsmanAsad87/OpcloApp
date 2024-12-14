import 'package:opclo/commons/common_enum/signup_type/signup_type.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_widgets/CustomTextFields.dart';
import 'package:opclo/commons/common_widgets/custom_button.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_controller.dart';
import 'package:opclo/features/user/profile/profile_extended/edit_profile/widgets/profile_text_field.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import '../../../../../../commons/common_imports/apis_commons.dart';
import '../../../../../../commons/common_imports/common_libs.dart';
import '../../../../../../models/user_model.dart';
import '../../../../../auth/controller/auth_notifier_controller.dart';
import '../../../../home/widgets/address_bottom_sheet.dart';
import '../widgets/edit_profile_image_widget.dart';

class EditProfile extends ConsumerStatefulWidget {
  final UserModel userModel;

  const EditProfile({Key? key, required this.userModel}) : super(key: key);

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  // LocationDetails? workAddressController;
  // LocationDetails? homeAddressController;

  TextEditingController workAddressController = TextEditingController();
  TextEditingController homeAddressController = TextEditingController();

  String? imagePath;
  final formKey = GlobalKey<FormState>();
  bool isUnique = false;

  @override
  void initState() {
    final userModel = widget.userModel;
    nameController.text = userModel.name;
    emailController.text = userModel.email;
    userNameController.text = userModel.userName;
    workAddressController.text = userModel.workAddress?.name ?? '';
    homeAddressController.text = userModel.homeAddress?.name ?? '';
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<String?> _showPasswordBottomSheet(BuildContext context) async {
    TextEditingController passwordController = TextEditingController();

    return await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom, // Handle keyboard overlap
          ),
          child: Container(
            // height: 200.h,
            decoration: BoxDecoration(
              color: context.whiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Enter your password',
                    style: getMediumStyle(
                        color: context.bodyTextColor, fontSize: MyFonts.size18),
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    onChanged: (String) {},
                    onFieldSubmitted: (String) {},
                    obscure: true,
                  ),
                  SizedBox(height: 16),
                  CustomButton(
                      onPressed: () =>
                          Navigator.pop(context, passwordController.text),
                      isLoading: ref.watch(authControllerProvider),
                      buttonWidth: 150.w,
                      buttonText: 'SUBMIT')
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.pop(context, passwordController.text);
                  //   },
                  //   child: Text('Submit'),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userCtr = ref.watch(authNotifierCtr).userModel;
    return Stack(
      children: [
        Scaffold(
            backgroundColor: context.whiteColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: context.whiteColor,
              automaticallyImplyLeading: false,
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: context.titleColor,
                ),
              ),
              title: Text(
                'Profile',
                style: getSemiBoldStyle(
                  color: context.titleColor,
                  fontSize: MyFonts.size18,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (emailController.text != widget.userModel.email) {
                      String? password =
                          await _showPasswordBottomSheet(context);
                      if (password == null) {
                        return;
                      }
                      final isChange = await ref
                          .read(authControllerProvider.notifier)
                          .updateEmailAddress(
                              newEmail: emailController.text, pass: password);
                      if (!isChange) {
                        return;
                      }
                    }
                    UserModel updateUserModel = widget.userModel.copyWith(
                        name: nameController.text.trim(),
                        userName: userNameController.text,
                        email: emailController.text,
                        homeAddress: userCtr?.homeAddress,
                        workAddress: userCtr?.workAddress
                    );

                    ref.watch(authControllerProvider.notifier)
                        .updateCurrentUserInfo(
                            context: context,
                            userModel: updateUserModel,
                            ref: ref,
                            oldUserName: widget.userModel.userName,
                            imagePath: imagePath);
                  },
                  child: Text(
                    'Save',
                    style: getMediumStyle(
                      color: context.primaryColor,
                      fontSize: MyFonts.size16,
                    ),
                  ),
                )
              ],
            ),
            body: InkWell(
              onTap: FocusScope.of(context).unfocus,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.padding),
                  child: Column(
                    children: [
                      padding18,
                      EditProfileImageWidget(
                        userImage: widget.userModel.profileImage ?? '',
                        imgPath: (imgPath) {
                          imagePath = imgPath;
                        },
                        name: '' + ' ',
                      ),
                      padding8,
                      ProfileTextField(
                        title: 'Name',
                        controller: nameController,
                      ),
                      Form(
                          key: formKey,
                          child: ProfileTextField(
                              title: 'User name',
                              controller: userNameController,
                              validator: (value) {
                                isUnique ? "Name already taken" : null;
                              })),
                      ProfileTextField(
                        title: 'Email',
                        controller: emailController,
                        enabled: widget.userModel.signupTypeEnum ==
                                    SignupTypeEnum.email
                            ? true
                            : false,
                      ),
                      InkWell(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              enableDrag: true,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return AddressBottomSheet(
                                  address: 'Set Home Address',
                                  isSignUp: false,
                                );
                              });
                        },
                        child: ProfileAddressField(
                          title: 'Home address',
                          controller: homeAddressController,
                          maxline: 2,
                          enabled: false,
                          address:  userCtr?.homeAddress
                                      ?.name ?? "Tap to Add",
                        ),
                      ),
                      InkWell(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              enableDrag: true,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return AddressBottomSheet(
                                  address: 'Set Work Address',
                                  isSignUp: false,
                                );
                              });
                        },
                        child: ProfileAddressField(
                          title: 'Work address',
                          controller: workAddressController,
                          maxline: 2,
                          enabled: false,
                          address: userCtr?.workAddress?.name ?? "Tap to Add",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
        if (ref.watch(authControllerProvider))
          Container(
            color: context.bodyTextColor.withOpacity(.5),
            child: Center(
              child: CircularProgressIndicator(
                color: context.primaryColor,
              ),
            ),
          )
      ],
    );
  }

  checkUserName<bool>(String userName) {
    return ref
        .read(authControllerProvider.notifier)
        .checkUserNameUniqueness(userName)
        .then((value) => value);
  }
}

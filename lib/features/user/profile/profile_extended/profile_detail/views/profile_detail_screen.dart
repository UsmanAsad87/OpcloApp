import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_enum/signup_type/signup_type.dart';
import 'package:opclo/commons/common_functions/open_app_in_store.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_shimmer/loading_images_shimmer.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_controller.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
import 'package:opclo/features/user/main_menu/controller/main_menu_controller.dart';
import 'package:opclo/features/user/profile/profile_extended/profile_detail/widgets/non_active.dart';
import 'package:opclo/features/user/profile/profile_extended/profile_detail/widgets/profile_option_container.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version_check/version_check.dart';

import '../../../../../../commons/common_functions/share_app_link.dart';
import '../../../../../../commons/common_imports/common_libs.dart';
import '../../../../../../commons/common_widgets/cached_circular_network_image.dart';
import '../../../../../../commons/common_widgets/show_toast.dart';
import '../../../../../../models/user_model.dart';
import '../../../../../../utils/constants/font_manager.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/switch_button.dart';
import 'dart:io' show Platform;

class ProfileDetailScreen extends ConsumerStatefulWidget {
  // final UserModel userModel;

  const ProfileDetailScreen({
    Key? key,
    // required this.userModel
  }) : super(key: key);

  @override
  ConsumerState<ProfileDetailScreen> createState() =>
      _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends ConsumerState<ProfileDetailScreen> {
  bool sync = true;
  late UserModel userModel;

  @override
  initState() {
    userModel = ref.read(authNotifierCtr).userModel!;
    checkVersion();
    super.initState();
  }

  List<String> buttonList1 = [
    'Profile',
    'Subscription',
    'Change Password',
    'Reminder List',
    'Sync to Calender'
  ];
  List<String> buttonListIcon1 = [
    AppAssets.addPersonIcon,
    AppAssets.crownIcon,
    AppAssets.openLockIcon,
    AppAssets.heartIcon,
    AppAssets.calenderIcon
  ];

  listOne({required int index}) {
    if (index == 0) {
      Navigator.pushNamed(context, AppRoutes.editProfileScreen,
          arguments: {'userModel': userModel});
    }
    if (index == 1) {
      Navigator.pushNamed(context, AppRoutes.subscriptionScreen);
    }
    if (index == 2) {
      Navigator.pushNamed(context, AppRoutes.changePasswordScreen);
    }
    if (index == 3) {
      Navigator.pushNamed(context, AppRoutes.reminderScreen);
    }
  }

  void featureTap({required int index}) {
    if (index == 0) {
      _launchUrl("https://opclo.app/new/");
    }
    if (index == 1) {
      final message = shareAppLink();
      if (message == 'error') {
        showToast(msg: 'Try later!');
        return;
      }
      Share.share(message);
    }
    if (index == 2) {
      if (Platform.isIOS) {
        requestReview();
      } else {
        openAppInStore();
      }
    }
    if (index == 3) {
      Navigator.pushNamed(context, AppRoutes.feedbackScreen);
    }
    if (index == 4) {
      _launchUrl("https://opclo.app/questions/");
    }
  }

  Future<void> _launchUrl(String url) async {
    var _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      showSnackBar(context, 'website does not exist');
    }
  }

  List<String> buttonList2 = [
    'What’s New',
    'Invite friends',
    'Rate the App',
    'Feedback',
    'FAQ’s'
  ];

  List<String> logOutText = ['Logout', 'Delete Account'];

  List<String> buttonListIcon2 = [
    AppAssets.whatsNewIcon,
    AppAssets.friendsIcon,
    AppAssets.starIconImage,
    AppAssets.feedback,
    AppAssets.faqsIcon
  ];

  final versionCheck = VersionCheck(
    packageName: 'com.opclollc.opclo',
    showUpdateDialog: (context, versionCheck) {},
  );

  Future checkVersion() async {
    await versionCheck.checkVersion(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    userModel = ref.watch(authNotifierCtr).userModel ?? userModel;
    return Scaffold(
      backgroundColor: context.whiteColor,
      appBar: AppBar(
        backgroundColor: context.whiteColor,
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
          'Settings',
          style: getSemiBoldStyle(
            color: context.titleColor,
            fontSize: MyFonts.size18,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(AppConstants.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        overlayColor: MaterialStateProperty.all(Colors.transparent),

                        onTap: () {
                          Navigator.pushNamed(
                              context, AppRoutes.editProfileScreen);
                        },
                        child: CachedCircularNetworkImageWidget(
                          image: userModel.profileImage,
                          size: 65,
                          name: userModel.name.isNotEmpty
                              ? userModel.name
                              : userModel.email,
                        ),
                      ),
                      padding16,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 220.w,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                userModel.name.isNotEmpty
                                    ? userModel.name
                                    : userModel.email,
                                //'Ada Shelby',
                                style: getSemiBoldStyle(
                                    color: context.titleColor,
                                    fontSize: MyFonts.size20),
                              ),
                            ),
                          ),
                          Text(
                            userModel.userName, //'@Ada_Shelby',
                            style: getRegularStyle(
                                color: context.titleColor.withOpacity(.5.r),
                                fontSize: MyFonts.size13),
                          )
                        ],
                      ),
                    ],
                  ),
                  padding16,
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Text(
                      'Account',
                      style: getSemiBoldStyle(
                          color: context.titleColor, fontSize: MyFonts.size16),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return index == 1 && Platform.isAndroid
                      ? const SizedBox()
                      : index == 2 &&
                              (userModel.signupTypeEnum ==
                                      SignupTypeEnum.google ||
                                  userModel.signupTypeEnum ==
                                      SignupTypeEnum.apple)
                          ? SizedBox()
                          : ProfileOptionContainer(
                              onTap: () {
                                listOne(index: index);
                              },
                              title: buttonList1[index],
                              icon: buttonListIcon1[index],
                              trilling: index == 1
                                  ? NonActive()
                                  : index == 4
                                      ? SwitchButton(
                                          onTap: () {
                                            setState(() {
                                              sync = !sync;
                                            });
                                          },
                                          value: sync)
                                      : null,
                              bottomBorder: index == 4
                                  ? BorderSide(
                                      width: 1.5,
                                      color: context.titleColor.withOpacity(.2))
                                  : null,
                            );
                }),
            padding16,
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalPadding, vertical: 12.h),
              child: Text(
                'Account',
                style: getSemiBoldStyle(
                    color: context.titleColor, fontSize: MyFonts.size16),
              ),
            ),
            ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      featureTap(index: index);
                    },
                    child: ProfileOptionContainer(
                      title: buttonList2[index],
                      icon: buttonListIcon2[index],
                      bottomBorder: index == 4
                          ? BorderSide(
                              width: 1.5.h,
                              color: context.titleColor.withOpacity(.2))
                          : null,
                    ),
                  );
                }),
            padding16,
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalPadding, vertical: 12.h),
              child: versionCheck.packageVersion == null ?
              ShimmerWidget(width: 80.w,height: 30.h,) : Text(
                // 'Version 1.0',
                "Version ${versionCheck.packageVersion}",
                style: getSemiBoldStyle(
                    color: context.titleColor, fontSize: MyFonts.size15),
              ),
            ),
            ListView.builder(
                itemCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ProfileOptionContainer(
                    title: logOutText[index],
                    onTap: () {
                      if (index == 0) {
                        ref.read(mainMenuProvider).setIndex(0);
                        ref.read(authNotifierCtr).setUserModelData(null);
                        ref
                            .read(authControllerProvider.notifier)
                            .logout(context: context);
                        Navigator.of(context).pop();
                      } else if (index == 1) {
                        showGeneralDialog(
                          barrierLabel: "Label",
                          barrierDismissible: true,
                          barrierColor: Colors.black.withOpacity(0.6),
                          transitionDuration: const Duration(milliseconds: 700),
                          context: context,
                          pageBuilder: (context, anim1, anim2) {
                            return Consumer(
                              builder: (context, ref, child) {
                                return const Align(
                                    alignment: Alignment.center,
                                    child: ConfirmDialog());
                              },
                            );
                          },
                          transitionBuilder: (context, anim1, anim2, child) {
                            return SlideTransition(
                              position: Tween(
                                      begin: const Offset(1, 0),
                                      end: const Offset(0, 0))
                                  .animate(anim1),
                              child: child,
                            );
                          },
                        );
                      }
                    },
                    textColor: MyColors.pizzaHutColor,
                    bottomBorder: index == 1
                        ? BorderSide(
                            width: 1.5.h,
                            color: context.titleColor.withOpacity(.2))
                        : null,
                  );
                }),
            padding16,
          ],
        ),
      ),
    );
  }
}

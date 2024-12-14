import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_widgets/custom_button.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_controller.dart';
import 'package:opclo/features/user/home/widgets/work_and_home_tile.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import 'package:opclo/utils/loading.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../models/user_model.dart';
import '../../favorites/widgets/add_address_dailog.dart';
import '../widgets/address_bottom_sheet.dart';

class HomeAndWorkScreen extends StatefulWidget {
  const HomeAndWorkScreen({Key? key}) : super(key: key);

  @override
  State<HomeAndWorkScreen> createState() => _HomeAndWorkScreenState();
}

class _HomeAndWorkScreenState extends State<HomeAndWorkScreen> {
  final TextEditingController homeCtr = TextEditingController();
  final TextEditingController workCtr = TextEditingController();

  @override
  void dispose() {
    homeCtr.dispose();
    workCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      appBar: AppBar(
        elevation: 0,
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
        title: Center(
            child: Text(
          'Home & work',
          style: getSemiBoldStyle(
            fontSize: MyFonts.size18,
            color: context.titleColor,
          ),
        )),
        actions: [
          Consumer(builder: (context, ref, child) {
           return ref.watch(currentUserAuthProvider).when(
                data: (user) =>
                    ref.watch(userInfoByIdStreamProvider(user!.uid)).when(
                        data: (user) {
                          return buildSkipNextButton(context,user);
                        },
                        error: (error, stackTrace) {
                          return buildSkipButton(context);
                        },
                        loading: () => LoadingWidget()),
                error: (error, stackTrace) => buildSkipButton(context),
                loading: () => buildSkipButton(context));
          })
        ],
      ),
      body: Consumer(builder: (context, ref, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppConstants.allPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppAssets.homeAndWork,
                  width: 293.w,
                  height: 219.h,
                ),
                SizedBox(
                  height: 20.h,
                ),
                ref.watch(currentUserAuthProvider).when(
                    data: (user) =>
                        ref.watch(userInfoByIdStreamProvider(user!.uid)).when(
                            data: (user) {
                              return Column(
                                children: [
                                  Text(
                                    'Hey ${user?.name}, we’re so glad you’re here',
                                    textAlign: TextAlign.center,
                                    style: getSemiBoldStyle(
                                        color: context.titleColor,
                                        fontSize: MyFonts.size21),
                                  ),
                                  SizedBox(
                                    height: 14.h,
                                  ),
                                  Text(
                                    'Here when you need us more',
                                    textAlign: TextAlign.center,
                                    style: getMediumStyle(
                                        color:
                                            context.titleColor.withOpacity(.4),
                                        fontSize: MyFonts.size13),
                                  ),
                                  SizedBox(
                                    height: 18.h,
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                                    onTap: () async {
                                      showModalBottomSheet(
                                          context: context,
                                          enableDrag: true,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) {
                                            return AddressBottomSheet(address: 'Set Home Address', isSignUp: true,);
                                          });
                                    },
                                    child: WorkAndHomeTile(
                                        title: 'Home',
                                        subtitle: user?.homeAddress == null
                                            ? 'Set once and go'
                                            : user?.homeAddress?.name,
                                        iconPath: AppAssets.home),
                                  ),
                                  InkWell(
                                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          enableDrag: true,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) {
                                            return AddressBottomSheet(address: 'Set Work Address', isSignUp: true,);
                                          });
                                    },
                                    splashColor: Colors.transparent,
                                    child: WorkAndHomeTile(
                                        title: 'Work',
                                        subtitle: user?.workAddress == null
                                            ? 'Set once and go'
                                            : user?.workAddress?.name,
                                        iconPath: AppAssets.workPerson),
                                  ),
                                ],
                              );
                            },
                            error: (error, stackTrace) {
                              return SizedBox();
                            },
                            loading: () => LoadingWidget()),
                    error: (error, stackTrace) => SizedBox(),
                    loading: () => SizedBox())
              ],
            ),
          ),
        );
      }),
    );
  }

  TextButton buildSkipButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.followFavoriteScreen);
        },
        child: Text(
          'Skip',
          style: getMediumStyle(
              color: context.primaryColor, fontSize: MyFonts.size16),
        ));
  }

  TextButton buildSkipNextButton(BuildContext context,UserModel? userModel) {
    return TextButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.followFavoriteScreen);
        },
        child: Text(
          (userModel?.homeAddress != null && userModel?.workAddress!= null)
              ? 'Next'
              : 'Skip',
          style: getMediumStyle(
              color: context.primaryColor, fontSize: MyFonts.size16),
        ));
  }
}

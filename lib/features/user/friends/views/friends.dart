import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_widgets/CustomTextFields.dart';
import 'package:opclo/commons/common_widgets/custom_button.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';

import '../../../../commons/common_imports/common_libs.dart';
import '../../../../firebase_analytics/firebase_analytics.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    AnalyticsHelper.logScreenView(screenName: 'Friends-Screen');
    super.initState();
  }
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),//BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.all(AppConstants.allPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'JOIN THE \nWAITLIST',
                    style: getExtraBoldStyle(
                        color: context.titleColor, fontSize: MyFonts.size34),
                  ),
                ),
                padding16,
                padding16,
                Text(
                  'Discover, Share, Connect. \nOpclo Friends Your Journey, your community. Coming Soon',
                  style: getSemiBoldStyle(
                      color: context.titleColor, fontSize: MyFonts.size20),
                ),
                padding16,
                Text(
                  'Key features of Opclo Friends',
                  style: getSemiBoldStyle(
                      color: context.titleColor, fontSize: MyFonts.size16),
                ),
                padding16,
                Row(
                  children: [
                    Image.asset(
                      AppAssets.friendPicksIcon,
                      width: 35.w,
                      height: 35.h,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      'Friend Picks',
                      style: getSemiBoldStyle(
                          color: context.titleColor, fontSize: MyFonts.size14),
                    ),
                  ],
                ),
                padding8,
                Row(
                  children: [
                    Image.asset(
                      AppAssets.interactiveFeatureIcon,
                      width: 35.w,
                      height: 35.h,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      'Interactive Features',
                      style: getSemiBoldStyle(
                          color: context.titleColor, fontSize: MyFonts.size14),
                    ),
                  ],
                ),
                padding8,
                Row(
                  children: [
                    Image.asset(
                      AppAssets.inAppMessagingIcon,
                      width: 35.w,
                      height: 35.h,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      'In-App Messaging',
                      style: getSemiBoldStyle(
                          color: context.titleColor, fontSize: MyFonts.size14),
                    ),
                  ],
                ),
                padding48,
                CustomTextField(
                  controller: emailController,
                  hintText: 'Email address',
                  onChanged: (value) {},
                  onFieldSubmitted: (value) {},
                  obscure: false,
                  leadingIconPath: AppAssets.writeEmailIcon,
                ),
                CustomButton(
                  onPressed: () {},
                  buttonText: "Send",
                  padding: 0.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

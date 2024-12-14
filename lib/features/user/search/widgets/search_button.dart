import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
import '../../../../commons/common_functions/show_login.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../routes/route_manager.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../controller/search_limit.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return InkWell(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          onTap: () async {
            final isPrem = ref.watch(authNotifierCtr).userModel?.subscriptionIsValid ?? false;
            if (!isPrem) {
              final canSearch = await SearchLimiter.canSearch();
              if (!canSearch) {
                final remainingTime = await SearchLimiter.timeRemainingToSearch();
                showLimitDialog(
                  context: context,
                  description:
                  'You\'ve reached your limit for today. More access will be available in $remainingTime. Want unlimited access? Upgrade now!',
                );
                return;
              }
            }
            Navigator.pushNamed(context, AppRoutes.searchScreen);
          },
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalPadding),
            decoration: BoxDecoration(
              color: context.containerColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalPadding),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 13.0.h),
                  child: SvgPicture.asset(
                    AppAssets.search,
                    width: 12.w,
                    height: 12.h,
                    color: context.primaryColor,
                  ),
                ),
                SizedBox(width: 8.w,),
                Text('Search restaurants, stores & more',
                    style: getRegularStyle(
                      color: context.titleColor.withOpacity(.5.r),
                      fontSize: MyFonts.size13,
                    )),
              ],
            ),
          ),
        );
      }
    );
  }
}

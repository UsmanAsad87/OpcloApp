import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
import 'package:opclo/features/user/coupons/controller/coupon_controller.dart';
import '../../../../commons/common_functions/date_time_format.dart';
import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_widgets/cached_circular_network_image.dart';
import '../../../../models/user_model.dart';
import '../../../../routes/route_manager.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';
import '../../../auth/controller/auth_controller.dart';
import 'custom_fav_cop_container.dart';
import 'custom_progress_bar.dart';

class ProfileInfo extends StatefulWidget {
  final UserModel userModel;

  const ProfileInfo({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.profileDetailScreen,
                    arguments: {'userModel': widget.userModel});
              },
              child: CachedCircularNetworkImageWidget(
                image: widget.userModel.profileImage,
                size: 90,
                name: widget.userModel.name.isNotEmpty
                    ? widget.userModel.name
                    : widget.userModel.email,
              ),
            ),
            Consumer(builder: (context, ref, child) {
              return CustomFavCopContainer(
                  value: ref.watch(favoritesStreamProvider).when(
                      data: (fav) => '${fav.length.toString()}',
                      error: (e, s) => '',
                      loading: () => '#'),
                  name: 'Favorites');
            }),
            Consumer(
              builder: (context, ref, child) {
                return CustomFavCopContainer(
                  value: ref.watch(getWalletCouponsProvider).when(
                      data: (coupons) => coupons.length.toString(),
                      error: (error, stackTrace) => '0',
                      loading: () => '#'),
                  name: 'Coupons',
                );
              },
            ),
            // IconButton(
            //     onPressed: () {
            //     //  showLogInBottomSheet();
            //     },
            //     icon: Icon(
            //       Icons.login_outlined,
            //       color: context.primaryColor,
            //     ))
            // padding4
          ],
        ),
        padding16,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 180.w,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      widget.userModel.name.isNotEmpty
                          ? widget.userModel.name
                          : widget.userModel.email,
                      maxLines: 1,
                      style: getSemiBoldStyle(
                          color: context.titleColor, fontSize: MyFonts.size20),
                    ),
                  ),
                ),
                Text(
                  "@" + widget.userModel.userName,
                  style: getRegularStyle(
                      color: context.titleColor.withOpacity(.5.r),
                      fontSize: MyFonts.size13),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  'Joined ',
                  style: getRegularStyle(
                      color: context.titleColor, fontSize: MyFonts.size14),
                ),
                Text(
                  formatDateAndMonth(widget.userModel.createdAt),
                  style: getMediumStyle(
                      color: context.titleColor, fontSize: MyFonts.size14),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: 14.h,
        ),
        Consumer(builder: (context, ref, child) {
          final user = ref.watch(authNotifierCtr).userModel;
          return Visibility(
            visible: (user?.profileImage == '' || user?.homeAddress == ''),
            child: Visibility(
              visible: isVisible,
              child: Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: context.whiteColor,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10.r,
                      offset: Offset(10.97.w, 4.32.h),
                      color: context.titleColor.withOpacity(.05),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Onboarding Process',
                          style: getMediumStyle(
                              color: context.titleColor,
                              fontSize: MyFonts.size13),
                        ),
                        InkWell(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onTap: () {
                            setState(() {
                              isVisible = false;
                            });
                          },
                          child: Icon(
                            Icons.close,
                            color: context.titleColor.withOpacity(.5),
                            size: 18.r,
                          ),
                        ),
                      ],
                    ),
                    padding16,
                    CustomProgressBar(
                      profileExist: user?.profileImage != '',
                    ),
                    padding16,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.r),
                      child: Text(
                        user?.profileImage == ''
                            ? 'Add  a profile picture, setup work/home shortcut, add a favorite and take a note.'
                            : 'Setup work/home shortcut, add a favorite and take a note.',
                        style: getRegularStyle(
                            color: context.titleColor.withOpacity(.5),
                            fontSize: MyFonts.size10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        padding16,
      ],
    );
  }
}

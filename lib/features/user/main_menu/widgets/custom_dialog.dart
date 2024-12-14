import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/alert/controller/alert_controller.dart';
import 'package:opclo/models/alert_model.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/loading.dart';
import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_widgets/custom_button.dart';
import '../../../../commons/common_widgets/custom_outline_button.dart';
import '../../../../commons/common_widgets/show_toast.dart';
import '../../../../models/favorite_model.dart';
import '../../../../models/place_model.dart';
import '../../../../models/user_model.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/my_colors.dart';
import '../../../../utils/thems/styles_manager.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../../auth/controller/auth_notifier_controller.dart';
import '../../favorites/widgets/favourit_bottom_sheet.dart';

class CustomDialog extends ConsumerStatefulWidget {
  final PlaceModel place;
  final AlertModel? alert;

  const CustomDialog({Key? key, required this.place, this.alert})
      : super(key: key);

  @override
  ConsumerState<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends ConsumerState<CustomDialog> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
            child: Container(
          margin: EdgeInsets.symmetric(
              vertical: 20),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 0.0.h, vertical: 12.h),
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.primaryDelta! > 0) {
                      setState(() {
                        isExpanded = true;
                      });
                    } else if (details.primaryDelta! < 0) {
                      setState(() {
                        isExpanded = false;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: MyColors.notificationColor.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        padding4,
                        Text(
                          'You are Here',
                          style: getSemiBoldStyle(
                              fontSize: MyFonts.size15,
                              color: context.whiteColor),
                        ),
                        Text(
                          widget.place.placeName,
                          style: getRegularStyle(
                              color: context.whiteColor,
                              fontSize: MyFonts.size12),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          'Open Until ${widget.place.closingTime == '' ? '11 : 00 pm' : widget.place.closingTime}',
                          style: getSemiBoldStyle(
                            color: MyColors.redText,
                            fontSize: MyFonts.size10,
                          ),
                        ),
                        padding4,
                        if (!isExpanded)
                          Material(
                            color: MyColors.notificationColor.withOpacity(0.95),
                            child: InkWell(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              onTap: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'swipe Down',
                                    style: getMediumStyle(
                                        color: context.whiteColor,
                                        fontSize: MyFonts.size10),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    color: context.whiteColor,
                                  )
                                ],
                              ),
                            ),
                          ),
                        if (isExpanded)
                          Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.all(12.r),
                                child: Consumer(builder: (context, ref, child) {
                                  return ref
                                      .watch(
                                          getFavouriteByFsq(widget.place.fsqId))
                                      .when(
                                          data: (fav) {
                                            return CustomOutlineButton(
                                              onPressed: () {
                                                UserModel? user = ref
                                                    .watch(authNotifierCtr)
                                                    .userModel;
                                                if (user != null) {
                                                  if (fav == null) {
                                                    FavoriteModel favorite =
                                                        FavoriteModel(
                                                      id: '',
                                                      fsqId: widget.place.fsqId,
                                                      userId: user.uid,
                                                      groupId: '',
                                                      placeName: widget
                                                          .place.placeName,
                                                      locationName: widget
                                                          .place.locationName,
                                                      date: DateTime.now(),
                                                    );
                                                    ref
                                                        .read(
                                                            authControllerProvider
                                                                .notifier)
                                                        .updateFavorites(
                                                            context: context,
                                                            favoriteModel:
                                                                favorite,
                                                            ref: ref);
                                                  } else {
                                                    showModalBottomSheet(
                                                        context: context,
                                                        enableDrag: true,
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        builder: (context) {
                                                          return FavoriteBottomSheet(
                                                              placeModel:
                                                                  widget.place);
                                                        });
                                                  }
                                                } else {
                                                  showSnackBar(
                                                      context, 'Login to Like');
                                                }
                                              },
                                              borderRadius: 30.r,
                                              buttonHeight: 40.w,
                                              buttonText: fav != null
                                                  ? 'Un favorite'
                                                  : 'Favorite',
                                              fontSize: MyFonts.size11,
                                              textColor:
                                                  MyColors.themeDarkColor,
                                            );
                                          },
                                          error: (e, s) => SizedBox(),
                                          loading: () => LoadingWidget());
                                }),
                              )),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.all(12.r),
                                child: CustomButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context,
                                          AppRoutes.detailResturantScreen,
                                          arguments: {
                                            'placeModel': widget.place
                                          });
                                    },
                                    borderRadius: 30.r,
                                    buttonHeight: 40.w,
                                    fontSize: MyFonts.size11,
                                    borderSide: BorderSide(
                                        width: .7, color: context.whiteColor),
                                    backColor: MyColors.notificationColor,
                                    buttonText: 'View Details'),
                              )),
                            ],
                          ),
                        if (widget.alert != null)
                          if (isExpanded)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 44.w,
                                      height: 44.h,
                                      padding: EdgeInsets.all(11.h),
                                      decoration: BoxDecoration(
                                        color: context.whiteColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: SvgPicture.asset(
                                        AppAssets.alert2,
                                        width: 30.w,
                                        height: 30.h,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 11.w,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Alert!',
                                          style: getSemiBoldStyle(
                                              color: context.whiteColor,
                                              fontSize: MyFonts.size15),
                                        ),
                                        SizedBox(
                                          width: 100.w,
                                          child: FittedBox(
                                            child: Text(
                                              widget.alert!.option.type,
                                              //'incorrect hours',
                                              style: getMediumStyle(
                                                  color: context.whiteColor,
                                                  fontSize: MyFonts.size12),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Consumer(builder: (context, ref, child) {
                                      return CustomButton(
                                        onPressed: () {
                                          ref
                                              .read(alertControllerProvider
                                                  .notifier)
                                              .deleteAlert(
                                                context: context,
                                                alertId: widget.alert!.id,
                                              );
                                        },
                                        isLoading:
                                            ref.watch(alertControllerProvider),
                                        loadingColor: context.primaryColor,
                                        buttonText: 'No',
                                        buttonWidth: 67.w,
                                        buttonHeight: 34.h,
                                        borderRadius: 20.r,
                                        backColor: context.whiteColor,
                                        textColor: MyColors.themeDarkColor,
                                        fontSize: MyFonts.size11,
                                      );
                                    }),
                                    padding4,
                                    Material(
                                      color: MyColors.notificationColor
                                          .withOpacity(0.95),
                                      child: InkWell(
                                        onTap: () async {
                                          // ToDo : Like the alert
                                          if (widget.alert != null) {
                                            await ref
                                                .read(alertControllerProvider
                                                    .notifier)
                                                .addThumbsUp(
                                                    context: context,
                                                    alertId: widget.alert!.id);
                                          }
                                          // Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          width: 34.w,
                                          height: 34.h,
                                          padding: EdgeInsets.all(4.r),
                                          decoration: BoxDecoration(
                                              color: context.whiteColor,
                                              shape: BoxShape.circle),
                                          child: Image.asset(
                                            AppAssets.thumbsUpImage,
                                            width: 12.w,
                                            height: 12.h,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                        padding8,
                        if (isExpanded == true)
                          Material(
                            color: MyColors.notificationColor.withOpacity(0.95),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isExpanded = false;
                                });
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.keyboard_arrow_up_sharp,
                                    color: context.whiteColor,
                                  ),
                                  Text(
                                    'swipe Up to Close',
                                    style: getMediumStyle(
                                        color: context.whiteColor,
                                        fontSize: MyFonts.size10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        padding8,
                      ],
                    ),
                  ),
                )),
          ),
        )));
  }
}

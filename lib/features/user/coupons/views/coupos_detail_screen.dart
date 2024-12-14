import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_functions/date_time_format.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_widgets/cached_circular_network_image.dart';
import 'package:opclo/commons/common_widgets/custom_button.dart';
import 'package:opclo/commons/common_widgets/show_toast.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
import 'package:opclo/features/user/coupons/controller/coupon_controller.dart';
import 'package:opclo/models/wallet_coupon_model/wallet_coupon_model.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import 'package:uuid/uuid.dart';
import '../../../../commons/common_functions/check_user_exist.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../firebase_analytics/firebase_analytics.dart';
import '../../../../models/coupon_model.dart';
import '../../reminder/api/dynamic_link_service.dart';
import '../widgets/like_button.dart';
import 'package:url_launcher/url_launcher.dart';

class CouponsDetailScreen extends ConsumerStatefulWidget {
  final CouponModel couponModel;

  const CouponsDetailScreen({Key? key, required this.couponModel})
      : super(key: key);

  @override
  ConsumerState<CouponsDetailScreen> createState() =>
      _CouponsDetailScreenState();
}

class _CouponsDetailScreenState extends ConsumerState<CouponsDetailScreen> {
  bool like = false;
  bool dislike = false;

  Future<void> _launchUrl() async {
    try {
      final Uri _url = Uri.parse(widget.couponModel.link);
      if (!await launchUrl(_url)) {}
    } catch (e) {
      showToast(msg: 'Invalid link');
    }
  }

  @override
  void initState() {
    like = widget.couponModel.likes
        ?.contains(ref
        .read(authNotifierCtr)
        .userModel
        ?.uid) ??
        false;
    dislike = widget.couponModel.dislikes
        ?.contains(ref
        .read(authNotifierCtr)
        .userModel
        ?.uid) ??
        false;
    AnalyticsHelper.logCouponViewed(couponModel: widget.couponModel);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.couponModel.logo);
    return Scaffold(
      backgroundColor: context.whiteColor,
      appBar: AppBar(
        backgroundColor: context.whiteColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Coupons Detail',
          style: getSemiBoldStyle(
            color: context.titleColor,
            fontSize: MyFonts.size18,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: context.titleColor,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                DynamicLinkService.buildDynamicLinkForCoupon(
                  true, widget.couponModel,);
              },
              icon: Icon(
                Icons.file_upload_outlined,
                color: context.titleColor,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          padding24,
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                  width: 230.w,
                  height: 230.h,
                  //padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // color: MyColors.bestBuyColor,
                  ),
                  child: CachedCircularNetworkImageWidgetCoupon(
                    image: widget.couponModel.logo,
                    size: 10,
                  )
                // Image.asset(
                //   AppAssets.bestBuy,
                //   width: 10.w,
                //   color: Colors.white,
                // ),
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: context.titleColor.withOpacity(.10),
                            blurRadius: 16,
                            spreadRadius: 0,
                            offset: Offset(0, 0),
                          )
                        ]),
                    child: Text(
                      // formatDayMonthYear(widget.couponModel.expiryDate) ==
                      //         "29 Mar, 2024"
                      //     ? "Coming Soon"
                      //     :
                      'Expires : ${formatDayMonthYear(
                          widget.couponModel.expiryDate)}',
                      style: getMediumStyle(
                          color: context.titleColor, fontSize: MyFonts.size13),
                    ),
                  ))
            ],
          ),
          padding18,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    '${widget.couponModel.placeName} • ${widget.couponModel.type
                        .type}',
                    style: getMediumStyle(
                        color: context.titleColor.withOpacity(.5),
                        fontSize: MyFonts.size13),
                  ),
                  padding8,
                  Text(
                    widget.couponModel.title,
                    style: getSemiBoldStyle(
                        color: context.titleColor, fontSize: MyFonts.size23),
                  ),
                  padding8,
                  Text(
                    widget.couponModel.shortDescription,
                    style: getMediumStyle(
                        color: context.titleColor.withOpacity(.5),
                        fontSize: MyFonts.size13),
                  ),
                  padding18,
                  CustomButton(
                      onPressed: () {
                        _launchUrl();
                      },
                      buttonWidth: 170.w,
                      buttonHeight: 53.h,
                      backColor: MyColors.black,
                      buttonText: 'View Now'),
                  padding18,
                  Consumer(builder: (context, ref, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LikeButton(
                            onTap: () {
                              if (!checkUserExist(ref: ref, context: context)) {
                                return;
                              }
                              setState(() {
                                like = !like;
                                dislike = false;
                              });
                              ref
                                  .read(couponControllerProvider.notifier)
                                  .updateFavorites(
                                  context: context,
                                  ref: ref,
                                  couponModel: widget.couponModel,
                                  isLike: true);
                            },
                            buttonColor: MyColors.green,
                            icon: AppAssets.thumbUp,
                            isSelected: like),
                        padding18,
                        LikeButton(
                          onTap: () {
                            if (!checkUserExist(ref: ref, context: context)) {
                              return;
                            }
                            setState(() {
                              dislike = !dislike;
                              like = false;
                            });
                            ref
                                .read(couponControllerProvider.notifier)
                                .updateFavorites(
                                context: context,
                                ref: ref,
                                couponModel: widget.couponModel,
                                isLike: false);
                          },
                          icon: AppAssets.thumbDown,
                          isSelected: dislike,
                          buttonColor: MyColors.red,
                          //isDislike: true,
                        ),
                      ],
                    );
                  }),
                ],
              )
            ],
          ),
          padding8,
          Padding(
            padding: EdgeInsets.all(AppConstants.padding),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.r),
                  width: double.infinity,
                  // width: 341,
                  decoration: commonBoxShadow(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Details',
                        style: getSemiBoldStyle(
                            color: context.titleColor,
                            fontSize: MyFonts.size15),
                      ),
                      SizedBox(
                        width: 280.w,
                        child: Text(
                          widget.couponModel.detail,
                          style: getRegularStyle(
                              color: context.titleColor,
                              fontSize: MyFonts.size13),
                        ),
                      )
                    ],
                  ),
                ),
                padding12,
                Container(
                  padding: EdgeInsets.all(16.r),
                  width: double.infinity,
                  // width: 341,
                  decoration: commonBoxShadow(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Expires',
                        style: getSemiBoldStyle(
                            color: context.titleColor,
                            fontSize: MyFonts.size15),
                      ),
                      Text(
                        // formatDayMonthYear(widget.couponModel.expiryDate) ==
                        //         "29 Mar, 2024"
                        //     ? "Coming Soon"
                        //     :
                        formatDayMonthYear(widget.couponModel.expiryDate),
                        style: getMediumStyle(
                            color: context.titleColor.withOpacity(.5),
                            fontSize: MyFonts.size13),
                      ),
                    ],
                  ),
                ),
                padding12,
                ref.watch(isCouponExistProvider(widget.couponModel.id)).when(
                    data: (couponExist) {
                      return InkWell(
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        onTap: () async {
                          if (!checkUserExist(ref: ref, context: context)) {
                            return;
                          }
                          if (couponExist) {
                            // WalletCouponModel walletCoupon = walletCoupons
                            //     .where(
                            //         (c) => c.couponId == widget.couponModel.id)
                            //     .first;
                            ref.read(couponControllerProvider.notifier)
                                .deleteCouponFromWallet(
                                context: context,
                                couponId: widget.couponModel.id);
                          } else {
                            ref
                                .read(couponControllerProvider.notifier)
                                .addCouponToWallet(
                                context: context,
                                couponModel: widget.couponModel,
                                walletCoupon: WalletCouponModel(
                                    id: Uuid().v4(),
                                    userId: '',
                                    couponId: widget.couponModel.id,
                                    date: DateTime.now()));
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.r),
                          width: double.infinity,
                          decoration: commonBoxShadow(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                couponExist
                                    ? 'Remove from wallet'
                                    : 'Add coupon to wallet',
                                style: getSemiBoldStyle(
                                    color: context.titleColor,
                                    fontSize: MyFonts.size15),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 18.r,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    error: (error, stackTrace) => SizedBox(),
                    loading: () => SizedBox()),
                padding20,
              ],
            ),
          )
        ]),
      ),
    );
  }

  commonBoxShadow(BuildContext context) =>
      BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: context.whiteColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              offset: Offset(0, 0),
              color: context.titleColor.withOpacity(.10),
            ),
          ]);
}

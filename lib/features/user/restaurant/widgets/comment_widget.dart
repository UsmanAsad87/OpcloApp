import 'dart:ui';

import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:uuid/uuid.dart';
import '../../../../commons/common_functions/date_time_format.dart';
import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_functions/show_login.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_widgets/cached_circular_network_image.dart';
import '../../../../models/alert_comment_model/alert_comment_model.dart';
import '../../../../models/alert_model.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/loading.dart';
import '../../../auth/controller/auth_notifier_controller.dart';
import '../../alert/controller/alert_controller.dart';

class CommentWidget extends ConsumerStatefulWidget {
  final AlertModel alert;

  const CommentWidget({super.key, required this.alert});

  @override
  ConsumerState<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends ConsumerState<CommentWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController commentController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _animation;
  int totalComments = 0;
  final ScrollController _commentController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.3).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    ));
  }


  @override
  void dispose() {
    _controller.dispose();
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool userExist = ref
        .watch(authNotifierCtr)
        .userModel != null;
    return Container(
      // width: 320.w,
      height: 400.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: context.whiteColor.withOpacity(.4),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
              blurRadius: 10,
              color: context.whiteColor.withOpacity(.85),
              blurStyle: BlurStyle.inner
          )
        ],
        // color: Colors.transparent,
        //  color: context.whiteColor.withOpacity(.7),
        // borderRadius: BorderRadius.circular(8.r),
        // boxShadow: [
        //   BoxShadow(
        //       blurRadius: 10,
        //       color: context.whiteColor.withOpacity(.85),

        //       blurStyle: BlurStyle.inner
        //   )
        // ],
      ),
      child:
      // ClipRRect(
        // clipBehavior: Clip.antiAlias,
        // borderRadius: BorderRadius.circular(8.r),
        // child:  BackdropFilter(
        //     filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        //     child:
            Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              AppAssets.exclamationMark,
                              width: 24.w,
                              height: 24.h,
                            ),
                            padding8,
                            Text(
                              widget.alert.option.type,
                              style: getSemiBoldStyle(
                                  color: context.titleColor,
                                  fontSize: MyFonts.size16),
                            ),
                          ],
                        ),
                        Consumer(builder: (context, ref, child) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                ref
                                    .watch(
                                    getThumbsUpCountProvider(widget.alert.id))
                                    .when(
                                    data: (count) => count.toString(),
                                    error: (e, s) => '00',
                                    loading: () => '00'),
                                style: getSemiBoldStyle(color: context.titleColor),
                              ),
                              padding4,
                              InkWell(
                                  overlayColor:
                                  WidgetStateProperty.all(Colors.transparent),
                                  onTap: () {
                                    if (userExist) {
                                      ref
                                          .read(alertControllerProvider.notifier)
                                          .addThumbsUp(
                                          context: context,
                                          alertId: widget.alert.id);
                                    } else {
                                      showLogInBottomSheet(context: context);
                                    }
                                  },
                                  child: ScaleTransition(
                                    scale: _animation,
                                    child: SvgPicture.asset(
                                      AppAssets.thumbUpFill,
                                      width: 24.w,
                                      height: 24.h,
                                    ),
                                  )),
                            ],
                          );
                        })
                      ],
                    ),
                  ),
                  Divider(
                    color: context.bodyTextColor,
                    thickness: .5,
                  ),
                  Expanded(
                    child: Consumer(builder: (context, ref, child) {
                      return ref
                          .watch(getAllAlertCommentsProvider(widget.alert.id))
                          .when(
                          data: (comments) {
                            if (totalComments != comments.length) {
                              SchedulerBinding.instance.addPostFrameCallback((_) {
                                _commentController.jumpTo(
                                    _commentController.position.maxScrollExtent);
                              });
                              totalComments == comments.length;
                            }
                            return ListView.builder(
                                itemCount: comments.length,
                                controller: _commentController,
                                shrinkWrap: true,
                                // physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final comment = comments[index];
                                  return Container(
                                    padding: EdgeInsets.all(12.r),
                                    decoration: BoxDecoration(
                                        border: index == 0
                                            ? null
                                            : Border(
                                            top: BorderSide(
                                                color: context.bodyTextColor,
                                                width: .5.sp))),
                                    child: Row(
                                      children: [
                                        CachedCircularNetworkImageWidget(
                                            image: comment.userProfile, size: 55),
                                        padding8,
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                comment.userName,
                                                style: getSemiBoldStyle(
                                                    color: context.titleColor),
                                              ),
                                              Text(
                                                comment.comment,
                                                style: getRegularStyle(
                                                    color: context.titleColor,
                                                    fontSize: MyFonts.size12),
                                              ),
                                              Text(
                                                formatTimeDifference(
                                                    comment.date),
                                                style: getMediumStyle(
                                                    fontSize: MyFonts.size12,
                                                    color: context.bodyTextColor),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          error: (e, s) => SizedBox(),
                          loading: () => LoadingWidget());
                    }),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: context.whiteColor),
                    margin: EdgeInsets.all(12.r),
                    padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 6.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            overlayColor:
                            WidgetStatePropertyAll(Colors.transparent),
                            onTap: () {
                              if (!userExist) {
                                showLogInBottomSheet(context: context);
                              }
                            },
                            child: TextField(
                              controller: commentController,
                              enabled: userExist,
                              decoration: InputDecoration(
                                  hintText: userExist
                                      ? 'Write a public comment'
                                      : 'login to add comment',
                                  hintStyle: getMediumStyle(
                                    color: context.titleColor,
                                    fontSize: MyFonts.size14,
                                  ),
                                  border: InputBorder.none),
                              onChanged: (v) {},
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 12.w),
                          width: 1,
                          height: 30.h,
                          color: context.titleColor.withOpacity(.2),
                        ),
                        Consumer(builder: (context, ref, child) {
                          return InkWell(
                              overlayColor: WidgetStateColor.transparent,
                              onTap: () async {
                                if (commentController.text.isNotEmpty) {
                                  final user = ref
                                      .read(authNotifierCtr)
                                      .userModel;
                                  AlertCommentModel commentModel =
                                  AlertCommentModel(
                                    id: Uuid().v4(),
                                    alertId: widget.alert.id,
                                    userId: user?.uid ?? '',
                                    userName: user?.name ?? '',
                                    userProfile: user?.profileImage ?? '',
                                    comment: commentController.text.trim(),
                                    date: DateTime.now(),
                                  );
                                  ref
                                      .read(alertControllerProvider.notifier)
                                      .addAlertComment(
                                    context: context,
                                    alertCommentModel: commentModel,
                                  );
                                  setState(() {
                                    commentController.text = '';
                                  });
                                  FocusScope.of(context).unfocus();
                                }
                              },
                              child: Image.asset(
                                AppAssets.sendIcon,
                                width: 24.w,
                                height: 24.h,
                              ));
                        }),
                      ],
                    ),
                  ),
                ],
              )),
      //   ),
      // ),
    );
  }
}

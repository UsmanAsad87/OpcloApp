import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../../../models/user_model.dart';
import '../../../../../../utils/constants/font_manager.dart';
import '../../../../../../utils/thems/my_colors.dart';
import '../../../../../../utils/thems/styles_manager.dart';
import '../../../../../auth/controller/auth_notifier_controller.dart';

class NonActive extends ConsumerWidget {
  const NonActive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    UserModel? userModel = ref.watch(authNotifierCtr).userModel;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
      margin: EdgeInsets.only(right: 4.w),
      decoration: BoxDecoration(
        color: userModel!.subscriptionApproved!?MyColors.green:MyColors.pizzaHutColor,
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Text(
        userModel!.subscriptionApproved!?"Active":'Non-active',
        style:
        getMediumStyle(color: context.whiteColor, fontSize: MyFonts.size11),
      ),
    );
  }
}

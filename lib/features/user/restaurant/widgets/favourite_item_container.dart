import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:opclo/commons/common_imports/apis_commons.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/favorites/controller/like_controller.dart';
import '../../../../commons/common_functions/padding.dart';
import '../../../../models/favorite_model.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../../auth/controller/auth_notifier_controller.dart';

class FavouriteItemContainer extends StatelessWidget {
  final String title;
  final String id;
  final String subtitle;
  final bool isSelected;
  final Function() editName;

  const FavouriteItemContainer(
      {Key? key,
      required this.title,
      required this.id,
      required this.subtitle,
      required this.isSelected,
      required this.editName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onLongPress: editName,
                child: Text(title,
                    style: getMediumStyle(
                        color: context.titleColor, fontSize: MyFonts.size14)),
              ),
              Text(subtitle,
                  style: getMediumStyle(
                      color: context.titleColor.withOpacity(.5),
                      fontSize: MyFonts.size11)),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Icon(
                  CupertinoIcons.suit_heart_fill,
                  size: 26.r,
                  color: isSelected
                      ? MyColors.pizzaHutColor
                      : context.titleColor.withOpacity(.23),
                ),
              ),
              padding12,
              Consumer(builder: (context, ref, child) {
                return InkWell(
                  onTap: () async {
                    await ref
                        .read(likeGroupControllerProvider.notifier)
                        .deleteLikeGroup(
                          context: context,
                          groupId: id,
                        );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Icon(
                      CupertinoIcons.delete,
                      size: 26.r,
                      color: context.titleColor.withOpacity(.23),
                    ),
                  ),
                );
              }),
            ],
          )
        ],
      ),
    );
  }
}

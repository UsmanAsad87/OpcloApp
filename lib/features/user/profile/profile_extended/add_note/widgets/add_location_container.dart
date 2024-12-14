import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/profile/profile_extended/add_note/controller/select_location.dart';

import '../../../../../../models/place_model.dart';
import '../../../../../../utils/constants/app_constants.dart';
import '../../../../../../utils/constants/font_manager.dart';
import '../../../../../../utils/thems/my_colors.dart';
import '../../../../../../utils/thems/styles_manager.dart';

class AddLocationContainer extends StatefulWidget {
  final PlaceModel placeModel;

  // final icon;

  const AddLocationContainer({
    super.key,
    required this.placeModel,
  });

  @override
  State<AddLocationContainer> createState() => _AddLocationContainerState();
}

class _AddLocationContainerState extends State<AddLocationContainer> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      margin: EdgeInsets.all(AppConstants.allPadding),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: context.titleColor, width: 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Column(
                children: [
                  Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: MyColors.red.withOpacity(.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: context.whiteColor,
                      )),
                  padding4,
                  Text(
                    '${((widget.placeModel?.distance?.toDouble() ?? 0) *
                        0.000621371).toStringAsFixed(1)} mi',
                  ),
                ],
              ),
              Container(
                width: 240.w,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.placeModel.placeName,
                      overflow: TextOverflow.ellipsis,
                      style: getSemiBoldStyle(
                          color: context.titleColor, fontSize: MyFonts.size15),
                    ),
                    Text(
                      widget.placeModel.locationName,
                      //'4800 Mitchellville Rd, Bowie',
                      overflow: TextOverflow.ellipsis,
                      style: getRegularStyle(
                          color: context.titleColor.withOpacity(.4),
                          fontSize: MyFonts.size11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Consumer(builder: (context, ref, child) {
            return InkWell(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              onTap: () {
                ref
                    .read(selectedLocationProvider)
                    .selectPlace(widget.placeModel);
                // setState(() {
                //   isSelected = !isSelected;
                // });
              },
              child: Icon(
                ref.watch(selectedLocationProvider).selectedPlace ==
                        widget.placeModel
                    ? Icons.check
                    : Icons.add,
                // isSelected ? Icons.check : Icons.add,
                color: context.primaryColor,
                size: 26.r,
              ),
            );
          })
        ],
      ),
    );
  }
}

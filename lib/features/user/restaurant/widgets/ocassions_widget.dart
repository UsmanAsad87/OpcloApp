import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import '../../../../commons/common_enum/occasion_option_enum/occasion_option_enum.dart';
import '../../../../commons/common_enum/occassion_type_enum/occasion_type_enum.dart';
import '../../../../commons/common_functions/get_icon.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/loading.dart';
import '../../alert/alerts_extended/occasions/controller/occasion_controller.dart';
import 'occasion_chip.dart';

class OcassionsWidget extends StatelessWidget {
  const OcassionsWidget({
    super.key,
    required this.fsqId,
  });

  final String fsqId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: AppConstants.horizontalPadding,
            top: 18.h,
            bottom: 6.h,
          ),
          child: Text(
            'Occasions',
            style: getSemiBoldStyle(
                color: context.titleColor, fontSize: MyFonts.size18),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalPadding, vertical: 12.h),
          child: Consumer(builder: (context, ref, child) {
            return ref.watch(getAllOccasionProvider(fsqId)).when(
                data: (occasionList) {
                  return occasionList.length <= 0
                      ? Center(
                          child: Column(
                            children: [
                              Image.asset(
                                AppAssets.noOccasionsIcon,
                                width: 60.w,
                                height: 60.h,
                              ),
                              padding8,
                              Text(
                                'No occasions',
                                style: getBoldStyle(
                                    color: context.titleColor,
                                    fontSize: MyFonts.size12),
                              ),
                              padding4,
                              Text(
                                'This would be great for ...',
                                style: getRegularStyle(
                                    color: context.bodyTextColor,
                                    fontSize: MyFonts.size10),
                              ),
                            ],
                          ),
                        )
                      : Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: occasionList.map((occasion) {
                            return OccasionChip(
                              title: toOccasionTypeString(
                                  type: occasion.occasionType,
                                  option: occasion.option),
                              // title: toOccasionTypeString(type: occasion.occasionType) + ' - ' + occasion.option.type,
                              icon: getIcon(occasion.occasionType.type),
                            );
                          }).toList(),
                        );
                },
                error: (error, stackTrace) => SizedBox(),
                loading: () => LoadingWidget());
          }),
        ),
      ],
    );
  }

  toOccasionTypeString(
      {required OccasionTypeEnum type, required OccasionOptionEnum option}) {
    switch (type) {
      case OccasionTypeEnum.holidays:
        return 'Holiday - ${option.type}';
      case OccasionTypeEnum.birthdays:
        return option == OccasionOptionEnum.himAndHer
            ? 'Birthdays'
            : 'Birthday - ${option.type}';
      case OccasionTypeEnum.anniversaries:
        return option == OccasionOptionEnum.himAndHer
            ? 'Anniversaries'
            : 'Anniversary - ${option.type}';
      case OccasionTypeEnum.weddings:
        return option == OccasionOptionEnum.himAndHer
            ? 'Weddings'
            : 'Wedding - ${option.type}';
      case OccasionTypeEnum.graduations:
        return option == OccasionOptionEnum.himAndHer
            ? 'Graduations'
            : 'Graduation - ${option.type}';
      default:
        return 'Holiday - ${option.type}';
    }
  }
}

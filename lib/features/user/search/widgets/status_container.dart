import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';
import '../controller/filter_notifier_controller.dart';

class StatusContainer extends StatelessWidget {
  const StatusContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final filterRef = ref.watch(filterNotifierCtr);
        return Row(
          children: [
            for (var option in statusOption)
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: FilterChip(
                  label: Text(
                    option.name,
                    style: getMediumStyle(
                        color: filterRef.selectedStatus?.value == option.value
                            ? context.whiteColor
                            : context.primaryColor,
                        fontSize: MyFonts.size11),
                  ),
                  side: BorderSide(color: context.primaryColor),
                  selectedColor: context.primaryColor,
                  disabledColor: context.primaryColor,
                  checkmarkColor: context.whiteColor,
                  selected: filterRef.selectedStatus?.value == option.value,
                  onSelected: (selected) {
                    if (selected) {
                      filterRef.selectStatusOption(option);
                    } else {
                      filterRef.selectStatusOption(null);
                    }
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}


final List<StatusOption> statusOption = [
  StatusOption(name: 'All', value: 'all'),
  StatusOption(name: 'Current open', value: 'true'),
  StatusOption(name: 'Close', value: 'false'),
];

class StatusOption {
  final String name;
  final String value;

  StatusOption({required this.name, required this.value});
}
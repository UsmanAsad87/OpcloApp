
import 'package:opclo/core/extensions/color_extension.dart';

import '../../utils/constants/assets_manager.dart';
import '../../utils/constants/font_manager.dart';
import '../common_imports/common_libs.dart';

class CommonDropDown extends StatelessWidget {
  final String hintText;
  final String label;
  final String? value;
  final List<String> valueItems;
  final Function(String?) onChanged;

  const CommonDropDown({
    Key? key,
    required this.hintText,
    required this.label,
    this.value,
    required this.valueItems,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: EdgeInsets.only(left: 0.0.w, bottom: 5.h),
          //   child: Text(
          //     label,
          //     style: getRegularStyle(
          //         fontSize: MyFonts.size12, color: context.titleColor),
          //   ),
          // ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              margin: EdgeInsets.symmetric(
                vertical: 8.h,
              ),
              decoration: BoxDecoration(
                color: context.containerColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              height: 55.h,
              // padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
              // decoration: BoxDecoration(
              //   color: context.whiteColor,
              //   borderRadius: BorderRadius.circular(8.r),
              //   border: Border.all(
              //       color: context.bodyTextColor.withOpacity(0.4), width: 1.w),
              // ),
              child: DropdownButton(
                  hint: Text(
                    hintText,
                    style: getRegularStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: MyFonts.size12),
                  ),
                  //menuMaxHeight: 250.h,
                  isExpanded: true,
                  menuMaxHeight: 300.h,
                  dropdownColor: context.whiteColor,
                  borderRadius: BorderRadius.circular(20.r),
                  underline: const SizedBox(),
                  icon: Icon(Icons.keyboard_arrow_down_outlined),
                  value: value,
                  focusColor: Colors.blue,
                  style: getRegularStyle(
                      color: context.titleColor, fontSize: MyFonts.size12),
                  onChanged: onChanged,
                  items:
                      valueItems.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                      ),
                    );
                  }).toList())),
        ],
      ),
    );
  }
}

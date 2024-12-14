import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../../commons/common_imports/common_libs.dart';

class CustomRadio extends StatelessWidget {
  final bool isSelected;
  final ValueChanged<bool?>? onChanged;
  final double? size;
  final double? borderWidth;
  final double? padding;

  const CustomRadio(
      {Key? key,
        required this.isSelected,
        required this.onChanged,
        this.size,
        this.borderWidth,
        this.padding
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged?.call(!isSelected);
      },
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      child: Container(
        width: size ?? 24.w,
        height: size ?? 24.h,
        padding: EdgeInsets.all(padding ?? 1.5.r),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // color: isSelected ? MyColors.green : context.whiteColor,
          border: Border.all(
              width: borderWidth ?? 1.5.r,
              color: isSelected
                  ? MyColors.green
                  : context.titleColor.withOpacity(.5)),
        ),
        child: isSelected
            ? Container(
                decoration: BoxDecoration(
                    color: MyColors.green,
                    shape: BoxShape.circle))
            : null,
      ),
    );
  }
}

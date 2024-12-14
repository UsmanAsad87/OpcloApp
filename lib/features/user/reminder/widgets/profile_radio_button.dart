import 'package:opclo/core/extensions/color_extension.dart';
import '../../../../../commons/common_imports/common_libs.dart';

class ProfileRadioButton extends StatelessWidget {
  final bool isSelected;
  final ValueChanged<bool?>? onChanged;
  final double? size;
  final double? borderWidth;
  final double? padding;

  const ProfileRadioButton(
      {Key? key,
      required this.isSelected,
      required this.onChanged,
      this.size,
      this.borderWidth,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        onChanged?.call(!isSelected);
      },
      child: Container(
        width: size ?? 24.w,
        height: size ?? 24.h,
       // padding: EdgeInsets.all(padding ?? 1.5.r),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // color: isSelected ? MyColors.green : context.whiteColor,
          border: Border.all(
              width: borderWidth ?? 1.5.r,
              color: isSelected
                  ? MyColors.profileRdioColor
                  : context.titleColor.withOpacity(.5)),
        ),
        child: isSelected
            ? Container(
                decoration: BoxDecoration(
                    color: MyColors.profileRdioColor,
                    shape: BoxShape.circle),
                child: Center(
                  child: Icon(
                    Icons.check,
                    color: context.whiteColor,
                    size: 16.r,
                    weight: 6000,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

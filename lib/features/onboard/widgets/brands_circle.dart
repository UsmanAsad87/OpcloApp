import 'package:opclo/core/extensions/color_extension.dart';

import '../../../commons/common_imports/common_libs.dart';

class BrandCircle extends StatelessWidget {
  double? top;
  double? bottom;
  double? left;
  double? right;
  final imagePath;
  BrandCircle({
    Key? key,
    required this.imagePath,
    this.top,
    this.bottom,
    this.right,
    this.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      top: top,
      left: left,
      right: right,
      child: Container(
        padding: EdgeInsets.all(12.r),
        // width: 80.w,
        // height: 80.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 13.r,
              offset: Offset(0, 6),
            ),
          ]
        ),
        child: Image.asset(imagePath,width: 70,height: 70,),
      ),
    );
  }
}

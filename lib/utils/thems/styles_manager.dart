import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opclo/commons/common_imports/apis_commons.dart';

import '../constants/font_manager.dart';
import 'my_colors.dart';

TextStyle _getTextStyle(
  double fontSize,
  FontWeight fontWeight,
  Color color, [ bool? isUnderLine]
) {
  return GoogleFonts.poppins(
    color: color,
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    decoration: isUnderLine ?? false ? TextDecoration.underline : TextDecoration.none,
    decorationColor: MyColors.green,
  );
}

TextStyle _getLobsterTextStyle(
    double fontSize,
    FontWeight fontWeight,
    Color color, [ bool? isUnderLine]
    ) {
  return GoogleFonts.lobster(
    color: color,
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    decoration: isUnderLine ?? false ? TextDecoration.underline : TextDecoration.none,
    decorationColor: MyColors.green,
  );
}

// regular style
TextStyle getRegularStyle({
  double fontSize = 16,
  required Color color
}) {
  return _getTextStyle(fontSize.sp, FontWeightManager.regular, color);
}

// medium style
TextStyle getMediumStyle({
  double fontSize = 16,
  required Color color
}) {
  return _getTextStyle(fontSize.sp, FontWeightManager.medium, color);
}

// medium style
TextStyle getLightStyle({
  double fontSize = 14,
  required Color color
}) {
  return _getTextStyle(fontSize.sp, FontWeightManager.light, color);
}

// bold style
TextStyle getBoldStyle({
  double fontSize = 14,
  required Color color,
  bool? isUnderLine
}) {
  return _getTextStyle(fontSize.sp, FontWeightManager.bold, color,isUnderLine);
}


// bold style
TextStyle getLobsterBoldStyle({
  double fontSize = 14,
  required Color color,
  bool? isUnderLine
}) {
  return _getLobsterTextStyle(fontSize.sp, FontWeightManager.bold, color,isUnderLine);
}

// semibold style
TextStyle getSemiBoldStyle({
  double fontSize = 14,
  required Color color
}) {
  return _getTextStyle(fontSize.sp, FontWeightManager.semiBold, color);
}

// bold style
TextStyle getExtraBoldStyle({
  double fontSize = 14,
  required Color color
}) {
  return _getTextStyle(fontSize.sp, FontWeightManager.extraBold, color);
}

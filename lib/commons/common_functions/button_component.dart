import 'package:flutter/material.dart';

import '../../utils/thems/my_colors.dart';


class ButtonComponent extends StatelessWidget {
  final String? text;
  final Function()? onPressed;
  final double height;
  final double maxWidth;
  final Color backgroundColor;
  final Color color;
  final Color? borderColor;
  final Widget? replceTextWithWidget;
  final bool showBorder;
  final FontWeight fontWeight;
  final double fontSize;
  final double horizontalPadding;
  final double borderRadius;

  const ButtonComponent({
    Key? key,
    this.text,
    required this.onPressed,
    this.height = 46,
    this.maxWidth = double.infinity,
    this.borderRadius = 10.0,
    this.replceTextWithWidget,
    this.showBorder = false,
    this.fontSize = 16,
    this.horizontalPadding = 0,
    this.fontWeight = FontWeight.bold,
    this.backgroundColor = MyColors.lightThemeColor,
    this.borderColor,
    this.color = Colors.white,
  })  : assert(text != null || replceTextWithWidget != null,
            "Both text and replceTextWithWidget fields can't be null"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius - 2),
          border: showBorder ? Border.all(color: borderColor ?? color) : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: MaterialButton(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            highlightColor: Colors.transparent,
            color: backgroundColor,
            onPressed: onPressed,
            elevation: 0,
            child: replceTextWithWidget ??
                Text(
                  text ?? '',
                  style: TextStyle(
                      color: color,
                      fontSize: fontSize,
                      height: 1.3,
                      letterSpacing: 0.5,
                      fontWeight: fontWeight),
                  textAlign: TextAlign.center,
                ),
          ),
        ),
      ),
    );
  }
}

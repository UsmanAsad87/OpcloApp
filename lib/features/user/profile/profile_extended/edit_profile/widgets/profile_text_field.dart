import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../../../utils/constants/font_manager.dart';
import '../../../../../../utils/thems/styles_manager.dart';

class ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final int? maxline;
  final bool? enabled;

  final String? Function(String?)? validator;

  const ProfileTextField(
      {Key? key,
      required this.controller,
      required this.title,
        this.enabled,
      this.maxline,
      this.validator,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: getMediumStyle(
                  color: context.titleColor.withOpacity(.5),
                  fontSize: MyFonts.size13),
            ),
            SizedBox(
              width: 190.w,
              child: TextFormField(
                textAlign: TextAlign.end,
                controller: controller,
                enabled: enabled,
                maxLines: maxline ?? null,
                validator: validator,
                decoration: InputDecoration(
                  hintText: title,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 0.w,
                    vertical: 12.h,
                  ),
                  errorStyle: getRegularStyle(
                      fontSize: MyFonts.size10,
                      color: Theme.of(context).colorScheme.error),
                  hintStyle: getMediumStyle(
                      fontSize: MyFonts.size13,
                      color: context.titleColor.withOpacity(.5)),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  focusedErrorBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(
          color: context.titleColor.withOpacity(.2),
        ),
      ],
    );
  }
}
class ProfileAddressField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String address;
  final int? maxline;
  final bool? enabled;

  final String? Function(String?)? validator;

  const ProfileAddressField(
      {Key? key,
        required this.controller,
        required this.title,
        this.enabled,
        this.maxline,
        this.validator, required this.address,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: getMediumStyle(
                  color: context.titleColor.withOpacity(.5),
                  fontSize: MyFonts.size13),
            ),
            Container(
              width: 190.w,
              child:  Text(
                address,
                textAlign: TextAlign.right,
                style: getMediumStyle(
                    color: context.titleColor.withOpacity(.5),
                    fontSize: MyFonts.size14),
              ),
            ),
          ],
        ),
        Divider(
          color: context.titleColor.withOpacity(.2),
        ),
      ],
    );
  }
}

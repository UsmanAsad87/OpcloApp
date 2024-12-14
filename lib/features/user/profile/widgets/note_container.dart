import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/profile/profile_extended/add_note/views/add_location.dart';
import '../../../../models/note_model.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';
import '../profile_extended/add_note/views/note_detail.dart';

class NoteContainer extends StatelessWidget {
  final color;
  final NoteModel note;

  // final title;
  // final listItem;
  const NoteContainer(
      {Key? key,  required this.color, required this.note
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        showModalBottomSheet(
            context: context,
            enableDrag: true,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) {
              return NoteDetail(note: note,);
            });
      },
      child: Container(
        // width: 164.w,
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: getSemiBoldStyle(color: context.whiteColor),
              ),
              ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: note.itemList.length >= 3 ? 2 : note.itemList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    String item = note.itemList[index];
                    return Text(
                      '$item',
                      style: getRegularStyle(
                          color: context.whiteColor, fontSize: MyFonts.size12),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

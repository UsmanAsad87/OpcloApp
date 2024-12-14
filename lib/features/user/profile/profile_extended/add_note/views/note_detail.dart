import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_widgets/custom_button.dart';
import 'package:opclo/commons/common_widgets/custom_outline_button.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/profile/profile_extended/add_note/controller/note_controller.dart';
import 'package:opclo/models/note_model.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../../commons/common_imports/common_libs.dart';
import '../../../../../../models/place_model.dart';
import '../../../../../auth/view/signup_screen.dart';

class NoteDetail extends StatelessWidget {
  final NoteModel note;

  const NoteDetail({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 500.h,
          decoration: BoxDecoration(
            color: context.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 69.w,
                height: 6.h,
                margin: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                    color: context.titleColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(50.r)),
              ),
              Stack(
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundImage: AssetImage(
                        AppAssets.mapImage,
                      ),
                      radius: 42.r,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      onTap: (){
                        final noteText = buildNoteText(note: note);
                        Share.share(noteText);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(12.r),
                        child: Icon(
                          Icons.file_upload_outlined,
                          color: context.titleColor,
                          size: 32.r,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              padding16,
              InkWell(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                onTap: (){
                  Navigator.pushNamed(context, AppRoutes.placeDetailUsingIdScreen,
                      arguments: {'placeId': note.placeId});
                },
                child:   Text(
                  note.placeName ?? '',
                  textAlign: TextAlign.center,
                  style: getSemiBoldStyle(
                      color: context.primaryColor, fontSize: MyFonts.size18),
                ),
              ),
              padding4,
              Text(
                note.locationName ?? '',
                textAlign: TextAlign.center,
                style: getMediumStyle(
                    color: context.titleColor.withOpacity(.5.r),
                    fontSize: MyFonts.size13),
              ),
              Padding(
                padding: EdgeInsets.all(12.r),
                child: Divider(
                  color: context.titleColor.withOpacity(.2.r),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.allPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: getSemiBoldStyle(
                              color: context.titleColor,
                              fontSize: MyFonts.size14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: AppConstants.horizontalPadding),
                  child: ListView.builder(
                      itemCount: note.itemList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        String item = note.itemList[index];
                        return Text(
                          item,
                          style: getRegularStyle(
                              color: context.bodyTextColor,
                              fontSize: MyFonts.size12),
                        );
                      }),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.r),
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: CustomOutlineButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushNamed(
                                context, AppRoutes.addNoteScreen,
                                arguments: {'noteModel': note});
                          },
                          buttonText: 'Edit'),
                    )),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Consumer(builder: (context, ref, child) {
                        return CustomButton(
                            onPressed: () {
                              ref.read(noteControllerProvider.notifier)
                                  .deleteNote(context, note.id);
                            },
                            isLoading: ref.watch(noteControllerProvider),
                            buttonText: 'Delete');
                      }),
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  String buildNoteText({required NoteModel note}) {
    final buffer = StringBuffer();
    buffer.writeln(note.placeName == null ? '' : 'placeName: ${note.placeName}');
    buffer.writeln('Title: ${note.title}');
    buffer.writeln('Items:');
    for (var item in note.itemList) {
      buffer.writeln(item);
    }
    return buffer.toString();
  }
}

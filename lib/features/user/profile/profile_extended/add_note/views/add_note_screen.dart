import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_functions/date_time_format.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_widgets/show_toast.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
import 'package:opclo/features/user/profile/profile_extended/add_note/controller/note_controller.dart';
import 'package:opclo/features/user/profile/profile_extended/add_note/controller/select_location.dart';
import 'package:opclo/features/user/profile/profile_extended/add_note/views/add_location.dart';
import 'package:opclo/models/note_model.dart';
import 'package:opclo/models/place_model.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import 'package:uuid/uuid.dart';
import '../../../../../../commons/common_imports/common_libs.dart';
import '../../../../../../routes/route_manager.dart';
import '../../../../../../utils/constants/assets_manager.dart';

class AddNoteScreen extends ConsumerStatefulWidget {
  final PlaceModel? place;
  final NoteModel? noteModel;

  AddNoteScreen({super.key, this.noteModel, this.place});

  @override
  ConsumerState<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends ConsumerState<AddNoteScreen> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  bool isChecked = false;
  PlaceModel? selectedPlace;
  NoteModel? oldNote;

  @override
  void initState() {
    if (widget.place != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        ref.read(selectedLocationProvider).selectPlace(widget.place);
      });
    }
    oldNote = widget.noteModel;
    if (oldNote != null) {
      titleController.text = oldNote!.title;
      descController.text = oldNote!.itemList.join(', ');
      isChecked = oldNote!.rememberMe;
      PlaceModel place = PlaceModel(
          fsqId: '',
          locationName: oldNote!.locationName ?? '',
          placeName: oldNote!.placeName ?? '',
          lat: oldNote!.lat ?? 0,
          lon: oldNote!.long ?? 0,
          isOpen: false,
          categories: []);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        ref.read(selectedLocationProvider).selectPlace(place);
      });
    }
    setState(() {});
    super.initState();
  }

  void _showSheet(context) {
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return AddLocation(
            isQuickAccess: false,
          );
        });
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  save() {

    if (isChecked && selectedPlace == null) {
      showSnackBar(context, 'Please select location');
      return;
    }
    if (titleController.text.trim() == '') {
      showSnackBar(context, 'title is empty');
      return;
    }
    if (descController.text.trim() == '') {
      showSnackBar(context, 'details is empty');
      return;
    }
    ref.read(noteControllerProvider.notifier).addNote(
        context,
        NoteModel(
            id: Uuid().v4(),
            title: titleController.text,
            itemList: descController.text.split(','),
            rememberMe: isChecked,
            createdAt: DateTime.now(),
            placeName: selectedPlace?.placeName,
            lat: selectedPlace?.lat.toDouble(),
            placeId: selectedPlace?.fsqId,
            long: selectedPlace?.lon.toDouble(),
            locationName: selectedPlace?.locationName,
            userId: ref.watch(authNotifierCtr).userModel!.uid,
            updatedAt: DateTime.now()));
  }

  update() {
    if (isChecked && selectedPlace == null) {
      showSnackBar(context, 'Please select location');
      return;
    }
    if (titleController.text.trim() == '') {
      showSnackBar(context, 'title is empty');
      return;
    }
    if (descController.text.trim() == '') {
      showSnackBar(context, 'details is empty');
      return;
    }
    ref.read(noteControllerProvider.notifier).updateNotes(
        context,
        NoteModel(
            id: oldNote!.id,
            title: titleController.text,
            itemList: descController.text.split(','),
            rememberMe: isChecked,
            createdAt: oldNote!.createdAt,
            placeName: selectedPlace?.placeName ?? '',
            lat: selectedPlace!.lat.toDouble(),
            long: selectedPlace!.lon.toDouble(),
            placeId: selectedPlace!.fsqId,
            locationName: selectedPlace?.locationName ?? '',
            userId: ref.watch(authNotifierCtr).userModel!.uid,
            updatedAt: DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    selectedPlace = ref.watch(selectedLocationProvider).selectedPlace;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        key: scaffoldState,
        backgroundColor: context.whiteColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          splashColor: Colors.transparent,
                          icon: const Icon(Icons.arrow_back_ios_new_outlined),
                        ),
                        Text(
                          'Add Note',
                          style: getSemiBoldStyle(
                            fontSize: MyFonts.size18,
                            color: context.titleColor,
                          ),
                        ),
                        TextButton.icon(
                            onPressed: oldNote == null ? save : update,
                            icon: Icon(
                              Icons.file_upload_outlined,
                              weight: 500.r,
                            ),
                            label: Text(
                              oldNote == null ? 'Save' : 'Update',
                              style: getSemiBoldStyle(
                                  color: context.primaryColor,
                                  fontSize: MyFonts.size12),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(AppConstants.allPadding),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: GestureDetector(
                              onTap: () {
                                _showSheet(context);
                              },
                              child:selectedPlace==null ?Container(
                                padding: EdgeInsets.all(12.r),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: context.titleColor
                                            .withOpacity(.8))),
                                child: Icon(
                                  Icons.add_rounded,
                                  size: 50,
                                  color: context.titleColor,
                                ) ,
                              ):     Center(
                            child: CircleAvatar(
                            backgroundImage: AssetImage(
                              AppAssets.mapImage,
                            ),
                        radius: 42.r,
                      ),
                    ),
                            ),
                          ),
                          padding16,
                          InkWell(
                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                            onTap: (){
                              Navigator.pushNamed(context, AppRoutes.placeDetailUsingIdScreen,
                                  arguments: {'placeId': selectedPlace?.fsqId});
                            },
                            child: Text(
                              selectedPlace?.placeName ?? '',
                              style: getSemiBoldStyle(
                                  color: context.primaryColor,
                                  fontSize: MyFonts.size16),
                            ),
                          ),
                          padding8,
                          Text(
                            selectedPlace?.locationName ?? '',
                            // 'Bowie, MD 63110',
                            textAlign: TextAlign.center,
                            style: getRegularStyle(
                                color: context.titleColor,
                                fontSize: MyFonts.size14),
                          ),
                          padding8,
                          Text(
                            oldNote != null
                                ? '${notesDate(oldNote!.createdAt)} at ${notesTime(oldNote!.createdAt)}'
                                : '${notesDate(DateTime.now())} at ${notesTime(DateTime.now())}',
                            style: getRegularStyle(
                                color: context.titleColor.withOpacity(.5),
                                fontSize: MyFonts.size14),
                          ),
                          padding24,
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            margin: EdgeInsets.symmetric(
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: context.containerColor,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                hintText: 'Title',
                                hintStyle: getRegularStyle(
                                    color: context.titleColor.withOpacity(.5),
                                    fontSize: MyFonts.size15),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            margin: EdgeInsets.symmetric(
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: context.containerColor,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: TextField(
                              maxLines: 8,
                              controller: descController,
                              decoration: InputDecoration(
                                  helperMaxLines: 2,
                                  hintMaxLines: 2,
                                  hintText:
                                      'Create grocery lists, shopping lists, or write down directions…',
                                  hintStyle: getRegularStyle(
                                      color: context.titleColor.withOpacity(.5),
                                      fontSize: MyFonts.size14),
                                  border: InputBorder.none),
                            ),
                          ),
                          padding16,
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isChecked = !isChecked;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4.0.r),
                                  decoration: BoxDecoration(
                                    color: isChecked
                                        ? MyColors.green
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4.0.r),
                                    border: Border.all(
                                      color: MyColors.green,
                                      width: 1.w,
                                    ),
                                  ),
                                  child: isChecked
                                      ? Icon(
                                          Icons.check,
                                          size: 13.0.sp,
                                          color: Colors.white,
                                        )
                                      : Container(
                                          width: 13.w,
                                          height: 13.h,
                                        ),
                                ),
                              ),
                              // Container(
                              //     padding: EdgeInsets.all(4.r),
                              //     decoration: BoxDecoration(
                              //       color: MyColors.green,
                              //       borderRadius: BorderRadius.circular(4.r),
                              //     ),
                              //     child: Icon(
                              //       Icons.check,
                              //       size: 15.r,
                              //       color: context.whiteColor,
                              //     )),
                              padding8,
                              Text(
                                'Remind me at Location',
                                style: getRegularStyle(
                                    color: context.titleColor,
                                    fontSize: MyFonts.size14),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (ref.watch(noteControllerProvider))
              Container(
                color: context.titleColor.withOpacity(.2),
                child: Center(
                  child: CircularProgressIndicator(
                    color: context.primaryColor,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

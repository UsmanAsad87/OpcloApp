import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../../../commons/common_imports/common_libs.dart';
import '../../../../../../commons/common_widgets/cached_circular_network_image.dart';
import '../../../../../../utils/constants/assets_manager.dart';


class EditProfileImageWidget extends StatefulWidget {
  final String userImage;
  final Function(String imgPath) imgPath;
  final String name;
  const EditProfileImageWidget({
    super.key, required this.userImage, required this.imgPath, required this.name,
  });

  @override
  State<EditProfileImageWidget> createState() => _EditProfileImageWidgetState();
}

class _EditProfileImageWidgetState extends State<EditProfileImageWidget> {
  File? imageFile;
  getPhoto() async {
    XFile? imgFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imgFile != null) {
      // File? img =
      // await cropImage(imageFile: File(imgFile.path), context: context);
      // if (img != null) {
        setState(() {
          imageFile = File(imgFile.path);
        });
        widget.imgPath(imageFile!.path);
      // }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 52.r,
            backgroundColor: context.whiteColor,
            child: CircleAvatar(
              radius: 61.5.r,
              backgroundColor: context.buttonColor,
              backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
              child: imageFile == null
                  ? CachedCircularNetworkImageWidget(
                  image: widget.userImage, size: 120,name: widget.name,)
                  : null,
            ),
          ),
          Positioned(
              right: 0,
              bottom: -8.h,
              child: InkWell(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                onTap: getPhoto,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 3.r, color: context.whiteColor),

                  ),
                  child: CircleAvatar(
                      radius: 16.r,
                      backgroundColor: context.primaryColor,
                      child: Image.asset(
                        AppAssets.cameraIcon,
                        width: 16.w,
                        height: 16.h,
                        color: context.buttonColor,
                      )),
                ),
              ))
        ],
      ),
    );
  }
}

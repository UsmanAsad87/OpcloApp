import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opclo/commons/common_enum/banner_type.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_widgets/CustomTextFields.dart';
import 'package:opclo/commons/common_widgets/custom_button.dart';
import 'package:opclo/commons/common_widgets/custom_outline_button.dart';
import 'package:opclo/commons/common_widgets/show_toast.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/home/home_extended/carousel/controller/carousel_controller.dart';
import 'package:opclo/models/crousel_model.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../utils/constants/assets_manager.dart';
import 'package:path_provider/path_provider.dart';

class AddCarouselScreen extends StatefulWidget {
  const AddCarouselScreen({Key? key}) : super(key: key);

  @override
  State<AddCarouselScreen> createState() => _AddCarouselScreenState();
}

class _AddCarouselScreenState extends State<AddCarouselScreen> {
  File? imageFile;
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController articleTitleController = TextEditingController();
  TextEditingController articleDescController = TextEditingController();
  TextEditingController buttonTextController = TextEditingController();

  double redValue = 0.0;
  double greenValue = 0.0;
  double blueValue = 0.0;
  Color? selectedColor1;
  Color? selectedColor2;

  getPhoto() async {
    XFile? imgFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imgFile != null) {
      setState(() {
        imageFile = File(imgFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.padding),
          child: Column(
            children: [
              InkWell(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                onTap: getPhoto,
                child: Container(
                  height: 200.h,
                  width: 300.w,
                  padding: EdgeInsets.all(30.r),
                  margin: EdgeInsets.all(30.r),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border:
                          Border.all(width: 2.r, color: context.primaryColor),
                      image: imageFile != null
                          ? DecorationImage(image: FileImage(imageFile!))
                          : null),
                  child: Container(
                    width: 30.w,
                    height: 30.h,
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
                ),
              ),
              CustomTextField(
                  controller: titleController,
                  hintText: 'Header',
                  onChanged: (value) {},
                  onFieldSubmitted: (value) {},
                  obscure: false),
              CustomTextField(
                  controller: descController,
                  hintText: 'Short description',
                  onChanged: (value) {},
                  onFieldSubmitted: (value) {},
                  obscure: false),
              CustomTextField(
                  controller: articleTitleController,
                  hintText: 'article title',
                  onChanged: (value) {},
                  onFieldSubmitted: (value) {},
                  obscure: false),
              CustomTextField(
                  controller: articleDescController,
                  hintText: 'article description',
                  onChanged: (value) {},
                  onFieldSubmitted: (value) {},
                  obscure: false),
              // CustomTextField(
              //     controller: buttonTextController,
              //     hintText: 'article description',
              //     onChanged: (value) {},
              //     onFieldSubmitted: (value) {},
              //     obscure: false),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  children: [
                    Expanded(
                      child: GradientColorPicker(
                        name: 'Color 1',
                        onColorChanged: (color) {
                          selectedColor1 = color;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: GradientColorPicker(
                        name: 'Color 2',
                        onColorChanged: (color) {
                          selectedColor2 = color;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomOutlineButton(
                        onPressed: () {},
                        buttonText: 'Cancel'),
                  ),
                  padding8,
                  Expanded(
                    child: Consumer(builder: (context, ref, child) {
                      return CustomButton(
                          onPressed: () async {
                            if (imageFile == null &&
                                titleController.text.isEmpty &&
                                selectedColor1 != null &&
                                selectedColor2 != null &&
                                descController.text.isEmpty) {
                              showSnackBar(
                                  context, 'fill all fields and select image');
                              return;
                            }
                            // CarouselModel model = CarouselModel(
                            //   id: Uuid().v4(),
                            //   header: titleController.text,
                            //   image: imagesPath,
                            //   shortDesc: descController.text,
                            //   articleTitle: articleTitleController.text,
                            //   articleDesc: articleDescController.text,
                            //   color1: selectedColor1!,
                            //   color2: selectedColor2!,
                            //   bannerType: BannerTypeEnum.home,
                            //   clickable: false,
                            //   buttonText: buttonTextController.text,
                            // );
                            // ref
                            //     .read(carouselControllerProvider.notifier)
                            //     .addCarousel(
                            //         context: context,
                            //         model: model,
                            //         profileImage: imageFile?.path);

                            final image = await convertAssetImageToFile(
                                AssetImage('assets/images/browse.png'));
                            // CarouselModel model = CarouselModel(
                            //     id: Uuid().v4(),
                            //     header: 'What’s New',
                            //     image: '',
                            //     shortDesc: 'Browse New Places',
                            //     articleTitle: '',
                            //     articleDesc: '',
                            //     color1: Color(0xffffffff),
                            //     color2: Color(0xffffffff),
                            //     bannerType: BannerTypeEnum.explore,
                            //     clickable: true,
                            //     buttonText: 'Advertise');
                            // ref
                            //     .read(carouselControllerProvider.notifier)
                            //     .addCarousel(
                            //         context: context,
                            //         model: model,
                            //         profileImage: image!.path);
                          },
                          isLoading: ref.watch(carouselControllerProvider),
                          buttonText: 'Save');
                    }),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<XFile?> convertAssetImageToFile(AssetImage assetImage) async {
    String assetPath = assetImage.assetName!;
    ByteData? byteData;
    try {
      byteData = await rootBundle.load(assetPath);
    } catch (e) {
      debugPrint("Error loading asset: $e");
      return null;
    }
    List<int> imageData = byteData.buffer.asUint8List();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File imageFile = File('$tempPath/${assetPath.split('/').last}');
    await imageFile.writeAsBytes(imageData);
    return XFile(imageFile.path);
  }
}

class GradientColorPicker extends StatefulWidget {
  final ValueChanged<Color> onColorChanged;
  final String name;

  const GradientColorPicker(
      {Key? key, required this.onColorChanged, required this.name})
      : super(key: key);

  @override
  _GradientColorPickerState createState() => _GradientColorPickerState();
}

class _GradientColorPickerState extends State<GradientColorPicker> {
  double _selectedValue = 0.5; // Initialize with the mid value
  // double _minValue = 0.0;
  // double _maxValue = 1.0;
  Color _selectedColor =
      Colors.transparent; // Initialize with transparent color

  Color _getColorFromGradient(double value) {
    // Define the gradient colors
    List<Color> colors = [
      Colors.red,
      Colors.yellow,
      Colors.green,
      Colors.blue,
    ];
    value = value.clamp(0.0, 1.0);
    double fraction = value * (colors.length - 1);
    int segment = fraction.floor();
    double subFraction = fraction - segment;
    if (segment >= colors.length - 1) {
      segment = colors.length - 2;
      subFraction = 1.0;
    } else if (segment < 0) {
      segment = 0;
      subFraction = 0.0;
    }
    Color color1 = colors[segment];
    Color color2 = colors[segment + 1];
    return Color.lerp(color1, color2, subFraction)!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              double newValue =
                  (details.localPosition.dx / MediaQuery.of(context).size.width)
                      .clamp(0.0, 1.0);
              _selectedValue = newValue;
              _selectedColor = _getColorFromGradient(newValue);
              widget.onColorChanged(_selectedColor);
            });
          },
          child: Container(
            width: double.infinity,
            height: 20.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.r),
              gradient: LinearGradient(
                colors: [
                  Colors.red,
                  Colors.yellow,
                  Colors.green,
                  Colors.blue,
                ],
              ),
            ),
            child: CustomPaint(
              painter: IndicatorPainter(position: _selectedValue),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          widget.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5.h),
        Container(
          width: 50.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: _selectedColor,
            border: Border.all(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class IndicatorPainter extends CustomPainter {
  final double position;

  IndicatorPainter({required this.position});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.black;
    canvas.drawCircle(
        Offset(size.width * position, size.height / 2), 10, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

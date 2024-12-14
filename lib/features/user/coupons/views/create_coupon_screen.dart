// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:opclo/commons/common_enum/coupons_category_enum/coupon_category.dart';
// import 'package:opclo/core/extensions/color_extension.dart';
// import 'package:opclo/features/user/coupons/controller/coupon_controller.dart';
// import 'package:opclo/models/coupon_model.dart';
// import 'package:uuid/uuid.dart';
//
// import '../../../../commons/common_functions/padding.dart';
// import '../../../../commons/common_widgets/common_dropdown.dart';
// import '../../../../commons/common_widgets/show_toast.dart';
// import '../../../../utils/constants/app_constants.dart';
// import '../../../../utils/constants/assets_manager.dart';
// import '../../../../utils/constants/font_manager.dart';
// import '../../../../utils/thems/my_colors.dart';
// import '../../../../utils/thems/styles_manager.dart';
//
// class CreateCouponScreen extends ConsumerStatefulWidget {
//   const CreateCouponScreen({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState<CreateCouponScreen> createState() => _CreateCouponScreenState();
// }
//
// class _CreateCouponScreenState extends ConsumerState<CreateCouponScreen> {
//   TextEditingController shortDesController = TextEditingController();
//   TextEditingController detailController = TextEditingController();
//   TextEditingController saleController = TextEditingController();
//   TextEditingController createCouponController = TextEditingController();
//   TextEditingController expireCouponController = TextEditingController();
//   TextEditingController nameController = TextEditingController();
//   final _formKeyCC = GlobalKey<FormState>();
//   final _formKeyEC = GlobalKey<FormState>();
//   DateTime? startDate;
//   DateTime? expireDate;
//   String? selectedOption;
//   CouponCategory? selectedCategory;
//
//   File? imageFile;
//
//   @override
//   void dispose() {
//     shortDesController.dispose();
//     detailController.dispose();
//     saleController.dispose();
//     createCouponController.dispose();
//     expireCouponController.dispose();
//     nameController.dispose();
//     super.dispose();
//   }
//
//   getPhoto() async {
//     XFile? imgFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (imgFile != null) {
//       setState(() {
//         imageFile = File(imgFile.path);
//       });
//     }
//   }
//
//   save() {
//     if (shortDesController.text.trim() == '') {
//       showSnackBar(context, 'short description is empty');
//       return;
//     }
//     if (nameController.text.trim() == '') {
//       showSnackBar(context, 'name is empty');
//       return;
//     }
//     if (imageFile == null) {
//       showSnackBar(context, 'upload image');
//       return;
//     }
//     if (detailController.text.trim() == '') {
//       showSnackBar(context, 'detail is empty');
//       return;
//     }
//     if (saleController.text.trim() == '') {
//       showSnackBar(context, 'sale is empty');
//       return;
//     }
//     if (selectedCategory == null) {
//       showSnackBar(context, 'selected Category is empty');
//       return;
//     }
//     if (selectedOption == null) {
//       showSnackBar(context, 'selected option is empty');
//       return;
//     }
//     // ref.read(couponControllerProvider.notifier).addCoupon(
//     //     context: context,
//     //     couponModel: CouponModel(
//     //         id: Uuid().v4(),
//     //         placeName: nameController.text,
//     //         detail: detailController.text,
//     //         shortDescription: shortDesController.text,
//     //         couponCategory: selectedCategory!,
//     //         sale: int.parse(saleController.text),
//     //         logo: imageFile!.path,
//     //         inStore: selectedOption == 'inStore' ? true : false,
//     //         createdAt: startDate!,
//     //         expiryDate: expireDate!));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
//       child: Scaffold(
//         backgroundColor: context.whiteColor,
//         body: Stack(
//           children: [
//             SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SafeArea(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           splashColor: Colors.transparent,
//                           icon: const Icon(Icons.arrow_back_ios_new_outlined),
//                         ),
//                         Text(
//                           'Add Coupon',
//                           style: getSemiBoldStyle(
//                             fontSize: MyFonts.size18,
//                             color: context.titleColor,
//                           ),
//                         ),
//                         TextButton.icon(
//                             onPressed: save,
//                             icon: Icon(
//                               Icons.file_upload_outlined,
//                               weight: 500.r,
//                             ),
//                             label: Text(
//                               'Save',
//                               style: getSemiBoldStyle(
//                                   color: context.primaryColor,
//                                   fontSize: MyFonts.size12),
//                             )),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(AppConstants.allPadding),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           InkWell(
//                             onTap: getPhoto,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 border: Border.all(
//                                     width: 3.r, color: context.whiteColor),
//                               ),
//                               child: CircleAvatar(
//                                   radius: 45.r,
//                                   backgroundColor: context.primaryColor,
//                                   child: imageFile != null
//                                       ? Container(
//                                           width: 180.w,
//                                           height: 180.h,
//                                           decoration: BoxDecoration(
//                                               color: context.containerColor,
//                                               borderRadius:
//                                                   BorderRadius.circular(10.r),
//                                               image: DecorationImage(
//                                                   image: FileImage(
//                                                     imageFile!,
//                                                   ),
//                                                   fit: BoxFit.fill)),
//                                         )
//                                       : Image.asset(
//                                           AppAssets.cameraIcon,
//                                           width: 26.w,
//                                           height: 26.h,
//                                           color: context.buttonColor,
//                                         )),
//                             ),
//                           ),
//                           padding16,
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 12.w),
//                             margin: EdgeInsets.symmetric(
//                               vertical: 8.h,
//                             ),
//                             decoration: BoxDecoration(
//                               color: context.containerColor,
//                               borderRadius: BorderRadius.circular(12.r),
//                             ),
//                             child: TextField(
//                               controller: nameController,
//                               decoration: InputDecoration(
//                                 hintText: 'Place Name',
//                                 hintStyle: getRegularStyle(
//                                     color: context.titleColor.withOpacity(.5),
//                                     fontSize: MyFonts.size15),
//                                 border: InputBorder.none,
//                               ),
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 12.w),
//                             margin: EdgeInsets.symmetric(
//                               vertical: 8.h,
//                             ),
//                             decoration: BoxDecoration(
//                               color: context.containerColor,
//                               borderRadius: BorderRadius.circular(12.r),
//                             ),
//                             child: TextField(
//                               controller: shortDesController,
//                               decoration: InputDecoration(
//                                 hintText: 'Short description',
//                                 hintStyle: getRegularStyle(
//                                     color: context.titleColor.withOpacity(.5),
//                                     fontSize: MyFonts.size15),
//                                 border: InputBorder.none,
//                               ),
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 12.w),
//                             margin: EdgeInsets.symmetric(
//                               vertical: 8.h,
//                             ),
//                             decoration: BoxDecoration(
//                               color: context.containerColor,
//                               borderRadius: BorderRadius.circular(12.r),
//                             ),
//                             child: TextField(
//                               maxLines: 2,
//                               controller: detailController,
//                               decoration: InputDecoration(
//                                   helperMaxLines: 2,
//                                   hintMaxLines: 2,
//                                   hintText: 'Detail',
//                                   hintStyle: getRegularStyle(
//                                       color: context.titleColor.withOpacity(.5),
//                                       fontSize: MyFonts.size14),
//                                   border: InputBorder.none),
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 12.w),
//                             margin: EdgeInsets.symmetric(
//                               vertical: 8.h,
//                             ),
//                             decoration: BoxDecoration(
//                               color: context.containerColor,
//                               borderRadius: BorderRadius.circular(12.r),
//                             ),
//                             child: TextField(
//                               controller: saleController,
//                               keyboardType: TextInputType.number,
//                               decoration: InputDecoration(
//                                 hintText: 'Sale in %',
//                                 hintStyle: getRegularStyle(
//                                     color: context.titleColor.withOpacity(.5),
//                                     fontSize: MyFonts.size15),
//                                 border: InputBorder.none,
//                               ),
//                             ),
//                           ),
//                           CommonDropDown(
//                             valueItems: ['inStore', 'online'],
//                             onChanged: (String? newValue) {
//                               selectedOption = newValue;
//                             },
//                             value: 'inStore',
//                             hintText: 'Select Category',
//                             label: 'select Type',
//                           ),
//                           CommonDropDown(
//                             valueItems: couponCategories,
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 selectedCategory =
//                                     newValue!.toCouponCategoryEnum();
//                               });
//                             },
//                             value: selectedCategory?.type,
//                             hintText: '',
//                             label: 'select Type',
//                           ),
//                           Row(children: [
//                             Expanded(
//                               child: CustomDateField(
//                                 isInfoVisible: false,
//                                 ontap: () async {
//                                   DateTime? date = await showDatePicker(
//                                     context: context,
//                                     initialDate: DateTime.now(),
//                                     firstDate: DateTime(1900),
//                                     lastDate: DateTime.now()
//                                         .add(Duration(hours: 100)),
//                                     builder: (context, child) {
//                                       return Theme(
//                                         data: Theme.of(context).copyWith(
//                                           colorScheme: ColorScheme.light(
//                                             primary: context.primaryColor,
//                                             onPrimary: MyColors.white,
//                                             onSurface: context.primaryColor,
//                                           ),
//                                           // textButtonTheme: TextButtonThemeData(
//                                           // style: TextButton.styleFrom(
//                                           //   foregroundColor:
//                                           //   MyColors.themeColor,
//                                           //   // button text color
//                                           //   textStyle: TextStyle(
//                                           //     fontSize: MyFonts.fonts20,
//                                           //     fontWeight: FontWeight.w500,
//                                           //     color: MyColors.textColor,
//                                           //   ),
//                                           // ),
//                                           // ),
//                                         ),
//                                         child: child!,
//                                       );
//                                     },
//                                   );
//                                   if (date != null) {
//                                     setState(() {
//                                       createCouponController.text =
//                                           DateFormat('dd/MM/yyyy').format(date);
//                                       startDate = date;
//                                     });
//                                   }
//                                 },
//                                 readonly: true,
//                                 editController: createCouponController,
//                                 hintText: 'DD/MM/YYYY',
//                                 formKey: _formKeyCC,
//                                 headerText: 'Start Date',
//                                 isFieldEmpty: false,
//                                 onFocusChange: (hasFocus) {},
//                                 suffixIcon: Padding(
//                                     padding: EdgeInsets.all(15.sp),
//                                     child: Icon(Icons.calendar_month_rounded)),
//                                 validation: (value) {
//                                   if (!value!.isNotEmpty) {
//                                     return "Please enter Date Of Birth";
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             padding16,
//                             Expanded(
//                               child: CustomDateField(
//                                 isInfoVisible: false,
//                                 ontap: () async {
//                                   DateTime? date = await showDatePicker(
//                                     context: context,
//                                     initialDate: DateTime.now(),
//                                     firstDate: DateTime(1900),
//                                     lastDate: DateTime.now()
//                                         .add(Duration(hours: 20000)),
//                                     builder: (context, child) {
//                                       return Theme(
//                                         data: Theme.of(context).copyWith(
//                                           colorScheme: ColorScheme.light(
//                                             primary: context.primaryColor,
//                                             onPrimary: MyColors.white,
//                                             onSurface: context.primaryColor,
//                                           ),
//                                         ),
//                                         child: child!,
//                                       );
//                                     },
//                                   );
//                                   if (date != null) {
//                                     setState(() {
//                                       expireCouponController.text =
//                                           DateFormat('dd/MM/yyyy').format(date);
//                                       expireDate = date;
//                                     });
//                                   }
//                                 },
//                                 readonly: true,
//                                 editController: expireCouponController,
//                                 hintText: 'DD/MM/YYYY',
//                                 formKey: _formKeyEC,
//                                 headerText: 'Expire Date',
//                                 isFieldEmpty: false,
//                                 onFocusChange: (hasFocus) {},
//                                 suffixIcon: Padding(
//                                     padding: EdgeInsets.all(15.sp),
//                                     child: Icon(Icons.calendar_month_rounded)),
//                                 validation: (value) {
//                                   if (!value!.isNotEmpty) {
//                                     return "Please enter Date Of Birth";
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                           ]),
//                           padding16,
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (ref.watch(couponControllerProvider))
//               Container(
//                 color: context.titleColor.withOpacity(.2),
//                 child: Center(
//                   child: CircularProgressIndicator(
//                     color: context.primaryColor,
//                   ),
//                 ),
//               )
//           ],
//         ),
//       ),
//     );
//   }
//
//   List<String> couponCategories = [
//     'Dining & Takeout',
//     'Health & Fitness',
//     'Travel',
//     'Sports',
//     'Clothing',
//     'Outdoors',
//     'Makeup & Skincare',
//     'Baby & Kids',
//     'Electronics',
//     'Toys & Games',
//     'Home & Garden',
//     'Pet Supplies',
//     'Furniture & Decor',
//     'Car Rental',
//     'Bed & Bath',
//     'Auto Services',
//   ];
// }
//
// class CustomDateField extends StatelessWidget {
//   final TextEditingController editController;
//   final String hintText;
//   final Key formKey;
//   final String headerText;
//   final bool isFieldEmpty;
//   final bool? isInfoVisible;
//   final TextInputAction? textInputAction;
//   final TextInputType? inputType;
//   final bool? readonly;
//   final Function(bool) onFocusChange;
//   final GestureTapCallback? ontap;
//   final Function(String)? onSubmit;
//   final String? Function(String?)? validation;
//   final int? maxlines;
//   final bool? isPasswordType;
//   final Widget? suffixIcon;
//
//   CustomDateField({
//     required this.editController,
//     required this.hintText,
//     required this.formKey,
//     required this.headerText,
//     required this.isFieldEmpty,
//     this.isInfoVisible,
//     this.textInputAction,
//     this.inputType,
//     this.readonly,
//     required this.onFocusChange,
//     this.ontap,
//     this.onSubmit,
//     this.validation,
//     this.maxlines,
//     this.isPasswordType,
//     this.suffixIcon,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text(
//               headerText,
//               style: getBoldStyle(
//                   color: context.titleColor.withOpacity(.5),
//                   fontSize: MyFonts.size12),
//             ),
//             SizedBox(width: 7.58.w),
//             Visibility(
//                 visible: isInfoVisible ?? true,
//                 child: Image.asset(
//                   'assets/images/icons/information-fill@2x.png',
//                   height: 19.sp,
//                   width: 19.sp,
//                 ))
//           ],
//         ),
//         //  SizedBox(height: 12.h),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 12.w),
//           margin: EdgeInsets.symmetric(
//             vertical: 8.h,
//           ),
//           decoration: BoxDecoration(
//             color: context.containerColor,
//             borderRadius: BorderRadius.circular(12.r),
//           ),
//           child: Form(
//             key: formKey,
//             child: Focus(
//               onFocusChange: onFocusChange,
//               child: TextFormField(
//                 onFieldSubmitted: onSubmit,
//                 onTap: ontap,
//                 readOnly: readonly ?? false,
//                 textInputAction: textInputAction,
//                 maxLines: maxlines,
//                 keyboardType: inputType,
//                 controller: editController,
//                 // cursorColor: MyColors.black200,
//                 validator: validation,
//                 obscureText: isPasswordType ?? false,
//                 // style: TextStyle(
//                 //    // color: MyColors.textColor,
//                 //     fontSize: MyFonts.fonts16,
//                 //     fontFamily: "Regular",
//                 //     fontWeight: FontWeight.w400),
//                 decoration: InputDecoration(
//                   suffixIcon: suffixIcon,
//                   hintText: hintText,
//                   hintStyle: TextStyle(
//                       color: context.titleColor.withOpacity(.6),
//                       fontSize: MyFonts.size16,
//                       fontFamily: "Regular",
//                       fontWeight: FontWeight.w400),
//                   contentPadding:
//                       EdgeInsets.only(top: 16.h, bottom: 16.h, left: 16.w),
//                   // filled: true,
//                   // fillColor: MyColors.lightgrey,
//                   focusedBorder: InputBorder.none,
//                   enabledBorder: InputBorder.none,
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:opclo/core/extensions/color_extension.dart';
// import '../../../../commons/common_functions/validator.dart';
// import '../../../../commons/common_imports/common_libs.dart';
// import '../../../../commons/common_widgets/CustomTextFields.dart';
// import '../../../../commons/common_widgets/custom_button.dart';
// import '../../../../commons/common_widgets/custom_outline_button.dart';
// import '../../../auth/controller/auth_controller.dart';
//
// class AddressDialog extends StatefulWidget {
//   final bool isHomeAddress;
//   final bool isSignUp;
//   final TextEditingController addressController;
//
//
//   AddressDialog({Key? key, required this.isHomeAddress, required this.isSignUp, required this.addressController});
//
//   @override
//   _AddressDialogState createState() => _AddressDialogState();
// }
//
// class _AddressDialogState extends State<AddressDialog> {
//   final formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: Colors.white,
//       surfaceTintColor: MyColors.white,
//       title: Text(
//         widget.isHomeAddress ? 'Add Home Address' : 'Add Work Address',
//         style: getSemiBoldStyle(color: context.titleColor),
//       ),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Form(
//             key: formKey,
//             child: CustomTextField(
//               controller: widget.addressController,
//               hintText: widget.isHomeAddress
//                   ? 'Enter your home address'
//                   : 'Enter your work address',
//               onChanged: (String) {},
//               onFieldSubmitted: (String) {},
//               validatorFn: addressValidator,
//               obscure: false,
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         CustomOutlineButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             buttonWidth: 70.w,
//             buttonHeight: 45.h,
//             buttonText: 'Cancel'),
//         Consumer(builder: (context, ref, child) {
//           return CustomButton(
//               onPressed: () {
//                 if (formKey.currentState!.validate()) {
//
//                 //   ref
//                 //       .watch(authControllerProvider.notifier)
//                 //       .updateUserHomeAddress(
//                 //           context: context,
//                 //           address: widget.addressController.text.trim(),
//                 //           isHomeAddress: widget.isHomeAddress,
//                 //           ref: ref,
//                 //           isSignUp: widget.isSignUp);
//                 }
//               },
//               isLoading: ref.watch(authControllerProvider),
//               buttonHeight: 40.h,
//               buttonWidth: 60.w,
//               buttonText: 'Save');
//         })
//       ],
//     );
//   }
//
//
// }

import '../../../../commons/common_imports/common_libs.dart';

class ListItem extends StatelessWidget {
  final String imageUrl;
  final String text;

  ListItem({required this.imageUrl, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      margin: EdgeInsets.fromLTRB(0, 12.r,12.r,12.r),
      height: 120.h,
      width: 200.w,// Adjust the height as needed
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      // child: Align(
      //   alignment: Alignment.topLeft,
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Text(
      //       text,
      //       style: TextStyle(
      //         color: Colors.white,
      //         fontSize: 16,
      //         fontWeight: FontWeight.bold,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
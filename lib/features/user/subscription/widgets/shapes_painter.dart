import '../../../../commons/common_imports/common_libs.dart';

class ShapesPainter extends CustomPainter {
  final Color color;

  ShapesPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = color;
    // create a path
    var path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - size.height, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

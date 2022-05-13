import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///画面上にローディングアニメーションを表示する
Widget createProgressIndicator() {
  return Container(
    alignment: Alignment.center,
    child: const CircularProgressIndicator(
      color: Colors.blue,
    )
  );
}

class SquarePainter extends CustomPainter {
  
  final Color color;
  SquarePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
 
    paint.color = this.color;
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
  
  }
 
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


class TrianglePainter extends CustomPainter {
 
  final Color color;

  TrianglePainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    
    Paint fillWithBluePaint = Paint()
      ..color = this.color;
    
    var path = Path();
    path.moveTo(size.width / 3, size.height / 3);
    path.lineTo(size.width / 3, size.height / 2 * 1.5);
    path.lineTo(size.width / 4 * 3, size.height / 4 * 2.1);
    path.close();
    canvas.drawPath(path, fillWithBluePaint);

    var paint = Paint();
    paint.color = this.color;
    var rect = Rect.fromLTWH(-size.width / 1.5, size.height / 3, size.width, size.height / 2.4);
    canvas.drawRect(rect, paint);
  }
 
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
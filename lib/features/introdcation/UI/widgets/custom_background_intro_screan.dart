import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBackgroundIntroScrean extends StatelessWidget {

  final String image;
  const CustomBackgroundIntroScrean({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(120),
          bottomRight: Radius.circular(120),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurStyle:  BlurStyle.inner,
            blurRadius: 15,
            offset: Offset(0, 10),
            spreadRadius:7,
            
          ),
        ],
      ),

      child: Stack(
        children: [
          Positioned(
            top: 170,
            left: 0,
            child: CustomPaint(
              size: Size(40, 230),
              painter: LeftSideShapePainter(),
            ),
          ),

          Positioned(
            top: 60,
            right: 0,
            child: CustomPaint(
              size: Size(40, 230),
              painter: RightSideShapePainter(),
            ),
          ),

          Align(alignment: Alignment.center, child: Image.asset(image,width: 300,height: 400,)),
        ],
      ),
    );
  }
}

class LeftSideShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(0xff00B894)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, size.height * 0.2);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.5,
      size.width,
      size.height * 0.8,
    );
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RightSideShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(0xff00B894)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(0, size.height * 0.2);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.5,
      0,
      size.height * 0.8,
    );
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

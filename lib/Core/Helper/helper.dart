import 'package:flutter/material.dart';

class Helper {


  static void showErrorMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    ),
  );
}
  static double getResponsiveFontSize(
    BuildContext context, {
    required double fontSize,
  }) {
    double scaleFactor = _getScaleFactor(context);
    double responsiveFontSize = fontSize * scaleFactor;
    double lowerLimit = fontSize * 0.8;
    double upperLimit = fontSize * 1.2;
    return responsiveFontSize.clamp(lowerLimit, upperLimit);
  }

  static double getResponsiveWidth(
    BuildContext context, {
    required double width,
  }) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return width * (screenWidth / 400).clamp(0.8, 1.2);
  }

  static double getResponsiveHeight(
    BuildContext context, {
    required double height,
  }) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    return height * (screenHeight / 800).clamp(0.8, 1.2);
  }

  static double _getScaleFactor(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth < 600) {
      return screenWidth / 400;
    } else if (screenWidth < 900) {
      return screenWidth / 700;
    } else {
      return screenWidth / 1000;
    }
  }
}



// class Helper {
//   static double responsiveWidth(BuildContext context, {required double width}) {
//     double screenWidth = MediaQuery.sizeOf(context).width;
//     return width * (screenWidth / 400).clamp(0.8, 1.2);
//   }

//   static double responsiveHeight(
//     BuildContext context, {
//     required double height,
//   }) {
//     double screenWidth = MediaQuery.sizeOf(context).width;
//     return height * (screenWidth / 800).clamp(0.8, 1.2);
//   }
// }
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

// const primaryColor = Color(0xFFAD0059);
// const primaryColorLight = Color(0xFFE880C3);
// const secondaryColor = Color(0xFF12D476);
// const secondaryColorLight = Color(0xFFDAFDD4);
const primaryColor = Color(0xFF004AAD);
const primaryColorLight = Color(0xFFE3F2FD);
const secondaryColor = Color(0xFFEF6538);
const secondaryColorLight = Color(0xFFFFE0B2);
// const primaryColor = Color(0xFFAD0059);
// const primaryColorLight = Color(0xFFE880C3);
// const secondaryColor = Color(0xFF12D476);
// const secondaryColorLight = Color(0xFFDAFDD4);

class CustomStyles {
  final BuildContext context;
  CustomStyles({
    required this.context,
  });
  TextStyle textStyle(
      {double mobile = 16,
      double tablet = 16,
      double desktop = 16,
      double largeDesktop = 15,
      Color? color,
      FontWeight? fontWeight,
      String fontFamily = 'OpenSans',
      TextDecoration? decoration}) {
    return TextStyle(
        fontSize: ResponsiveValue<double>(context,
            defaultValue: mobile,
            conditionalValues: [
              Condition.equals(name: MOBILE, value: mobile),
              Condition.equals(name: TABLET, value: tablet),
              Condition.equals(name: DESKTOP, value: desktop),
              Condition.equals(name: '4K', value: largeDesktop),
            ]).value,
        color: color,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        decoration: decoration);
  }
}

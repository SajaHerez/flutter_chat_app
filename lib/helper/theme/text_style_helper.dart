import 'package:flutter/material.dart';

import 'fonts_helper.dart';

class TextStyleHelper {
  TextStyleHelper._();
  static TextStyle mainTitleStyle = TextStyle(
      fontWeight: FontWeights.medium,
      fontSize: FontSize.FS30,
      color: Colors.white);
  static TextStyle titleStyle = TextStyle(
      fontWeight: FontWeights.medium,
      fontSize: FontSize.FS25,
      color: Colors.white);
  static TextStyle subTitleStyle = TextStyle(
      fontWeight: FontWeights.regular,
      fontSize: FontSize.FS18,
      color: Colors.white);
  static TextStyle massageTitleStyle = const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

    static TextStyle massageSubTitleStyle = const  TextStyle(
          color: Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        );
  static TextStyle massageStyle = TextStyle(
      fontWeight: FontWeights.regular,
      fontSize: FontSize.FS16,
      color: Colors.white);
  static TextStyle confStyle = TextStyle(
      fontWeight: FontWeights.regular,
      fontSize: FontSize.FS12,
      color: Colors.white);

  static TextStyle textBtnStyle =
      TextStyle(fontSize: FontSize.FS23, color: Colors.white, height: 1.5);
}

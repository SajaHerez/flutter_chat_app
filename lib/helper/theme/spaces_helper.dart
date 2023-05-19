import 'package:flutter/material.dart';
class SpacesHelper {
  SpacesHelper._();
  static verticalSpace(double height) {
    return SizedBox(
      height: height,
    );
  }

  static horizontalSpace(double width) {
    return SizedBox(
      width: width,
    );
  }
}
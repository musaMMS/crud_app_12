
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class TextThemes {
  static TextStyle getTextStyle({
    Color color = blackColor,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = 0.5,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
    );
  }
}

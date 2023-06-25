import 'package:flutter/material.dart';

extension SpaceExtention on num {
  SizedBox spaceX([Widget? child]) => SizedBox(width: toDouble(), child: child);

  SizedBox spaceY([Widget? child]) => SizedBox(height: toDouble(), child: child);

  SizedBox spaceXY([Widget? child]) => SizedBox(height: toDouble(), width: toDouble(), child: child);

  SizedBox get spX => SizedBox(width: toDouble());

  SizedBox get spY => SizedBox(height: toDouble());

  SizedBox get spXY => SizedBox(height: toDouble(), width: toDouble());
}

extension CustomCard on num {
  Widget radius(
      {required Widget child,
      double elevation = 1,
      double? height,
      double? width,
      Color? color,
      Color? strokeColor = Colors.transparent,
      Color? shadowColor,
      EdgeInsets? margin,
      bool applyElevationTint = false}) {
    return SizedBox(
      height: height,
      width: width,
      child: Card(
        surfaceTintColor: !applyElevationTint ? Colors.white : null,
        shape: RoundedRectangleBorder(side: BorderSide(color: strokeColor!), borderRadius: BorderRadius.all(Radius.circular(toDouble()))),
        elevation: elevation,
        color: color,
        shadowColor: shadowColor ?? color,
        margin: margin,
        child: child,
      ),
    );
  }
}

extension PathExtension on num {
  double p<T>(double Function(double n) key) {
    //if (this == null) return key;
    key(toDouble());
    return toDouble();
  }
}

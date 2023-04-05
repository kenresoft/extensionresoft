import 'package:flutter/material.dart';

extension TextExtention on String {
  Text edit({TextStyle? textStyle, TextAlign? textAlign, Color? selectionColor}) => Text(
        this,
        style: textStyle,
        textAlign: textAlign,
        selectionColor: selectionColor,
      );
}

extension CustomImage on String {
  Image img({
    double scale = 1.0,
    double? width,
    double? height,
    Color? color,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
  }) {
    return Image(
      image: ExactAssetImage(this, scale: scale),
      width: width,
      height: height,
      color: color,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
    );
  }

  Container circleImage({
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    double scale = 1.0,
    double opacity = 1.0,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: ExactAssetImage(this),
          fit: fit,
          alignment: alignment,
          repeat: repeat,
          scale: scale,
          opacity: opacity,
        ),
      ),
    );
  }
}

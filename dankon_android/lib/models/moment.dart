import 'package:dankon/models/the_user.dart';
import 'package:flutter/material.dart';

enum ContentAlignment { start, center, end }

enum MediaType { image, video, color, gradient }

class Moment {
  const Moment(
      {required this.text,
      required this.medias,
      required this.verticalAlignment,
      required this.horizontalAlignment,
      required this.authorData,
      required this.textStyle,
      required this.frameStyle});

  final String text;
  final List<MomentMedia> medias;

  final ContentAlignment verticalAlignment;
  final ContentAlignment horizontalAlignment;

  final TheUser authorData;

  final MomentTextStyle textStyle;
  final MomentFrameStyle frameStyle;
}

class MomentMedia {
  MomentMedia({required this.type, this.url, this.boxFit});

  final String? url;
  final BoxFit? boxFit;
  final MediaType type;
}

class MomentTextStyle {
  MomentTextStyle(
      {required this.fontSize,
      required this.fontFamily,
      required this.color,
      this.letterSpacing,
      this.shadows = const [],
      this.isBold = false,
      this.isItalic = false});

  final double fontSize;
  final String fontFamily;
  final Color color;
  final double? letterSpacing;
  final List<MomentTextShadow>? shadows;
  final bool isBold;
  final bool isItalic;

  TextStyle toTextStyle() {
    return TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: !isBold ? FontWeight.normal : FontWeight.bold,
        fontStyle: !isItalic ? FontStyle.normal : FontStyle.italic,
        letterSpacing: letterSpacing,
        shadows:
            shadows != null ? shadows!.map((e) => e.toShadow()).toList() : []);
  }
}

class MomentTextShadow {
  final Color color;
  final double offsetX;
  final double offsetY;
  final double blur;

  MomentTextShadow(
      {required this.color,
      required this.offsetX,
      required this.offsetY,
      required this.blur});

  Shadow toShadow() {
    return Shadow(
        blurRadius: blur, offset: Offset(offsetX, offsetY), color: color);
  }
}

class MomentFrameStyle {
  MomentFrameStyle({required this.showInFrame, required this.color});

  final bool showInFrame;
  final Color? color;
}

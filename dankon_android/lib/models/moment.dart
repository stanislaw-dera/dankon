import 'package:dankon/models/the_user.dart';
import 'package:dankon/utils/enum_to_string_or_null.dart';
import 'package:dankon/utils/color_json_converter.dart';
import 'package:flutter/material.dart';

enum ContentAlignment { start, center, end }

enum MediaType { image, video, color, gradient }

class Moment {
  const Moment(
      {required this.text,
      required this.medias,
      required this.verticalAlignment,
      required this.horizontalAlignment,
      required this.author,
      required this.authorData,
      required this.textStyle,
      required this.frameStyle});

  final String text;
  final List<MomentMedia> medias;

  final ContentAlignment verticalAlignment;
  final ContentAlignment horizontalAlignment;

  final String author;
  final TheUser authorData;

  final MomentTextStyle textStyle;
  final MomentFrameStyle frameStyle;

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "medias": medias.map((media) => media.toJson()).toList(),
      "verticalAlignment": enumToStringOrNull(verticalAlignment),
      "horizontalAlignment": enumToStringOrNull(horizontalAlignment),
      "author": author,
      "authorData": authorData.toJson(),
      "textStyle": textStyle.toJson(),
      "frameStyle": frameStyle.toJson()
    };
  }

  static Moment fromJson(Map<String, dynamic> json) {
    List<MomentMedia> jsonMedias =
        (json["medias"] as List).map((e) => MomentMedia.fromJson(e)).toList();

    return Moment(
        text: json["text"],
        medias: jsonMedias,
        verticalAlignment: ContentAlignment.values
            .byName(json["verticalAlignment"].toString().split(".").last),
        horizontalAlignment: ContentAlignment.values
            .byName(json["horizontalAlignment"].toString().split(".").last),
        author: json["author"],
        authorData: TheUser.fromJson(json["authorData"]),
        textStyle: MomentTextStyle.fromJson(json["textStyle"]),
        frameStyle: MomentFrameStyle.fromJson(json["frameStyle"]));
  }
}

class MomentMedia {
  MomentMedia({required this.type, this.url, this.boxFit});

  final String? url;
  final BoxFit? boxFit;
  final MediaType type;

  Map<String, dynamic> toJson() => {
        "url": url,
        "boxFit": enumToStringOrNull(boxFit),
        "type": type.name.toString()
      };

  static MomentMedia fromJson(Map<String, dynamic> json) => MomentMedia(
      type: MediaType.values.byName(json["type"] != null
          ? json["type"].toString().split(".").last
          : "image"),
      url: json["url"],
      boxFit: BoxFit.values.byName(json["boxFit"] != null
          ? json["boxFit"].toString().split(".").last
          : "cover"));
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

  TextStyle toTextStyle() => TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: !isBold ? FontWeight.normal : FontWeight.bold,
      fontStyle: !isItalic ? FontStyle.normal : FontStyle.italic,
      letterSpacing: letterSpacing,
      shadows:
          shadows != null ? shadows!.map((e) => e.toShadow()).toList() : []);

  Map<String, dynamic> toJson() => {
        "fontSize": fontSize,
        "fontFamily": fontFamily,
        "color": color.toJson(),
        "letterSpacing": letterSpacing,
        "shadows": shadows?.map((shadow) => shadow.toJson()).toList(),
        "isBold": isBold,
        "isItalic": isItalic,
      };

  static MomentTextStyle fromJson(Map<String, dynamic> json) => MomentTextStyle(
        fontSize: json["fontSize"] as double,
        fontFamily: json["fontFamily"].toString(),
        color: colorFromJson(json["color"] as Map<String, dynamic>),
        letterSpacing: json["letterSpacing"],
        isBold: json["isBold"],
        isItalic: json["isItalic"],
      );
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

  Map<String, dynamic> toJson() => {
        "color": color.toJson(),
        "offsetX": offsetX,
        "offsetY": offsetY,
        "blur": blur,
      };
}

class MomentFrameStyle {
  MomentFrameStyle({this.showInFrame = false, this.color});

  final bool showInFrame;
  final Color? color;

  Map<String, dynamic> toJson() =>
      {"showInFrame": showInFrame, "color": color?.toJson()};

  static MomentFrameStyle fromJson(Map<String, dynamic> json) =>
      MomentFrameStyle(
        showInFrame: json["showInFrame"],
        color: json["color"] != null
            ? colorFromJson(json["color"])
            : json["color"],
      );
}

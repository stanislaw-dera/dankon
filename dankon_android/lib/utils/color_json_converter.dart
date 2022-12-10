import 'package:flutter/material.dart';

extension ColorToJson on Color {
  Map<String, dynamic> toJson() => {
        "r": red.toInt(),
        "g": green.toInt(),
        "b": blue.toInt(),
        "o": opacity.toDouble(),
      };
}

Color colorFromJson(Map<String, dynamic> json) => Color.fromRGBO(
    json["r"], json["g"], json["b"], double.parse(json["o"].toString()));

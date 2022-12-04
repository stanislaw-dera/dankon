import 'package:dankon/models/the_user.dart';
import 'package:flutter/material.dart';

class Moment {
  String text;
  List<String> mediaUrls;

  MainAxisAlignment verticalAlignment;
  CrossAxisAlignment horizontalAlignment;
  bool showInFrame;

  Color textColor;
  Color? frameColor;

  String author;
  TheUser authorData;


  Moment({
    required this.text,
    required this.mediaUrls,
    required this.verticalAlignment,
    required this.horizontalAlignment,
    required this.showInFrame,
    required this.textColor,
    required this.author,
    required this.authorData
  });
}

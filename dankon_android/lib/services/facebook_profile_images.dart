import 'package:flutter_dotenv/flutter_dotenv.dart';

String getAccessUrlIfFacebook(String url) {
  RegExp regExp = RegExp(
    r"https:\/\/graph.facebook.com\/",
    caseSensitive: false
  );

  if(regExp.hasMatch(url)) {
    return "$url?access_token=${dotenv.env["FB_ACCESS_TOKEN"]}";
  }

  return url;
}
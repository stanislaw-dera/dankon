import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedAvatar extends StatelessWidget {
  const CachedAvatar({Key? key, required this.url, this.radius})
      : super(key: key);
  final String url;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (BuildContext context, url) =>
          CircleAvatar(backgroundColor: Colors.grey[300], radius: radius),
      imageBuilder: (BuildContext context, image) =>
          CircleAvatar(backgroundImage: image, radius: radius),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}

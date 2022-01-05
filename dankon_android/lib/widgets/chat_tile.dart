import 'package:dankon/services/facebook_profile_images.dart';
import 'package:dankon/widgets/cached_avatar.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({Key? key, this.subtitle, required this.title, required this.imageUrl, this.trailing, this.onPressed}) : super(key: key);
  final String? subtitle;
  final String title;
  final String imageUrl;
  final Widget? trailing;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title),
        onTap: onPressed,
        subtitle: subtitle != null ? Text(subtitle!) : null,
        leading: CachedAvatar(url: getAccessUrlIfFacebook(imageUrl), radius: 22,),
        trailing: trailing
    );
  }
}

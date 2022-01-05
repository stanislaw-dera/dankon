import 'package:dankon/services/facebook_profile_images.dart';
import 'package:dankon/widgets/cached_avatar.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({Key? key, required this.subtitle, required this.title, required this.imageUrl, this.trailing}) : super(key: key);
  final String subtitle;
  final String title;
  final String imageUrl;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: CachedAvatar(url: getAccessUrlIfFacebook(imageUrl),),
        trailing: trailing
    );
  }
}

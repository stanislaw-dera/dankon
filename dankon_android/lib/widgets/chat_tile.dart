import 'package:dankon/widgets/cached_avatar.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({Key? key, this.subtitle, required this.title, required this.imageUrl, this.trailing, this.onPressed, this.isHighlighted = false}) : super(key: key);
  final String? subtitle;
  final String title;
  final String imageUrl;
  final bool isHighlighted;
  final Widget? trailing;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title, style: TextStyle(fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500)),
        onTap: onPressed,
        subtitle: subtitle != null ? Text(subtitle!, overflow: TextOverflow.ellipsis, maxLines: 1, style: isHighlighted ? const TextStyle(fontWeight: FontWeight.w500) : const TextStyle()) : null,
        leading: CachedAvatar(url: imageUrl, radius: 22,),
        trailing: trailing
    );
  }
}

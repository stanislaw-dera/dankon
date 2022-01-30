import 'package:badges/badges.dart';
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
        title: Row(
          children: [
            Text(title, style: TextStyle(fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500)),
            const SizedBox(width: 8,),
            ChatBadge(show: isHighlighted)
          ],
        ),
        onTap: onPressed,
        subtitle: subtitle != null ? Text(subtitle!, overflow: TextOverflow.ellipsis, maxLines: 1, style: isHighlighted ? const TextStyle(fontWeight: FontWeight.w500) : const TextStyle()) : null,
        leading: CachedAvatar(url: imageUrl, radius: 22,),
        trailing: trailing
    );
  }
}

class ChatBadge extends StatelessWidget {
  const ChatBadge({Key? key, this.show = false}) : super(key: key);
  final bool show;

  @override
  Widget build(BuildContext context) {
    return show ? Badge(elevation: 0, badgeColor: Theme.of(context).primaryColor,) : Container();
  }
}


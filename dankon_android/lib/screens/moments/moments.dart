import 'package:dankon/models/moment.dart';
import 'package:dankon/models/the_user.dart';
import 'package:flutter/material.dart';
import 'package:dankon/screens/moments/moments_post.dart';

class Moments extends StatefulWidget {
  const Moments({Key? key}) : super(key: key);

  @override
  State<Moments> createState() => _MomentsState();
}

class _MomentsState extends State<Moments> {
  @override
  Widget build(BuildContext context) {
    Moment exampleMoment = Moment(
        text: "Hello there!",
        medias: [
          MomentMedia(
              type: MediaType.image, url: "https://picsum.photos/500/800")
        ],
        verticalAlignment: ContentAlignment.end,
        horizontalAlignment: ContentAlignment.center,
        frameStyle: MomentFrameStyle(showInFrame: true, color: Colors.green),
        textStyle: MomentTextStyle(
            fontSize: 24,
            isBold: true,
            isItalic: true,
            fontFamily: "Lato",
            color: Colors.white),
        authorData: TheUser(
            uid: "myuid47",
            name: "John Smith",
            urlAvatar: "https://picsum.photos/50/50"));

    return Stack(
      children: [
        PageView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: [
            MomentsPost(
              moment: exampleMoment,
            )
          ],
        ),
      ],
    );
  }
}

import 'package:dankon/models/moment.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MomentsPost extends StatelessWidget {
  const MomentsPost({Key? key, required this.moment}) : super(key: key);
  final Moment moment;

  @override
  Widget build(BuildContext context) {
    EdgeInsets cardPadding = const EdgeInsets.all(36);
    Color placeholderColor = Colors.grey.shade900;

    return Container(
      color: placeholderColor,
      child: Stack(children: [
        Positioned.fill(
            child: PageView(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(moment.medias[0].url.toString()),
                      fit: moment.medias[0].boxFit != null
                          ? BoxFit.values.byName(moment.medias[0].boxFit
                              .toString()
                              .split(".")
                              .last)
                          : BoxFit.cover)),
            )
          ],
        )),
        Positioned.fill(
          child: Container(
            padding: cardPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.values
                  .byName(moment.verticalAlignment.toString().split(".").last),
              crossAxisAlignment: CrossAxisAlignment.values.byName(
                  moment.horizontalAlignment.toString().split(".").last),
              children: [MomentsPostText(moment: moment)],
            ),
          ),
        )
      ]),
    );
  }
}

class MomentsPostText extends StatelessWidget {
  const MomentsPostText({Key? key, required this.moment}) : super(key: key);
  final Moment moment;

  @override
  Widget build(BuildContext context) {
    EdgeInsets framePadding = const EdgeInsets.all(16);
    BoxConstraints frameConstraints =
        const BoxConstraints(minWidth: 100, maxWidth: 250);
    BorderRadius frameBorderRadius =
        const BorderRadius.all(Radius.circular(10));

    return Container(
      padding: moment.frameStyle.showInFrame
          ? framePadding
          : const EdgeInsets.all(0),
      constraints: frameConstraints,
      decoration: moment.frameStyle.showInFrame
          ? BoxDecoration(
              borderRadius: frameBorderRadius,
              color: moment.frameStyle.color,
            )
          : const BoxDecoration(),
      child: Text(moment.text,
          textAlign: TextAlign.values
              .byName(moment.horizontalAlignment.toString().split(".").last),
          style: GoogleFonts.getFont(moment.textStyle.fontFamily,
              textStyle: moment.textStyle.toTextStyle())),
    );
  }
}

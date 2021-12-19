import 'package:flutter/material.dart';

class ChristmasChoice extends StatelessWidget {

  final String emoji;

  const ChristmasChoice({Key? key, required this.emoji}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          onTap: () {
            // set chat badge
          },
          child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 20),
              ))),
    );
  }
}


class ChristmasBottomSheet extends StatelessWidget {
  const ChristmasBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: Column(
          children: [
            const Text(
              'Merry Christmas!',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              "Choose special christmas badge for your chat! Available for limited time",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 4,
                children: const [
                  ChristmasChoice(emoji: "🎄"),
                  ChristmasChoice(emoji: "🎀"),
                ],
              ),
            ),
          ],
        ));
  }
}

import 'package:dankon/constants.dart';
import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  const MessageInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 32,
            color: const Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: kPrimaryColor.withOpacity(0.2),

                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sentiment_satisfied_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                    const SizedBox(width: 20 / 4),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            const CircleAvatar(child: Icon(Icons.send, size: 15,), backgroundColor: kPrimaryColor, foregroundColor: kDarkColor,)
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class NewMessagesChip extends StatelessWidget {
  const NewMessagesChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      padding: const EdgeInsets.all(0),
      backgroundColor: Theme.of(context).primaryColor,
      label: const Text('New messages', style: TextStyle(color: Colors.white)),
    );
  }
}

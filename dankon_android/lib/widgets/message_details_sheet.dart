import 'package:flutter/material.dart';

class MessageDetailsSheet extends StatelessWidget {
  const MessageDetailsSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Delete for everyone"),
      leading: const Icon(Icons.delete),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}

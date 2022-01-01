import 'package:dankon/constants.dart';
import 'package:flutter/material.dart';

class HugeButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  const HugeButton({Key? key, required this.onPressed, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(

        onPressed: onPressed,

        icon: const Icon(Icons.add),

        label: Text(text, style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 20),),

        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: kDarkColor,
          onPrimary: Colors.white,
          padding: const EdgeInsets.all(20)
        ),


      ),
    );
  }
}

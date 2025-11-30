import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final String text;
  const SmallButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(
        height: 30,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
            child: Text(
          text,
          style: TextStyle(color: Colors.white),
        )),
      ),
    );
  }
}

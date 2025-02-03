import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

//TODO blabla
class ActionButton extends StatelessWidget {
  ActionButton(
      {Key? key, required this.title, required this.icon, this.onPressed})
      : super(key: key);
  final String title;
  final IconData icon;
  void Function()? onPressed = () {};
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5, bottom: 10, top: 10),
      child: SizedBox(
        width: 115,
        height: 50,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: EdgeInsets.zero,
              //  borderRadius: BorderRadius.circular(30),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            onPressed: onPressed),
      ),
    );
  }
}

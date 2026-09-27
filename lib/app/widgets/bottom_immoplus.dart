import 'package:immoplus/app/design_system/design_system.dart';
import 'package:flutter/cupertino.dart';

class BottomImmoPlus extends StatelessWidget {
  const BottomImmoPlus({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        child: Center(
          child: Text(
            "©Afriq'Solus",
            style: AppTypography.font(color: Color.fromARGB(255, 182, 181, 181)),
          ),
        ));
  }
}

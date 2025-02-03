import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/features/location_module/location_map_page.dart';
import 'package:immoplus/app/routes/app_router.dart';

class ButtonMap extends StatelessWidget {
  const ButtonMap({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: CupertinoColors.tertiarySystemFill,
      foregroundColor: Colors.black,
      child: IconButton(
        onPressed: () async {
          print("Cracra");
          FocusScope.of(context).unfocus();
          // final address =
          //     await Get.toNamed(Routes.LOCATION_MAP, preventDuplicates: false);
          //AppRouter.router.pushNamed(LocationMapPage.name);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocationMapPage(),
              ));
          // Get.back(result: address);
        },
        icon: const Icon(CupertinoIcons.map),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:immoplus/app/core/services/app_version_service.dart';
import 'package:immoplus/app/widgets/bottom_immoplus.dart';

class VersionAppWidget extends StatelessWidget {
  final Color? color;
  const VersionAppWidget({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: AppVersionService.getVersion(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Center(
                child: Text(
                  '${snapshot.data}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ),
              BottomImmoPlus(),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}

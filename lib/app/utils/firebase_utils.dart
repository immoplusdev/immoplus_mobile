import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/routes/app_router.dart';

class FirebaseUtils {
  static showImageNotification(
      {required BuildContext context,
      required String imageUrl,
      String? route}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SizedBox.shrink(
        child: Center(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: (route == null || route == '')
                        ? null
                        : () {
                            log("Hello");
                            GoRouter.of(context).pop();
                            AppRouter.router.go(route);
                          },
                    child: Container(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(imageUrl),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -10,
                right: -5,
                child: IconButton(
                    color: Colors.white,
                    style: IconButton.styleFrom(
                        elevation: 3, shadowColor: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(CupertinoIcons.clear_circled_solid)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

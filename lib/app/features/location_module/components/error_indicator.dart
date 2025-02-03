import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({Key? key, this.description, this.title})
      : super(key: key);

  final String? title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return (GetUtils.isNullOrBlank(title) == false ||
            GetUtils.isNullOrBlank(description) == false)
        ? Align(
            alignment: Alignment.topCenter,
            child: Card(
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(),
              color: const Color(0xFFEF4444),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (title != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          title ?? "",
                          style: Get.theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (description != null)
                      Text(
                        description ?? "",
                        style: Get.theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}

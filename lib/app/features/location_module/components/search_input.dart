import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../location_controller.dart';

class SearchInput extends GetView<LocationController> {
  const SearchInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: CupertinoSearchTextField(
        style: context.textTheme.titleLarge
            ?.copyWith(color: CupertinoColors.black),
        placeholderStyle: context.textTheme.titleLarge
            ?.copyWith(color: CupertinoColors.systemGrey),
        placeholder: "Saisissez une adresse",
        autofocus: true,
        onChanged: (value) => controller.subject.add(value),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

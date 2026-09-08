import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus/app/configs/app_typography.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/contact_utils.dart';

class ClientServiceChip extends StatelessWidget {
  const ClientServiceChip({super.key});

  @override
  Widget build(BuildContext context) {
    return InputChip(
      onPressed: () {
        ContactUtils.showContact();
      },
      backgroundColor: AppColors.white,
      avatar: Icon(
        FontAwesomeIcons.headset.data,
        color: AppColors.black,
        size: 15,
      ),
      elevation: 1,
      labelPadding: const EdgeInsets.symmetric(horizontal: 5),
      label: Text(
        "Service client",
        style: AppTypography.labelMedium.copyWith(color: AppColors.black),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus/app/data/models/remote/configs/commune_model.dart';
import 'package:immoplus/app/modules/ville_and_commune_selector/commune_selector_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class CommuneSelectorListtile extends StatefulWidget {
  const CommuneSelectorListtile({super.key, required this.onSelect});
  final void Function(CommuneModel? commune) onSelect;
  @override
  State<CommuneSelectorListtile> createState() =>
      _CommuneSelectorListtileState();
}

class _CommuneSelectorListtileState extends State<CommuneSelectorListtile> {
  CommuneModel? communeModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      tileColor: (communeModel != null)
          ? AppColors.primaryLite
          : CupertinoColors.tertiarySystemFill,
      leading: FaFaIcon(
        FontAwesomeIcons.treeCity,
        color:
            (communeModel != null) ? AppColors.primary : Colors.grey.shade400,
      ),
      title: Text(
        (communeModel != null) ? communeModel!.name : "Selectioner une commune",
      ),
      trailing: const Icon(CupertinoIcons.chevron_right_circle_fill),
      onTap: () => showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: AppColors.scafold,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        showDragHandle: true,
        builder: (context) => const FractionallySizedBox(
          heightFactor: 0.835,
          child: CommuneSelectorPage(),
        ),
      ).then(
        (value) {
          if (value is CommuneModel) {
            setState(() {
              communeModel = value;
              widget.onSelect(value);
            });
          }
        },
      ),
    );
  }
}

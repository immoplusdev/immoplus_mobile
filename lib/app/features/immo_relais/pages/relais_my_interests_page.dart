import 'package:immoplus/app/design_system/tokens/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/features/immo_relais/widgets/relais_my_interests_section.dart';

/// Page dédiée "Mes intérêts" — relais sur lesquels j'ai exprimé un
/// intérêt, ouverte depuis la carte bento du hub "Je déménage".
class RelaisMyInterestsPage extends StatelessWidget {
  const RelaisMyInterestsPage({super.key});
  static const String name = 'RELAIS_MY_INTERESTS_PAGE';
  static const String routePath = '/relais/interests/mine';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: Text('Mes intérêts'), centerTitle: true),
      body: const RelaisMyInterestsSection(),
    );
  }
}

import 'package:immoplus/app/design_system/tokens/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/features/immo_relais/widgets/relais_received_interests_section.dart';

/// Page dédiée "Reçues" — demandes reçues sur mes relais, ouverte
/// depuis la carte bento du hub "Je déménage".
class RelaisReceivedInterestsPage extends StatelessWidget {
  const RelaisReceivedInterestsPage({super.key});
  static const String name = 'RELAIS_RECEIVED_INTERESTS_PAGE';
  static const String routePath = '/relais/interests/received';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: Text('Reçues'), centerTitle: true),
      body: const RelaisReceivedInterestsSection(),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/utils/ad_action_handler.dart';

/// Wraps any ad widget with tap and long-press handling.
/// - [onTap]       → triggers the campaign action normally.
/// - [onLongPress] → triggers the campaign action with [isLongPress] = true
///                   (copies the campaign debug JSON to clipboard).
class AdTap extends StatelessWidget {
  final AdCampaignModel campaign;
  final Widget child;

  const AdTap({
    super.key,
    required this.campaign,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AdActionHandler.handleAdAction(context, campaign),
      onLongPress: () =>
          AdActionHandler.handleAdAction(context, campaign, isLongPress: true),
      child: child,
    );
  }
}

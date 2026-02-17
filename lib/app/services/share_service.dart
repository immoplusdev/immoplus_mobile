import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  /// Partage un texte simple avec position d'origine
  static Future<ShareResult> shareText({
    required String text,
    String? subject,
    BuildContext? context,
    Rect? sharePositionOrigin,
  }) async {
    try {
      final origin = _getSharePositionOrigin(context, sharePositionOrigin);

      return await Share.share(
        text,
        subject: subject,
        sharePositionOrigin: origin,
      );
    } catch (e) {
      debugPrint('Erreur lors du partage: $e');
      rethrow;
    }
  }

  /// Partage une URL de résidence
  static Future<ShareResult> shareResidence({
    required String residenceId,
    String? residenceName,
    BuildContext? context,
    Rect? sharePositionOrigin,
  }) async {
    final url = "https://app.immoplus.ci/residence_detail/$residenceId";
    final text = residenceName != null
        ? "Découvrez cette résidence: $residenceName\n$url"
        : url;

    return await shareText(
      text: text,
      subject: 'Partager cette résidence',
      context: context,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  static Future<ShareResult> shareBien({
    required String bienId,
    String? bienName,
    BuildContext? context,
    Rect? sharePositionOrigin,
  }) async {
    final url = "https://app.immoplus.ci/bien_detail/$bienId";
    final text = bienName != null ? "Découvrez ce bien: $bienName\n$url" : url;

    return await shareText(
      text: text,
      subject: 'Partager ce bien',
      context: context,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Partage une URL de propriété
  static Future<ShareResult> shareProperty({
    required String propertyId,
    String? propertyName,
    BuildContext? context,
    Rect? sharePositionOrigin,
  }) async {
    final url = "https://app.immoplus.ci/property_detail/$propertyId";
    final text = propertyName != null
        ? "Découvrez cette propriété: $propertyName\n$url"
        : url;

    return await shareText(
      text: text,
      subject: 'Partager cette propriété',
      context: context,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Partage une URL générique
  static Future<ShareResult> shareUrl({
    required String url,
    String? title,
    String? subject,
    BuildContext? context,
    Rect? sharePositionOrigin,
  }) async {
    final text = title != null ? "$title\n$url" : url;

    return await shareText(
      text: text,
      subject: subject,
      context: context,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Partage avec message personnalisé pour l'application
  static Future<ShareResult> shareAppInvitation({
    BuildContext? context,
    Rect? sharePositionOrigin,
  }) async {
    const text = """
Découvrez Immo Plus Pro - La solution complète pour gérer vos biens immobiliers !

Téléchargez l'application:
https://app.immoplus.ci
""";

    return await shareText(
      text: text,
      subject: "Rejoignez Immo Plus Pro",
      context: context,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Méthode privée pour obtenir la position d'origine du partage
  static Rect? _getSharePositionOrigin(
    BuildContext? context,
    Rect? sharePositionOrigin,
  ) {
    if (sharePositionOrigin != null) {
      return sharePositionOrigin;
    }

    if (context != null) {
      try {
        final renderObject = context.findRenderObject();

        // Vérifier si c'est bien un RenderBox
        if (renderObject is RenderBox && renderObject.hasSize) {
          return renderObject.localToGlobal(Offset.zero) & renderObject.size;
        }
      } catch (e) {
        debugPrint('Impossible de trouver la position d\'origine: $e');
      }
    }

    return null;
  }

  /// Obtenir la position depuis un GlobalKey
  static Rect? getSharePositionFromKey(GlobalKey key) {
    try {
      final context = key.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          return box.localToGlobal(Offset.zero) & box.size;
        }
      }
    } catch (e) {
      debugPrint('Impossible de trouver la position depuis la clé: $e');
    }
    return null;
  }
}

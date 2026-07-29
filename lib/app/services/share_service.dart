import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  /// Partage un texte simple avec position d'origine
  static Future<ShareResult> shareText({
    required String text,
    required String uri,
    String? subject,
    BuildContext? context,
    Rect? sharePositionOrigin,
  }) async {
    try {
      final origin = _getSharePositionOrigin(context, sharePositionOrigin);

      return await SharePlus.instance.share(
        ShareParams(
            uri: Uri.parse(uri),
            sharePositionOrigin: origin,
            title: text,
            subject: subject),
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
    final text = "Découvrez cette résidence: ${residenceName ?? ""}";

    return await shareText(
      text: text,
      uri: url,
      subject: 'Partager cette résidence',
      context: context,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Partage une URL de hotel
  static Future<ShareResult> shareHotel({
    required String hotelId,
    String? hotelName,
    BuildContext? context,
    Rect? sharePositionOrigin,
  }) async {
    final url = "https://app.immoplus.ci/hotels/$hotelId";
    final text = "Découvrez cet hotel: ${hotelName ?? ""}";

    return await shareText(
      text: text,
      uri: url,
      subject: 'Partager cet hotel',
      context: context,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Partage une URL de chambre d'hotel
  static Future<ShareResult> shareRoomHotel({
    required String hotelId,
    required String hotelRoomId,
    String? hotelRoomName,
    BuildContext? context,
    Rect? sharePositionOrigin,
  }) async {
    final url = "https://app.immoplus.ci/hotels/$hotelId/chambres/$hotelRoomId";
    final text = "Découvrez cette chambre: ${hotelRoomName ?? ""}";

    return await shareText(
      text: text,
      uri: url,
      subject: 'Partager cette chambre d\'hotel',
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
    final text = "Découvrez ce bien: ${bienName ?? ""}";

    return await shareText(
      uri: url,
      text: text,
      subject: 'Partager ce bien',
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

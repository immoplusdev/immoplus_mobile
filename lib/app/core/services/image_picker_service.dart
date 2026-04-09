import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:immoplus/app/core/logger/immo_logger.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
// Note: Assurez-vous que CompressFileUtils est bien accessible dans votre projet
// import 'package:immoplus/app/utils/compress_file_utils.dart';
import 'package:permission_handler/permission_handler.dart';

const CAMERA_ACCESS_DENIED_IMAGEPICKER = "camera_access_denied";
const PHOTO_ACCESS_DENIED_CODE = "photo_access_denied";
const CAMERA_ACCESS_DENIED_CODE = "CameraAccessDenied";
const CAMERA_ACCESS_DENIED_WITH_PROMPT_CODE = "CameraAccessDeniedWithoutPrompt";

class ImagePickerService {
  // Instance privée pour le pattern singleton (optionnel)
  static final ImagePicker _picker = ImagePicker();

  /// Permet à l'utilisateur de sélectionner plusieurs images depuis la galerie
  ///
  /// Retourne une liste de [File] représentant les images sélectionnées.
  /// La qualité des images est réduite à 60% pour optimiser les performances.
  ///
  /// Retourne une liste vide si aucune image n'est sélectionnée ou en cas d'erreur.
  static Future<List<File>> pickMultipleImages(
      {int? imageQuality = 60, required BuildContext context}) async {
    try {
      final List<XFile> xFiles =
          await _picker.pickMultiImage(imageQuality: imageQuality);
      return xFiles.map((xFile) => File(xFile.path)).toList();
    } on PlatformException catch (e) {
      ImmoLogger.e('Erreur lors de la sélection des images: $e');
      if (e.code == CAMERA_ACCESS_DENIED_IMAGEPICKER) {
        AppDialog.info(
          barrierDismissible: true,
          content:
              "Vous devez autoriser l'accès à votre caméra avant de continuer",
          icon: Text("Permission non accordée"),
          textButton: "Paramètre",
          rollback: () {
            openAppSettings();
          },
        );
      } else if (e.code == PHOTO_ACCESS_DENIED_CODE) {
        AppDialog.info(
          barrierDismissible: true,
          content:
              "Vous devez autoriser l'accès à votre librairie photo avant de continuer",
          icon: Text("Permission non accordée"),
          textButton: "Paramètre",
          rollback: () {
            openAppSettings();
          },
        );
      } else {
        AppDialog.info(
          barrierDismissible: true,
          content: e.message ?? "Un problème est survenue",
          icon: Text("Impossible"),
          textButton: "Compris !",
        );
      }
      return [];
    } catch (e) {
      // Log l'erreur ou gérez-la selon vos besoins
      ImmoLogger.e('Erreur lors de la sélection des images: $e');
      return [];
    }
  }

  /// Permet à l'utilisateur de sélectionner une vidéo depuis la galerie
  ///
  /// Retourne un [File?] représentant la vidéo sélectionnée.
  /// Retourne null si aucune vidéo n'est sélectionnée ou en cas d'erreur.
  static Future<File?> pickVideo({
    required BuildContext context,
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickVideo(source: source);

      if (pickedFile != null) {
        return File(pickedFile.path);
      }

      return null;
    } on PlatformException catch (e) {
      ImmoLogger.e('Erreur lors de la sélection de la vidéo: $e');

      if (e.code == CAMERA_ACCESS_DENIED_IMAGEPICKER ||
          e.code == CAMERA_ACCESS_DENIED_CODE ||
          e.code == CAMERA_ACCESS_DENIED_WITH_PROMPT_CODE) {
        AppDialog.info(
          barrierDismissible: true,
          content:
              "Vous devez autoriser l'accès à votre caméra avant de continuer",
          icon: Text("Permission non accordée"),
          textButton: "Paramètre",
          rollback: () {
            openAppSettings();
          },
        );
      } else if (e.code == PHOTO_ACCESS_DENIED_CODE) {
        AppDialog.info(
          barrierDismissible: true,
          content:
              "Vous devez autoriser l'accès à votre librairie photo avant de continuer",
          icon: Text("Permission non accordée"),
          textButton: "Paramètre",
          rollback: () {
            openAppSettings();
          },
        );
      } else {
        AppDialog.info(
          barrierDismissible: true,
          content: e.message ?? "Un problème est survenue",
          icon: Text("Impossible"),
          textButton: "Compris !",
        );
      }

      return null;
    } catch (e) {
      ImmoLogger.e('Erreur lors de la sélection de la vidéo: $e');
      return null;
    }
  }

  /// Permet à l'utilisateur de sélectionner une image depuis la galerie ou la caméra
  /// avec compression automatique
  static Future<File?> pickImage({
    required BuildContext context,
    ImageSource source = ImageSource.camera,
    int? imageQuality = 40,
  }) async {
    try {
      final XFile? value =
          await _picker.pickImage(source: source, imageQuality: imageQuality);
      if (value != null) {
        // En attente d'importation de CompressFileUtils dans votre projet
        // XFile? compressFile = await CompressFileUtils.compressFileIfNeeded(value);
        // if (compressFile != null) return File(compressFile.path);
        return File(value.path);
      }
      return null;
    } on PlatformException catch (e) {
      ImmoLogger.e('Erreur lors de la sélection de l\'image: $e');

      if (e.code == CAMERA_ACCESS_DENIED_IMAGEPICKER ||
          e.code == CAMERA_ACCESS_DENIED_CODE ||
          e.code == CAMERA_ACCESS_DENIED_WITH_PROMPT_CODE) {
        AppDialog.info(
          barrierDismissible: true,
          content:
              "Vous devez autoriser l'accès à votre caméra avant de continuer",
          icon: const Text("Permission non accordée"),
          textButton: "Paramètre",
          rollback: () {
            openAppSettings();
          },
        );
      } else if (e.code == PHOTO_ACCESS_DENIED_CODE) {
        AppDialog.info(
          barrierDismissible: true,
          content:
              "Vous devez autoriser l'accès à votre librairie photo avant de continuer",
          icon: const Text("Permission non accordée"),
          textButton: "Paramètre",
          rollback: () {
            openAppSettings();
          },
        );
      } else {
        AppDialog.info(
          barrierDismissible: true,
          content: e.message ?? "Un problème est survenue",
          icon: const Text("Impossible"),
          textButton: "Compris !",
        );
      }

      return null;
    } catch (e) {
      ImmoLogger.e('Erreur lors de la sélection de l\'image: $e');
      return null;
    }
  }
}

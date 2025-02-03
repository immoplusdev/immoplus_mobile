import 'dart:io';

import 'package:flutter/foundation.dart';

// class CoreUtils {
//   static Future<File?> convertirEtCompresserVideo(String cheminEntree) async {
//     String cheminSortie = cheminEntree.replaceFirst(
//       RegExp(r'\.\w+$'),
//       '.mp4',
//     );

//     String commandeFFmpeg =
//         '-i "$cheminEntree" -vcodec mpeg4 -b:v 1500k -acodec aac -b:a 128k "$cheminSortie"';

//     final session = await FFmpegKit.execute(commandeFFmpeg);
//     final returnCode = await session.getReturnCode();
//     final logs = await session.getAllLogsAsString();

//     if (ReturnCode.isSuccess(returnCode)) {
//       if (kDebugMode) {
//         print('Vidéo convertie en MP4 avec succès.');
//       }

//       return File(cheminSortie);
//     } else {
//       if (kDebugMode) {
//         print('Erreur lors de la conversion de la vidéo :');
//         print(logs);
//       }

//       return null;
//     }
//   }
// }

import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:immoplus/app/data/repositories/auth_repository.dart';

import '../../../data/models/remote/files/file_data_model.dart';
import 'easy_loading_handler.dart';

Future<String?> uploadFile({required File file}) async {
  EasyLoadingHandler.showLoagingToast(text: "Envoie des images");

  FileDataModel response = await AuthRepository().uplaodFile(file: file);
  EasyLoading.dismiss();
  return response.data!.id;
}

const double appPadding = 16.0;

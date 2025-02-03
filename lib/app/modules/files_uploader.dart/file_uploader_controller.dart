import 'dart:io';

import 'package:immoplus/app/data/models/remote/files/file_data_model.dart';
import 'package:immoplus/app/data/repositories/auth_repository.dart';

class FileUploaderController {
  String? filePath;
  File? file;
  Future<FileDataModel> upladFile() async {
    return await AuthRepository().uplaodFile(file: file!);
  }
}

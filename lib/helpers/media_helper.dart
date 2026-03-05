import 'dart:developer';

import 'package:file_picker/file_picker.dart';

class MediaHelper {
  static Future<PlatformFile?> processImage() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(allowMultiple: false, withData: true, type: FileType.image);

      final file = result?.files.single;

      if (file == null) return null;
      if (file.bytes == null && file.path == null) return null;

      return file;
    } catch (e) {
      log("MediaHelper - processImage", time: DateTime.now(), error: e, name: "Unknown Error");
      return null;
    }
  }
}

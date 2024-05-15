import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  static Future<void> shareImageFromPath({
    required String fileName,
    required Uint8List? imageData,
  }) async {
    if (imageData != null) {
      final directory = await getTemporaryDirectory();
      File file = await File('${directory.path}/$fileName.png')
          .writeAsBytes(imageData);

      await Share.shareXFiles(
        [
          XFile(file.path),
        ],
      );
    }
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';


class WidgetToImage {
  static Future<File> getImageFromWidget(GlobalKey key) async {
    RenderRepaintBoundary boundary =
    key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 3.0);
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    var byteList = byteData?.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    File file = File('${tempDir.path}/image.png');
    await file.writeAsBytes(byteList?.toList() ?? []);

    return file;
  }
}
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

import 'src/app.dart';
import 'src/file_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FileHelper helper = FileHelper('test.json');
  print(await helper.getWatchingFolders());

  if (!await Permission.storage.request().isGranted) {
    throw Error();
  }

  runApp(Moosik());
}

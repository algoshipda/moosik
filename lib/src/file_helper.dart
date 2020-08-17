import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:io';

class DbFileNotExists implements Exception {}

class FileHelper {
  String _dbFileName;
  FileHelper(this._dbFileName);

  Future<List<String>> getWatchingFolders() async {
    await _ensureDbFile();

    String dbFileContent = await _getDbFile();
    List<dynamic> dynamicFolderNames = jsonDecode(dbFileContent);
    List<String> folderNames = dynamicFolderNames.cast<String>();
    return folderNames;
  }

  Future<void> _writeWatchingFolders(List<String> watchingFolders) async {
    String path = await _dbFilePath;
    File file = new File(path);
    await file.writeAsString(jsonEncode(watchingFolders));
  }

  Future<String> get _dbFilePath async =>
      join((await getApplicationSupportDirectory()).path, _dbFileName);

  Future<void> _ensureDbFile() async {
    String path = await _dbFilePath;
    File file = new File(path);
    if (!file.existsSync()) {
      await file.writeAsString(
        jsonEncode([]),
      );
      file.createSync(recursive: true);
    }
  }

  Future<void> addFolder(String folderPath) async {
    List<String> watchingFolders = await getWatchingFolders();
    watchingFolders.add(folderPath);
    await _writeWatchingFolders(watchingFolders);
  }

  Future<String> _getDbFile() async {
    String path = await _dbFilePath;
    File file = new File(path);
    if (!file.existsSync()) {
      throw DbFileNotExists();
    }

    return file.readAsString();
  }
}

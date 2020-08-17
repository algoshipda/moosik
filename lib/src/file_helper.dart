import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'dart:io';
import 'package:dart_tags/dart_tags.dart';

class Mp3File {
  final String title;
  final String artist;
  final String album;
  final String fileName;
  final String realPath;
  Mp3File({this.title, this.artist, this.album, this.fileName, this.realPath});

  static Future<Mp3File> fromFileSystemEntity(FileSystemEntity entity) async {
    FileStat stat = await entity.stat();
    String realPath = entity.path;
    String fileName = path.basename(realPath);
    TagProcessor tp = new TagProcessor();
    File f = new File(realPath);

    List<Tag> tags = await tp.getTagsFromByteArray(
        f.readAsBytes(), [TagProcessor.getTagType('id3', '2.4.0')]);
    Tag tag = tags[0];
    return Mp3File(
      album: tag.tags['album'] ?? 'unknown',
      artist: tag.tags['artist'] ?? 'unknown',
      fileName: fileName,
      realPath: realPath,
      title: tag.tags['title'] ?? fileName,
    );
  }

  @override
  String toString() {
    return '''
title: ${title}
artist: ${artist}
album: ${album}
fileName: ${fileName}
realPath: ${realPath}
    ''';
  }
}

class DbFileNotExists implements Exception {}

class FileHelper {
  String _dbFileName;
  FileHelper(this._dbFileName);

  Future<String> get _dbFilePath async =>
      path.join((await getApplicationSupportDirectory()).path, _dbFileName);

  Future<String> _getDbFile() async {
    String path = await _dbFilePath;
    File file = new File(path);
    if (!file.existsSync()) {
      throw DbFileNotExists();
    }

    return file.readAsString();
  }

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

  Future<void> addFolder(String folderPath) async {
    List<String> watchingFolders = await getWatchingFolders();
    watchingFolders.add(folderPath);
    await _writeWatchingFolders(watchingFolders);
  }

  Future<void> removeFolder(String folderPath) async {
    List<String> watchingFolders = await getWatchingFolders();
    watchingFolders.remove(folderPath);
    await _writeWatchingFolders(watchingFolders);
  }

  Future<bool> existsFolder(String folderPath) async {
    List<String> folders = await getWatchingFolders();
    return folders.contains(folderPath);
  }

  Future<List<Mp3File>> getMp3Files(String folderPath) async {
    Directory dir = Directory(folderPath);
    return dir
        .list()
        .where((entity) => entity.path.endsWith('.mp3'))
        .asyncMap((entity) => Mp3File.fromFileSystemEntity(entity))
        .map((mp3) {
      print(mp3.toString());
      return mp3;
    }).toList();
  }
}

FileHelper fileHelper = FileHelper('db.json');
